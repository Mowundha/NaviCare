"""
Travel planning service for NaviCare.

Responsibilities:
- Generate real public-transit journeys using the Google Routes API.
- Recommend accessible places around the destination.
- Match suitable caretakers around the destination.
- Find nearby NaviCare communities.
- Persist the generated travel plan in Firestore.

Transit routing is delegated to transit_provider.
Place/caretaker recommendation logic is delegated to recommendation_engine.
"""

from app.core.firestore_client import FirestoreRepository
from app.models.directory import AccessiblePlace, TransitNode
from app.models.travel_plan import (
    TransitSearchRequest,
    TravelPlan,
    TravelPlanCreate,
)
from app.models.user import User
from app.services import community_service
from app.services import recommendation_engine as rec
from app.services import transit_provider
from app.services.auth_service import caretaker_repo, user_repo


# ---------------------------------------------------------------------------
# Firestore repositories
# ---------------------------------------------------------------------------

transit_repo = FirestoreRepository(
    "Transit_Nodes",
    TransitNode,
    "transit_id",
)

place_repo = FirestoreRepository(
    "Accessible_Places",
    AccessiblePlace,
    "place_id",
)

plan_repo = FirestoreRepository(
    "Travel_Plans",
    TravelPlan,
    "plan_id",
)


# ---------------------------------------------------------------------------
# Transit
# ---------------------------------------------------------------------------

def search_transit(payload: TransitSearchRequest):
    """
    Search real public-transit journeys using Google Routes API.

    The provider returns complete journeys containing:
        WALK → BUS → WALK → BUS → WALK

    rather than separate fake train/bus schedules.

    No booking is performed here.
    """

    return transit_provider.search_transit_routes(payload)


# ---------------------------------------------------------------------------
# Recommendation user adapter
# ---------------------------------------------------------------------------

def _to_rec_user(
    user: User,
    latitude: float,
    longitude: float,
) -> rec.UserProfile:
    """
    Convert our User model into the recommendation engine's
    UserProfile model.

    Coordinates represent the destination because accessible
    places and caretakers should be recommended around the
    destination, not around the user's current location.
    """

    return rec.UserProfile(
        user_id=user.user_id,
        full_name=user.full_name,
        gender=user.gender or "",
        disability_types=user.disability_types,
        Current_latitude=latitude,
        Current_longitude=longitude,
    )


# ---------------------------------------------------------------------------
# Travel plan retrieval
# ---------------------------------------------------------------------------

def get_plan(plan_id: str) -> TravelPlan | None:
    return plan_repo.get(plan_id)


# ---------------------------------------------------------------------------
# Travel plan generation
# ---------------------------------------------------------------------------

