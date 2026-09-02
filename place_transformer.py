"""
place_transformer.py
=====================
Converts raw Overpass OSM elements into your NaviCare `Place` schema
(the same schema used by recommendation_engine.py).

Kept separate from overpass_client.py so that a change in tag-mapping
logic never requires touching the networking/retry code, and vice versa.
"""

import logging
from typing import Dict, List, Optional

from config import WHEELCHAIR_TRUE_VALUES

logger = logging.getLogger("place_transformer")


def _extract_lat_lon(element: Dict) -> Optional[tuple]:
    """
    OSM 'node' elements have lat/lon directly. 'way' elements (e.g. a
    building outline) don't have a single point — Overpass's `out center`
    clause adds a computed `center: {lat, lon}` for these instead.
    """
    if "lat" in element and "lon" in element:
        return element["lat"], element["lon"]
    center = element.get("center")
    if center and "lat" in center and "lon" in center:
        return center["lat"], center["lon"]
    return None


def transform_osm_element(element: Dict, category: str) -> Optional[Dict]:
    """
    Transform one raw Overpass element into a dict matching your Place
    pydantic model. Returns None if the element is unusable (e.g. no
    coordinates, or no name — a place with no name isn't useful to
    surface as a recommendation).
    """
    tags = element.get("tags", {})
    name = tags.get("name")
    if not name:
        return None

    coords = _extract_lat_lon(element)
    if coords is None:
        return None
    latitude, longitude = coords

    wheelchair_tag = tags.get("wheelchair", "").lower()
    has_wheelchair_ramp = wheelchair_tag in WHEELCHAIR_TRUE_VALUES

    # OSM doesn't have a dedicated "accessible restroom" tag distinct from
    # wheelchair access in general; toilets nodes commonly carry their own
    # wheelchair tag (toilets:wheelchair or wheelchair on the toilets node
    # itself), so check both.
    toilets_wheelchair = tags.get("toilets:wheelchair", "").lower()
    has_accessible_restrooms = (
        wheelchair_tag in WHEELCHAIR_TRUE_VALUES
        or toilets_wheelchair in WHEELCHAIR_TRUE_VALUES
    )

    # No standard OSM tag for braille menus as of now — left False here,
    # intended to be filled in later via your restaurant self-registration
    # flow, not by OSM ingestion.
    has_braille_menu = False

    # `audio_guide=yes` appears occasionally on tourism=museum / attraction
    # nodes; use it where present, otherwise default False.
    has_audio_guides = tags.get("audio_guide", "").lower() == "yes"

    osm_id = element.get("id")
    osm_type = element.get("type", "node")
    # Composite, stable document ID — same OSM element always maps to the
    # same Firestore doc ID, which is what makes re-running this job an
    # idempotent upsert rather than a source of duplicates.
    place_id = f"osm_{osm_type}_{osm_id}"

    return {
        "place_id": place_id,
        "name": name,
        "category": category,
        "has_wheelchair_ramp": has_wheelchair_ramp,
        "has_accessible_restrooms": has_accessible_restrooms,
        "has_braille_menu": has_braille_menu,
        "has_audio_guides": has_audio_guides,
        "latitude": latitude,
        "longitude": longitude,
    }


def transform_elements(elements: List[Dict], category: str) -> List[Dict]:
    """Batch version of transform_osm_element, silently skipping unusable elements."""
    transformed = []
    skipped = 0
    for element in elements:
        result = transform_osm_element(element, category)
        if result is not None:
            transformed.append(result)
        else:
            skipped += 1

    if skipped:
        logger.info("Skipped %d elements for category=%s (missing name/coords)", skipped, category)

    return transformed
