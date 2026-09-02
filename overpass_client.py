"""
overpass_client.py
===================
Thin, resilient client for the OpenStreetMap Overpass API.

No authentication is required to READ data from Overpass — it is a public,
anonymous, read-only query service (this is different from OSM's main
editing API, which does require an OAuth-authenticated account). Rate
limiting on Overpass is applied per-IP, not per-account, which is why this
client:
  - self-throttles between requests (MIN_SECONDS_BETWEEN_REQUESTS)
  - retries with exponential backoff on 429 / 504
  - falls back across multiple public Overpass mirrors
  - sends a descriptive User-Agent (courtesy to the volunteer-run servers)

This module is meant to be run as a scheduled batch job (see
seed_pipeline.py), NOT called live from your mobile app's request path.
"""

import time
import logging
from typing import Dict, List, Tuple

import requests

from config import (
    OVERPASS_ENDPOINTS,
    USER_AGENT,
    MIN_SECONDS_BETWEEN_REQUESTS,
    PLACE_OSM_FILTERS,
)

logger = logging.getLogger("overpass_client")

_last_request_time: float = 0.0


def _self_throttle() -> None:
    """Enforce our own minimum spacing between outbound requests."""
    global _last_request_time
    elapsed = time.time() - _last_request_time
    wait = MIN_SECONDS_BETWEEN_REQUESTS - elapsed
    if wait > 0:
        time.sleep(wait)
    _last_request_time = time.time()


def build_overpass_query(bbox: Tuple[float, float, float, float], category: str) -> str:
    """
    Build an Overpass QL query for one place category within a bounding box.

    bbox is (south, west, north, east) — this matches Overpass's own
    (lat_min, lon_min, lat_max, lon_max) bbox ordering.
    """
    south, west, north, east = bbox
    filters = PLACE_OSM_FILTERS[category]

    # Union of node/way queries for each (key, value) tag pair relevant
    # to this category. `out center;` gives us a single lat/lon even for
    # `way` elements (buildings), not just point `node` elements.
    clauses = "".join(
        f'node["{key}"="{value}"]({south},{west},{north},{east});'
        f'way["{key}"="{value}"]({south},{west},{north},{east});'
        for key, value in filters
    )

    return f"""
    [out:json][timeout:60];
    (
      {clauses}
    );
    out center tags;
    """


def fetch_places_for_category(
    bbox: Tuple[float, float, float, float],
    category: str,
    max_retries: int = 4,
) -> List[Dict]:
    """
    Query Overpass for all elements matching `category` within `bbox`.
    Returns the raw list of Overpass "elements" (each a dict with tags,
    lat/lon or center, and OSM id) — transformation into your Place
    schema happens in place_transformer.py, kept separate on purpose so
    this module stays a pure "talk to Overpass" concern.
    """
    query = build_overpass_query(bbox, category)
    headers = {"User-Agent": USER_AGENT}

    last_error: Exception = RuntimeError("no endpoints configured")

    for endpoint in OVERPASS_ENDPOINTS:
        backoff = 5
        for attempt in range(1, max_retries + 1):
            _self_throttle()
            try:
                logger.info("Querying %s for category=%s attempt=%d", endpoint, category, attempt)
                response = requests.post(
                    endpoint,
                    data={"data": query},
                    headers=headers,
                    timeout=90,
                )

                if response.status_code == 200:
                    payload = response.json()
                    elements = payload.get("elements", [])
                    logger.info("Fetched %d raw elements for %s", len(elements), category)
                    return elements

                if response.status_code in (429, 504):
                    # Rate-limited or server timed out under load — the
                    # Overpass server sometimes reports this only AFTER
                    # running the query, so the wait is on us either way.
                    logger.warning(
                        "Overpass %s returned %d, backing off %ds",
                        endpoint, response.status_code, backoff,
                    )
                    time.sleep(backoff)
                    backoff *= 2
                    continue

                # Any other error status: don't burn retries on this
                # endpoint, move to the next mirror instead.
                logger.warning("Overpass %s returned unexpected status %d", endpoint, response.status_code)
                last_error = RuntimeError(f"HTTP {response.status_code} from {endpoint}")
                break

            except requests.RequestException as exc:
                logger.warning("Request to %s failed: %s", endpoint, exc)
                last_error = exc
                time.sleep(backoff)
                backoff *= 2

    # All endpoints exhausted without success.
    logger.error("All Overpass endpoints failed for category=%s bbox=%s", category, bbox)
    raise last_error
