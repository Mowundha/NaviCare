"""
recommendation_engine.py
=========================
NaviCare — Core Recommendation & Matching Engine

Handles:
  1. Accessible place recommendations (Haversine distance + accessibility scoring)
  2. Caretaker matching (availability, capability, gender preference with fallback)

Dependencies:
  pip install pydantic
"""

from __future__ import annotations

import math
from typing import List, Optional
from pydantic import BaseModel, Field
from app.models.enums import VerificationStatus

# ---------------------------------------------------------------------------
# Data Models
# ---------------------------------------------------------------------------

class UserProfile(BaseModel):
    user_id: str
    full_name: str
    gender: str  # 'Male', 'Female', 'other'
    disability_types: List[str] = Field(default_factory=list)
    Current_latitude: float
    Current_longitude: float


class Caretaker(BaseModel):
    caretaker_id: str
    full_name: str
    gender: str  # 'Male', 'Female', 'others'
    supported_disabilities: List[str] = Field(default_factory=list)
    verification_status: VerificationStatus
    is_available: bool
    latitude: float
    longitude: float


class Place(BaseModel):
    place_id: str
    name: str
    category: str  # 'Restaurant', 'Hotel', 'Tourist Spot', 'Restroom'
    has_wheelchair_ramp: bool
    has_accessible_restrooms: bool
    has_braille_menu: bool
    has_audio_guides: bool
    verification_status: VerificationStatus
    latitude: float
    longitude: float

# ---------------------------------------------------------------------------
# Result / Output Models
# ---------------------------------------------------------------------------

class RankedPlace(BaseModel):
    place: Place
    distance_km: float
    accessibility_score: float


class RankedCaretaker(BaseModel):
    caretaker: Caretaker
    distance_km: float


class CaretakerMatchResult(BaseModel):
    status: str  # "MATCH_FOUND" | "GENDER_UNAVAILABLE_FALLBACK" | "NO_CARETAKER_AVAILABLE"
    message: Optional[str] = None
    matches: List[RankedCaretaker] = Field(default_factory=list)
    fallback_recommendations: List[RankedCaretaker] = Field(default_factory=list)



# ---------------------------------------------------------------------------
# Spatial Utility
# ---------------------------------------------------------------------------

EARTH_RADIUS_KM = 6371.0088


def haversine_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """
    Great-circle distance between two lat/lon points in kilometers.
    """
    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    d_phi = math.radians(lat2 - lat1)
    d_lambda = math.radians(lon2 - lon1)

    a = (
        math.sin(d_phi / 2.0) ** 2
        + math.cos(phi1) * math.cos(phi2) * math.sin(d_lambda / 2.0) ** 2
    )
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return EARTH_RADIUS_KM * c


# ---------------------------------------------------------------------------
# Accessibility Scoring
# ---------------------------------------------------------------------------

# Maps a user's disability type to the Place accessibility flags that are
# relevant to it. A place accumulates score points for each relevant flag
# it satisfies, across all of the user's disability types.
DISABILITY_TO_PLACE_FLAGS = {
    "visual": ["has_braille_menu", "has_audio_guides"],
    "auditory": ["has_audio_guides"],
    "mobility": ["has_wheelchair_ramp", "has_accessible_restrooms"],
    "cognitive": ["has_audio_guides"],
}


def compute_accessibility_score(user: UserProfile, place: Place) -> float:
    """
    Score = number of relevant accessibility flags satisfied by the place,
    normalized against the maximum possible relevant flags for this user's
    disability profile (so score is comparable between users). Additionally,
    has_wheelchair_ramp / has_accessible_restrooms are treated as
    baseline-useful for every disability type since general accessibility
    infrastructure benefits nearly all users.
    """
    relevant_flags = set()
    for d_type in user.disability_types:
        relevant_flags.update(DISABILITY_TO_PLACE_FLAGS.get(d_type.lower(), []))

    # Baseline flags relevant to everyone regardless of specific disability type.
    baseline_flags = {"has_wheelchair_ramp", "has_accessible_restrooms"}
    relevant_flags.update(baseline_flags)

    if not relevant_flags:
        return 0.0

    satisfied = sum(1 for flag in relevant_flags if getattr(place, flag, False))
    return round(satisfied / len(relevant_flags), 4)


# ---------------------------------------------------------------------------
# 1. Place Recommendation
# ---------------------------------------------------------------------------

