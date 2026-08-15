from fastapi import APIRouter, Depends, HTTPException, status

from app.api.deps import AuthContext, require_caretaker
from app.models.caretaker import CaretakerAvailabilityUpdate, CaretakerPublic
from app.services import auth_service

router = APIRouter()


@router.patch("/availability", response_model=CaretakerPublic)
def update_availability(payload: CaretakerAvailabilityUpdate, auth: AuthContext = Depends(require_caretaker)):
    """
    Caretaker toggles is_available (and optionally refreshes lat/lng in the
    same call). This is what recommendation_engine.match_caretakers and
    dispatch_service.request_caretaker rely on to know who can be booked.
    """
    try:
        caretaker = auth_service.update_caretaker_availability(auth.subject_id, payload)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    return CaretakerPublic(**caretaker.model_dump())