def generate_plan(payload: TravelPlanCreate) -> TravelPlan:
    """
    Generate and persist a complete NaviCare travel plan.

    The generated plan contains:

    1. Real public-transit journeys
    2. Accessible-place recommendations
    3. Caretaker recommendations
    4. Nearby NaviCare communities
    """

    # -----------------------------------------------------------------------
    # 1. Get user
    # -----------------------------------------------------------------------

    user = user_repo.get(payload.user_id)

    if not user:
        raise ValueError("User not found")

    # -----------------------------------------------------------------------
    # 2. Build recommendation profile around DESTINATION
    # -----------------------------------------------------------------------

    rec_user = _to_rec_user(
        user,
        payload.destination_latitude,
        payload.destination_longitude,
    )

    # -----------------------------------------------------------------------
    # 3. Load accessible places
    # -----------------------------------------------------------------------

    places = [
        rec.Place(
            place_id=p.place_id,
            name=p.name,
            category=p.category,
            has_wheelchair_ramp=p.has_wheelchair_ramp,
            has_accessible_restrooms=p.has_accessible_restrooms,
            has_braille_menu=p.has_braille_menu,
            has_audio_guides=p.has_audio_guides,
            verification_status=p.verification_status,
            latitude=p.latitude,
            longitude=p.longitude,
        )
        for p in place_repo.list_all(limit=500)
    ]

    # -----------------------------------------------------------------------
    # 4. Load caretakers
    # -----------------------------------------------------------------------

    caretakers = [
        rec.Caretaker(
            caretaker_id=c.caretaker_id,
            full_name=c.full_name,
            gender=c.gender,
            supported_disabilities=c.supported_disabilities,
            verification_status=c.verification_status,
            is_available=c.is_available,
            latitude=c.latitude or 0.0,
            longitude=c.longitude or 0.0,
        )
        for c in caretaker_repo.list_all(limit=500)
    ]

    # -----------------------------------------------------------------------
    # 5. Run recommendation engine
    # -----------------------------------------------------------------------

    recommended_places = rec.recommend_places(
        rec_user,
        places,
    )

    caretaker_match = rec.match_caretakers(
        rec_user,
        caretakers,
    )

    # -----------------------------------------------------------------------
    # 6. Search REAL transit routes
    # -----------------------------------------------------------------------

    transit_request = TransitSearchRequest(
        source_latitude=user.Current_latitude or 0.0,
        source_longitude=user.Current_longitude or 0.0,
        destination_name=payload.destination_name,
        destination_latitude=payload.destination_latitude,
        destination_longitude=payload.destination_longitude,
        travel_date=payload.start_date,
        preference="LESS_WALKING",
    )

    transit_journeys = search_transit(transit_request)

    # -----------------------------------------------------------------------
    # 7. Find nearby NaviCare communities
    # -----------------------------------------------------------------------

    nearby_communities = (
        community_service.find_communities_near_destination(
            payload.destination_name
        )
    )

    # -----------------------------------------------------------------------
    # 8. Select caretaker recommendations according to match status
    # -----------------------------------------------------------------------

    if caretaker_match.status == "MATCH_FOUND":

        caretaker_list = caretaker_match.matches

    elif caretaker_match.status == "GENDER_UNAVAILABLE_FALLBACK":

        caretaker_list = caretaker_match.fallback_recommendations

    else:
        # NO_CARETAKER_AVAILABLE
        caretaker_list = []

    # -----------------------------------------------------------------------
    # 9. Build itinerary data
    # -----------------------------------------------------------------------

    itinerary_data = {

        # ---------------------------------------------------------------
        # Real Google transit journeys
        # ---------------------------------------------------------------
        "transit_journeys": [
            journey.model_dump(mode="json")
            for journey in transit_journeys
        ],

        # ---------------------------------------------------------------
        # Accessible places
        # ---------------------------------------------------------------
        "recommended_places": [
            {
                "place_id": rp.place.place_id,
                "name": rp.place.name,
                "category": rp.place.category,
                "distance_km": rp.distance_km,
                "accessibility_score": rp.accessibility_score,
                "verification_status": rp.place.verification_status,
            }
            for rp in recommended_places
        ],

        # ---------------------------------------------------------------
        # Caretaker matching
        # ---------------------------------------------------------------
        "caretaker_match": {
            "status": caretaker_match.status,

            **(
                {"message": caretaker_match.message}
                if caretaker_match.message
                else {}
            ),

            "recommendations": [
                {
                    "caretaker_id": rc.caretaker.caretaker_id,
                    "full_name": rc.caretaker.full_name,
                    "distance_km": rc.distance_km,
                }
                for rc in caretaker_list
            ],
        },

        # ---------------------------------------------------------------
        # NaviCare communities
        # ---------------------------------------------------------------
        "nearby_communities": [
            community.model_dump(mode="json")
            for community in nearby_communities
        ],
    }

    # -----------------------------------------------------------------------
    # 10. Create TravelPlan
    # -----------------------------------------------------------------------

    plan = TravelPlan(
        plan_id=plan_repo.generate_id(),
        user_id=payload.user_id,
        destination_name=payload.destination_name,
        start_date=payload.start_date,
        end_date=payload.end_date,
        itinerary_data=itinerary_data,
    )

    # -----------------------------------------------------------------------
    # 11. Persist in Firestore
    # -----------------------------------------------------------------------

    return plan_repo.create(plan)