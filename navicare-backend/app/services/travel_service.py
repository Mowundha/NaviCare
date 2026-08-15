"""
Travel planning: transit search (merged with Transit_Nodes accessibility
flags) and itinerary generation. Place/caretaker recommendation logic is
delegated entirely to recommendation_engine (the ML teammate's module) —
this file only adapts our Firestore models to/from it and persists results.
"""
from app.core.firestore_client import FirestoreRepository
from app.models.directory import AccessiblePlace, TransitNode
from app.models.travel_plan import TransitOption, TransitSearchRequest, TravelPlan, TravelPlanCreate
from app.models.user import User
from app.services import community_service
from app.services import recommendation_engine as rec
from app.services import transit_provider
from app.services.auth_service import caretaker_repo, user_repo

transit_repo = FirestoreRepository("Transit_Nodes", TransitNode, "transit_id")
place_repo = FirestoreRepository("Accessible_Places", AccessiblePlace, "place_id")
plan_repo = FirestoreRepository("Travel_Plans", TravelPlan, "plan_id")


def _find_nearest_transit_node(latitude: float, longitude: float, max_distance_km: float = 25.0) -> TransitNode | None:
    # NOTE: fine for a small dataset; if Transit_Nodes grows large, replace
    # list_all() with a geohash-bounded Firestore query instead of scanning all docs.
    nearest, nearest_dist = None, None
    for node in transit_repo.list_all(limit=500):
        d = rec.haversine_distance(latitude, longitude, node.latitude, node.longitude)
        if d <= max_distance_km and (nearest_dist is None or d < nearest_dist):
            nearest, nearest_dist = node, d
    return nearest


def search_transit(payload: TransitSearchRequest) -> list[TransitOption]:
    node = _find_nearest_transit_node(payload.source_latitude, payload.source_longitude)

    options: list[TransitOption] = []
    for mode, provider_fn in (("train", transit_provider.get_train_options), ("bus", transit_provider.get_bus_options)):
        for entry in provider_fn(payload.destination_name):
            options.append(
                TransitOption(
                    transit_id=node.transit_id if node else None,
                    mode=mode,
                    name=entry["name"],
                    boarding_time=entry["boarding_time"],
                    duration=entry["duration"],
                    arrival_time=entry["arrival_time"],
                    wheelchair_lift_working=node.wheelchair_lift_working if node else None,
                    tactile_flooring_present=node.tactile_flooring_present if node else None,
                    specialized_coach_available=entry.get("specialized_coach_available"),
                )
            )
    return options


def _to_rec_user(user: User, latitude: float, longitude: float) -> rec.UserProfile:
    return rec.UserProfile(
        user_id=user.user_id,
        full_name=user.full_name,
        gender=user.gender or "",
        disability_types=user.disability_types,
        Current_latitude=latitude,
        Current_longitude=longitude,
    )


def get_plan(plan_id: str) -> TravelPlan | None:
    return plan_repo.get(plan_id)


def generate_plan(payload: TravelPlanCreate) -> TravelPlan:
    user = user_repo.get(payload.user_id)
    if not user:
        raise ValueError("User not found")

    # Recommend places/caretakers around the DESTINATION, not the user's current location
    rec_user = _to_rec_user(user, payload.destination_latitude, payload.destination_longitude)

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

    recommended_places = rec.recommend_places(rec_user, places)
    caretaker_match = rec.match_caretakers(rec_user, caretakers)

    transit_options = search_transit(
        TransitSearchRequest(
            source_latitude=user.Current_latitude or 0.0,
            source_longitude=user.Current_longitude or 0.0,
            destination_name=payload.destination_name,
            destination_latitude=payload.destination_latitude,
            destination_longitude=payload.destination_longitude,
        )
    )

    nearby_communities = community_service.find_communities_near_destination(payload.destination_name)

    # His CaretakerMatchResult has 3 possible statuses; pick the right list for each
    if caretaker_match.status == "MATCH_FOUND":
        caretaker_list = caretaker_match.matches
    elif caretaker_match.status == "GENDER_UNAVAILABLE_FALLBACK":
        caretaker_list = caretaker_match.fallback_recommendations
    else:  # NO_CARETAKER_AVAILABLE
        caretaker_list = []

    itinerary_data = {
        
        "transit_options": [o.model_dump() for o in transit_options],
        "recommended_places": [
            {
                "place_id": rp.place.place_id,
                "name": rp.place.name,
                "category": rp.place.category,
                "distance_km": rp.distance_km,
                "accessibility_score": rp.accessibility_score,
            }
            for rp in recommended_places
        ],
        "caretaker_match": {
            "status": caretaker_match.status,
            **({"message": caretaker_match.message} if caretaker_match.message else {}),
            "recommendations": [
                {
                    "caretaker_id": rc.caretaker.caretaker_id,
                    "full_name": rc.caretaker.full_name,
                    "distance_km": rc.distance_km,
                }
                for rc in caretaker_list
            ],
        },"nearby_communities": [c.model_dump(mode="json") for c in nearby_communities],
    }

    plan = TravelPlan(
        plan_id=plan_repo.generate_id(),
        user_id=payload.user_id,
        destination_name=payload.destination_name,
        start_date=payload.start_date,
        end_date=payload.end_date,
        itinerary_data=itinerary_data,
    )
    return plan_repo.create(plan)