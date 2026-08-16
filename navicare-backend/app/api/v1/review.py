from fastapi import APIRouter, Depends, HTTPException, status

from app.api.deps import AuthContext, get_current_auth
from app.models.enums import ReviewTargetType
from app.models.misc import Review, ReviewCreate
from app.services import review_service

router = APIRouter()


@router.post("/", response_model=Review, status_code=status.HTTP_201_CREATED)
def create_review(payload: ReviewCreate, auth: AuthContext = Depends(get_current_auth)):
    try:
        return review_service.create_review(auth.subject_id, payload)
    except PermissionError as e:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail=str(e))


@router.get("/{target_type}/{target_id}", response_model=list[Review])
def list_reviews(target_type: ReviewTargetType, target_id: str):
    """Public — no login needed to read reviews before booking/visiting somewhere."""
    return review_service.list_reviews_for_target(target_id, target_type)
