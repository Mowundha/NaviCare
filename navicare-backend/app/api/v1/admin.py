from fastapi import APIRouter, Depends, HTTPException, status

from app.api.deps import require_admin_key
from app.models.directory import AccessiblePlace, AccessiblePlaceCreate, TransitNode, TransitNodeCreate
from app.models.enums import PlaceVerificationStatus
from app.services import directory_service

router = APIRouter(dependencies=[Depends(require_admin_key)])


@router.post("/places", response_model=AccessiblePlace, status_code=status.HTTP_201_CREATED)
def create_place(payload: AccessiblePlaceCreate):
    return directory_service.create_place(payload)


@router.get("/places", response_model=list[AccessiblePlace])
def list_places():
    return directory_service.list_places()


@router.patch("/places/{place_id}/verification", response_model=AccessiblePlace)
def update_place_verification(place_id: str, verification_status: PlaceVerificationStatus):
    try:
        return directory_service.update_place_verification(place_id, verification_status)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))


@router.post("/transit", response_model=TransitNode, status_code=status.HTTP_201_CREATED)
def create_transit_node(payload: TransitNodeCreate):
    return directory_service.create_transit_node(payload)


@router.get("/transit", response_model=list[TransitNode])
def list_transit_nodes():
    return directory_service.list_transit_nodes()
