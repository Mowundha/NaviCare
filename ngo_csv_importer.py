"""
ngo_csv_importer.py
=====================
Imports NGO directory data from a data.gov.in / NGO Darpan CSV export into
the shape expected by firestore_writer.upsert_ngos().

Why CSV instead of a live API: data.gov.in mostly publishes NGO Darpan as
downloadable dataset files (CSV/XML resource exports on the dataset page),
not as a stable, authenticated, real-time query API. That's fine for this
use case — NGO directories don't change fast enough to justify live
queries, so treat it as: download the latest export monthly -> run this
importer -> Firestore. No live dependency on data.gov.in at request time.

NOTE: Column names in data.gov.in exports vary between dataset versions,
so NGO_CSV_COLUMN_MAP in config.py is the one thing to double check /
update after each fresh download (open the CSV once, confirm headers).
"""

import csv
import logging
from typing import Dict, List, Optional

from config import NGO_CSV_PATH, NGO_CSV_COLUMN_MAP

logger = logging.getLogger("ngo_csv_importer")


def _parse_float(value: str) -> Optional[float]:
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def _parse_services(raw: str) -> List[str]:
    """
    NGO Darpan sector/service fields are typically semicolon or comma
    delimited free text (e.g. "Disability; Health; Education"). Split and
    clean rather than assuming a strict delimiter.
    """
    if not raw:
        return []
    for delimiter in (";", "|", ","):
        if delimiter in raw:
            return [part.strip() for part in raw.split(delimiter) if part.strip()]
    return [raw.strip()]


def load_ngo_csv(path: str = NGO_CSV_PATH) -> List[Dict]:
    """
    Read the NGO Darpan CSV export and return a list of dicts matching
    the NGO schema used by firestore_writer.upsert_ngos(). Rows missing
    usable coordinates are skipped and logged, since a record with no
    lat/lon can't be distance-ranked by fetch_nearby_ngos().
    """
    records: List[Dict] = []
    skipped = 0

    with open(path, newline="", encoding="utf-8-sig") as csvfile:
        reader = csv.DictReader(csvfile)

        for row in reader:
            try:
                latitude = _parse_float(row.get(NGO_CSV_COLUMN_MAP["latitude"], ""))
                longitude = _parse_float(row.get(NGO_CSV_COLUMN_MAP["longitude"], ""))

                if latitude is None or longitude is None:
                    skipped += 1
                    continue

                record = {
                    "ngo_id": row.get(NGO_CSV_COLUMN_MAP["ngo_id"], "").strip(),
                    "organization_name": row.get(NGO_CSV_COLUMN_MAP["organization_name"], "").strip(),
                    "services_offered": _parse_services(
                        row.get(NGO_CSV_COLUMN_MAP["services_offered"], "")
                    ),
                    "operating_city": row.get(NGO_CSV_COLUMN_MAP["operating_city"], "").strip(),
                    "latitude": latitude,
                    "longitude": longitude,
                }

                if not record["ngo_id"] or not record["organization_name"]:
                    skipped += 1
                    continue

                records.append(record)

            except Exception as exc:  # malformed row — skip, don't crash the whole import
                logger.warning("Skipping malformed NGO row: %s (%s)", row, exc)
                skipped += 1

    logger.info("Parsed %d usable NGO records from %s (skipped %d)", len(records), path, skipped)
    return records
