"""
firestore_writer.py
=====================
Writes transformed Place records into Firestore.

Adds a `geohash` field to every document at write time — this is the field
your app's live geo-queries will range-query against (see the architecture
notes: Firestore has no native radius query, so geohash + Haversine
refinement is the standard pattern).

Uses Firestore's `batch()` writes (max 500 ops per batch) so seeding
thousands of places doesn't mean thousands of round-trips, and uses
`.set(doc, merge=True)` keyed by a stable ID so re-running the job upserts
rather than duplicating records.
"""

import logging
from typing import Dict, Iterable, List

import pygeohash as pgh
import firebase_admin
from firebase_admin import credentials, firestore

from config import (
    FIREBASE_SERVICE_ACCOUNT_PATH,
    FIRESTORE_PLACES_COLLECTION,
)

logger = logging.getLogger("firestore_writer")

# Geohash precision 7 ≈ ~150m x ~150m cells — a good default granularity
# for city-scale "nearby" queries without over- or under-fetching.
GEOHASH_PRECISION = 7

_BATCH_LIMIT = 500


def _init_firestore():
    """
    Initialize the Firebase Admin SDK exactly once per process.
    On GCP infrastructure (Cloud Functions/Cloud Run), omit the service
    account file entirely and use Application Default Credentials instead:
        firebase_admin.initialize_app()
    Locally, a downloaded service-account JSON is simplest.
    """
    if not firebase_admin._apps:
        cred = credentials.Certificate(FIREBASE_SERVICE_ACCOUNT_PATH)
        firebase_admin.initialize_app(cred)
    return firestore.client()


def _chunk(items: List[Dict], size: int) -> Iterable[List[Dict]]:
    for i in range(0, len(items), size):
        yield items[i : i + size]


def _with_geohash(record: Dict) -> Dict:
    record = dict(record)
    record["geohash"] = pgh.encode(
        record["latitude"], record["longitude"], precision=GEOHASH_PRECISION
    )
    return record


def upsert_places(records: List[Dict]) -> int:
    """
    Upsert Place records into Firestore, keyed by `place_id` (e.g.
    "osm_node_123456789"). Returns the number of records written.
    """
    db = _init_firestore()
    collection = db.collection(FIRESTORE_PLACES_COLLECTION)

    written = 0
    for chunk in _chunk(records, _BATCH_LIMIT):
        batch = db.batch()
        for record in chunk:
            record = _with_geohash(record)
            doc_ref = collection.document(record["place_id"])
            batch.set(doc_ref, record, merge=True)
        batch.commit()
        written += len(chunk)
        logger.info("Committed batch of %d place records (%d total so far)", len(chunk), written)

    return written