def recommend_places(
    user: UserProfile,
    places: List[Place],
    max_distance_km: float = 10.0,
) -> List[RankedPlace]:
    """
    Recommend accessible places within max_distance_km, ranked by a
    combination of proximity and accessibility feature coverage.

    Ranking: primarily by accessibility_score (descending), then by
    distance_km (ascending) as a tie-breaker — a place that is both
    close AND highly accessible should surface first.
    """
    candidates: List[RankedPlace] = []

    for place in places:
        if place.verification_status != VerificationStatus.VERIFIED:
             continue
        distance = haversine_distance(
            user.Current_latitude,
              user.Current_longitude,
            place.latitude,
              place.longitude,
        )

        # Hard filter: distance
        if distance > max_distance_km:
            continue

        score = compute_accessibility_score(user, place)

        candidates.append(
            RankedPlace(place=place, distance_km=round(distance, 3), accessibility_score=score)
        )

    # Rank: higher accessibility score first, then closer distance first.
    candidates.sort(key=lambda rp: (-rp.accessibility_score, rp.distance_km))
    return candidates


# ---------------------------------------------------------------------------
# 2. Caretaker Matching
# ---------------------------------------------------------------------------

def match_caretakers(
    user: UserProfile,
    caretakers: List[Caretaker],
    max_distance_km: float = 15.0,
) -> CaretakerMatchResult:
    """
    Match caretakers to a user based on availability, distance, disability
    capability, and gender preference — with a graceful fallback when no
    same-gender caretaker is available nearby.
    """
    user_disability_set = {d.lower() for d in user.disability_types}
    user_gender = user.gender.strip().lower()

    eligible: List[RankedCaretaker] = []

    for caretaker in caretakers:
        # Hard filter: availability
        if caretaker.verification_status != VerificationStatus.VERIFIED:
            continue
        if not caretaker.is_available:
            continue

        distance = haversine_distance(
            user.Current_latitude, user.Current_longitude,
            caretaker.latitude, caretaker.longitude,
        )

        # Hard filter: distance
        if distance > max_distance_km:
            continue

        # Capability filter: at least one overlapping disability match
        caretaker_capabilities = {c.lower() for c in caretaker.supported_disabilities}
        if user_disability_set and not (user_disability_set & caretaker_capabilities):
            continue

        eligible.append(RankedCaretaker(caretaker=caretaker, distance_km=round(distance, 3)))

    if not eligible:
        return CaretakerMatchResult(
            status="NO_CARETAKER_AVAILABLE",
            message="No available caretakers matching the required capabilities were found nearby.",
            matches=[],
            fallback_recommendations=[],
        )

    # Split eligible pool into same-gender vs opposite-gender.
    same_gender = [
        rc for rc in eligible
        if rc.caretaker.gender.strip().lower() == user_gender
    ]
    opposite_gender = [rc for rc in eligible if rc not in same_gender]

    same_gender.sort(key=lambda rc: rc.distance_km)
    opposite_gender.sort(key=lambda rc: rc.distance_km)

    if same_gender:
        return CaretakerMatchResult(
            status="MATCH_FOUND",
            message=None,
            matches=same_gender,
            fallback_recommendations=[],
        )

    # No same-gender caretaker nearby -> fallback messaging
    fallback_gender_label = "female" if user_gender == "female" else (
        "male" if user_gender == "male" else "preferred-gender"
    )
    message = f"No {fallback_gender_label} caretaker available nearby."

    return CaretakerMatchResult(
        status="GENDER_UNAVAILABLE_FALLBACK",
        message=message,
        matches=[],
        fallback_recommendations=opposite_gender,
    )


# ---------------------------------------------------------------------------
# Test / Demo Block
# ---------------------------------------------------------------------------

