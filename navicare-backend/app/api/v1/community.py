from fastapi import APIRouter, Depends, HTTPException, status

from app.api.deps import AuthContext, require_user
from app.models.community import CommunityCreate, CommunityResponse
from app.services import community_service

router = APIRouter()


@router.post("/create", response_model=CommunityResponse, status_code=status.HTTP_201_CREATED)
def create_community(payload: CommunityCreate, auth: AuthContext = Depends(require_user)):
    try:
        return community_service.create_community(auth.subject_id, payload)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))


@router.post("/{community_id}/join", response_model=CommunityResponse)
def join_community(community_id: str, auth: AuthContext = Depends(require_user)):
    try:
        return community_service.join_community(community_id, auth.subject_id)
    except ValueError as e:
        detail = str(e)
        code = status.HTTP_404_NOT_FOUND if "not found" in detail.lower() else status.HTTP_400_BAD_REQUEST
        raise HTTPException(status_code=code, detail=detail)


@router.get("/", response_model=list[CommunityResponse])
def list_communities(destination_name: str | None = None, auth: AuthContext = Depends(require_user)):
    """Only ACTIVE communities are ever listed here — closed/expired ones are just not shown."""
    return community_service.list_active_communities(destination_name=destination_name)


@router.get("/{community_id}", response_model=CommunityResponse)
def get_community(community_id: str, auth: AuthContext = Depends(require_user)):
    community = community_service.get_community(community_id)
    if not community:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Community not found")
    return community