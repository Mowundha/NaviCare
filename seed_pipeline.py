"""
seed_pipeline.py
=================
Orchestrates the full NaviCare data-ingestion job:

  1. For each configured city bounding box and place category:
       Overpass fetch -> transform -> Firestore upsert
  2. NGO Darpan CSV -> transform -> Firestore upsert

Run this manually the first time to seed your database:
    python seed_pipeline.py

Then deploy it as a scheduled job (see the deployment notes at the bottom
of this file) so places/NGOs stay reasonably fresh without ever being a
live dependency in your app's request path.
"""

import logging
import sys

from config import CITY_BBOXES, PLACE_OSM_FILTERS
from overpass_client import fetch_places_for_category
from place_transformer import transform_elements
from firestore_writer import upsert_places, upsert_ngos
from ngo_csv_importer import load_ngo_csv

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("seed_pipeline")


def run_places_ingestion() -> None:
    total_written = 0

    for city, bbox in CITY_BBOXES.items():
        for category in PLACE_OSM_FILTERS:
            logger.info("=== %s / %s ===", city, category)
            try:
                raw_elements = fetch_places_for_category(bbox, category)
            except Exception as exc:
                # One city/category failing (e.g. that Overpass mirror is
                # down) shouldn't abort the entire run — log and continue,
                # this category/city will simply catch up on next run.
                logger.error("Failed to fetch %s/%s: %s", city, category, exc)
                continue

            transformed = transform_elements(raw_elements, category)
            if not transformed:
                logger.info("No usable places for %s/%s", city, category)
                continue

            written = upsert_places(transformed)
            total_written += written
            logger.info("Upserted %d places for %s/%s", written, city, category)

    logger.info("Places ingestion complete. Total upserted: %d", total_written)


def run_ngo_ingestion() -> None:
    try:
        records = load_ngo_csv()
    except FileNotFoundError:
        logger.warning(
            "NGO CSV not found — skipping NGO ingestion this run. "
            "Download the latest NGO Darpan export from data.gov.in and "
            "update NGO_CSV_PATH in config.py."
        )
        return

    if not records:
        logger.warning("NGO CSV parsed but yielded zero usable records — check NGO_CSV_COLUMN_MAP.")
        return

    written = upsert_ngos(records)
    logger.info("NGO ingestion complete. Total upserted: %d", written)


def main() -> None:
    logger.info("Starting NaviCare data-ingestion pipeline")
    run_places_ingestion()
    run_ngo_ingestion()
    logger.info("Pipeline run finished.")


if __name__ == "__main__":
    sys.exit(main())


# ---------------------------------------------------------------------------
# Deployment notes (not executed — reference for when you move this off
# your laptop and onto a schedule)
# ---------------------------------------------------------------------------
#
# Recommended: Cloud Run Job + Cloud Scheduler, rather than a long-lived
# Cloud Function, since a full multi-city Overpass crawl can run long and
# a Cloud Run Job has no execution-time ceiling like HTTP Cloud Functions do.
#
#   1. Containerize this folder (Dockerfile: python:3.11-slim, pip install
#      -r requirements.txt, CMD ["python", "seed_pipeline.py"]).
#   2. Deploy as a Cloud Run Job:
#        gcloud run jobs create navicare-seed-job --source . --region asia-south1
#   3. Schedule it with Cloud Scheduler (weekly for places, since OSM POI
#      data changes slowly; monthly is enough once NGO ingestion is split
#      into its own job):
#        gcloud scheduler jobs create http navicare-seed-weekly \
#          --schedule="0 3 * * 1" \
#          --uri="<Cloud Run Jobs REST trigger URI>" \
#          --http-method=POST \
#          --oidc-service-account-email=<your-service-account>
#   4. Give that service account's identity Firestore write access via IAM
#      (roles/datastore.user) instead of shipping a service-account JSON
#      key file into the container — use Application Default Credentials
#      (firebase_admin.initialize_app() with no args) when running on GCP.
