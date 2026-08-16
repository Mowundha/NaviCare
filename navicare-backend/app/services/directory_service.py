"""
Admin-only writes for Accessible_Places and Transit_Nodes. These collections
are read-mostly for normal users (travel_service and last_mile_service only
read them) — this module is the only place that creates/edits them.
"""
from app.models.directory import AccessiblePlace, AccessiblePlaceCreate, TransitNode, TransitNodeCreate
from app.models.enums import PlaceVerificationStatus
from app.services.travel_service import place_repo, transit_repo


def create_place(payload: AccessiblePlaceCreate) -> AccessiblePlace:
    place = AccessiblePlace(place_id=place_repo.generate_id(), **payload.model_dump())
    return place_repo.create(place)


def list_places(limit: int = 200) -> list[AccessiblePlace]:
    return place_repo.list_all(limit=limit)


def update_place_verification(place_id: str, status: PlaceVerificationStatus) -> AccessiblePlace:
    place = place_repo.get(place_id)
    if not place:
        raise ValueError("Place not found")
    place_repo.update(place_id, {"verification_status": status.value})
    return place_repo.get(place_id)


def create_transit_node(payload: TransitNodeCreate) -> TransitNode:
    node = TransitNode(transit_id=transit_repo.generate_id(), **payload.model_dump())
    return transit_repo.create(node)


def list_transit_nodes(limit: int = 200) -> list[TransitNode]:
    return transit_repo.list_all(limit=limit)