if __name__ == "__main__":

    def _print_header(title: str) -> None:
        print("\n" + "=" * 70)
        print(title)
        print("=" * 70)

    # -----------------------------------------------------------------
    # Mock Users
    # -----------------------------------------------------------------
    user_female = UserProfile(
        user_id="U001",
        full_name="Anjali Rao",
        gender="Female",
        disability_types=["mobility", "visual"],
        Current_latitude=13.0827,   # Chennai
        Current_longitude=80.2707,
    )

    user_male = UserProfile(
        user_id="U002",
        full_name="Rajesh Kumar",
        gender="Male",
        disability_types=["auditory"],
        Current_latitude=13.0827,
        Current_longitude=80.2707,
    )

    # -----------------------------------------------------------------
    # Mock Places
    # -----------------------------------------------------------------
    places = [
        Place(
            place_id="P001", name="Marina Accessible Cafe", category="Restaurant",
            has_wheelchair_ramp=True, has_accessible_restrooms=True,
            has_braille_menu=True, has_audio_guides=False,
            latitude=13.0500, longitude=80.2824,
        ),
        Place(
            place_id="P002", name="Hotel Comfort Stay", category="Hotel",
            has_wheelchair_ramp=True, has_accessible_restrooms=True,
            has_braille_menu=False, has_audio_guides=False,
            latitude=13.0900, longitude=80.2750,
        ),
        Place(
            place_id="P003", name="City Heritage Museum", category="Tourist Spot",
            has_wheelchair_ramp=True, has_accessible_restrooms=True,
            has_braille_menu=True, has_audio_guides=True,
            latitude=13.0605, longitude=80.2496,
        ),
        Place(
            place_id="P004", name="Far Away Restroom", category="Restroom",
            has_wheelchair_ramp=True, has_accessible_restrooms=True,
            has_braille_menu=False, has_audio_guides=False,
            latitude=13.5000, longitude=80.5000,  # >10km away, should be filtered out
        ),
    ]

    # -----------------------------------------------------------------
    # Mock Caretakers
    # Scenario: female user, NO female caretaker available nearby ->
    # triggers GENDER_UNAVAILABLE_FALLBACK with male recommendations.
    # -----------------------------------------------------------------
    caretakers = [
        Caretaker(
            caretaker_id="C001", full_name="Suresh Babu", gender="Male",
            supported_disabilities=["mobility", "visual_impairment", "elderly_care"],
                verification_status=VerificationStatus.VERIFIED,
            is_available=True,
            latitude=13.0700, longitude=80.2650,
        ),
        Caretaker(
            caretaker_id="C002", full_name="Karthik Iyer", gender="Male",
            supported_disabilities=["mobility", "elderly_care"],
                verification_status=VerificationStatus.VERIFIED,
            is_available=True,
            latitude=13.1200, longitude=80.2900,
        ),
        Caretaker(
            caretaker_id="C003", full_name="Priya Sharma", gender="Female",
            supported_disabilities=["auditory"],
            verification_status=VerificationStatus.VERIFIED,
  # does not match user_female's needs
            is_available=True,
            latitude=13.0650, longitude=80.2600,
        ),
        Caretaker(
            caretaker_id="C004", full_name="Deepa Nair", gender="Female",
            supported_disabilities=["mobility", "visual_impairment"],
                verification_status=VerificationStatus.VERIFIED,
            is_available=False,  # unavailable -> excluded
            latitude=13.0800, longitude=80.2700,
        ),
    ]

    # -----------------------------------------------------------------
    # 1. Place Recommendations
    # -----------------------------------------------------------------
    _print_header("PLACE RECOMMENDATIONS for Anjali (mobility + visual)")
    ranked_places = recommend_places(user_female, places, max_distance_km=10.0)
    for rp in ranked_places:
        print(
            f"- {rp.place.name:28s} | dist={rp.distance_km:6.2f} km "
            f"| access_score={rp.accessibility_score:.2f}"
        )

    # -----------------------------------------------------------------
    # 2. Caretaker Matching — Female user, no female caretaker nearby
    # -----------------------------------------------------------------
    _print_header("CARETAKER MATCH for Anjali (Female) — expect fallback")
    result_female = match_caretakers(user_female, caretakers, max_distance_km=15.0)
    print(f"status : {result_female.status}")
    print(f"message: {result_female.message}")
    if result_female.matches:
        print("matches:")
        for rc in result_female.matches:
            print(f"  - {rc.caretaker.full_name} ({rc.caretaker.gender}) | {rc.distance_km} km")
    if result_female.fallback_recommendations:
        print("fallback_recommendations:")
        for rc in result_female.fallback_recommendations:
            print(f"  - {rc.caretaker.full_name} ({rc.caretaker.gender}) | {rc.distance_km} km")

    assert result_female.status == "GENDER_UNAVAILABLE_FALLBACK"
    assert result_female.fallback_recommendations, "Expected fallback recommendations to be non-empty"
    assert all(
        rc.caretaker.gender.strip().lower() == "male"
        for rc in result_female.fallback_recommendations
    )
    print("\n[OK] Fallback scenario verified: no female caretaker nearby -> male fallback returned.")

    # -----------------------------------------------------------------
    # 2b. Caretaker Matching — Male user (control case, same-gender match exists)
    # -----------------------------------------------------------------
    _print_header("CARETAKER MATCH for Rajesh (Male) — control case")
    caretaker_male_pool = caretakers + [
        Caretaker(
            caretaker_id="C005", full_name="Vikram Das", gender="Male",
            supported_disabilities=["auditory", "elderly_care"],
            is_available=True,
            latitude=13.0850, longitude=80.2720,
        )
    ]
    result_male = match_caretakers(user_male, caretaker_male_pool, max_distance_km=15.0)
    print(f"status : {result_male.status}")
    if result_male.matches:
        for rc in result_male.matches:
            print(f"  - {rc.caretaker.full_name} ({rc.caretaker.gender}) | {rc.distance_km} km")

