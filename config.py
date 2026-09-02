"""
config.py
=========
Central configuration for the NaviCare data-ingestion pipeline.

Keep all "things that change often" (cities, bounding boxes, OSM tag
mappings, endpoints) here so the fetch/transform/write code never needs
to be touched when you expand to a new city.
"""

# ---------------------------------------------------------------------------
# Overpass endpoints
# ---------------------------------------------------------------------------
# Overpass is community-run. Using more than one mirror with fallback
# protects you from a single instance's rate-limit/downtime.
OVERPASS_ENDPOINTS = [
    "https://overpass-api.de/api/interpreter",
    "https://overpass.kumi.systems/api/interpreter",
    "https://overpass.openstreetmap.ru/api/interpreter",
]

# Be a good citizen: identify your app. Overpass instances are run by
# volunteers — a descriptive User-Agent helps them help you if something
# goes wrong, and some instances soft-block requests with no/blank UA.
USER_AGENT = "NaviCare-DataIngestion/1.0 (contact: your-email@example.com)"

# Self-imposed pacing between requests, independent of server-side cooldowns.
# Keeps you comfortably under the ~10,000 req/day, ~1GB/day guideline even
# if you scale to querying dozens of cities.
MIN_SECONDS_BETWEEN_REQUESTS = 5

# ---------------------------------------------------------------------------
# Cities to seed (bounding boxes: south, west, north, east)
# ---------------------------------------------------------------------------
# Start with a short list; add cities incrementally rather than querying
# all of India in one bbox (that single query would be huge, slow, and
# likely to get rejected for exceeding server memory/time limits).
CITY_BBOXES = {
    "Chennai":   (12.9000, 80.1500, 13.2300, 80.3300),
    "Bengaluru": (12.8300, 77.4500, 13.1400, 77.7800),
    "Mumbai":    (18.8900, 72.7700, 19.2700, 72.9800),
    "Delhi":     (28.4000, 76.8300, 28.8800, 77.3500),
}

# ---------------------------------------------------------------------------
# Place categories we care about, mapped to OSM tag filters
# ---------------------------------------------------------------------------
# Each entry becomes one clause in the Overpass query.
# category -> list of (OSM key, OSM value) tag filters
PLACE_OSM_FILTERS = {
    "Restaurant": [("amenity", "restaurant"), ("amenity", "cafe")],
    "Hotel": [("tourism", "hotel"), ("tourism", "guest_house")],
    "Tourist Spot": [("tourism", "attraction"), ("tourism", "museum")],
    "Restroom": [("amenity", "toilets")],
}

# ---------------------------------------------------------------------------
# OSM accessibility tag -> your Place schema boolean fields
# ---------------------------------------------------------------------------
# OSM's `wheelchair` tag is tri-state text ("yes" / "limited" / "no"),
# not boolean, so we map explicitly rather than doing a naive truthy check.
WHEELCHAIR_TRUE_VALUES = {"yes", "limited"}

# There is no widely-adopted OSM tag for "braille menu" today, so OSM will
# almost never supply has_braille_menu — it stays False from ingestion and
# is expected to be filled in later by the place owner via your
# hotel/restaurant self-registration screens. Same caveat for audio guides,
# though `audio_guide=yes` does appear occasionally on tourism=museum nodes.

# ---------------------------------------------------------------------------
# Firestore
# ---------------------------------------------------------------------------
FIRESTORE_PLACES_COLLECTION = "accessible_places"

# Path to your Firebase service-account JSON (Application Default
# Credentials also work if running on GCP infra — see firestore_writer.py).
FIREBASE_SERVICE_ACCOUNT_PATH = "service-account.json"

# NOTE: NGO Darpan / data.gov.in ingestion was part of an earlier plan and
# has been removed. If you bring back an NGO/community feature later, the
# old ngo_csv_importer.py logic (CSV column mapping, etc.) is a reasonable
# starting point to resurrect from version history.
