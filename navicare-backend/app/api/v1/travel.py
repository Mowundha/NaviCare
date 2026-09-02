from fastapi import APIRouter, Depends, HTTPException, status

from app.api.deps import AuthContext, require_user
from app.models.travel_plan import (
    TransitJourney,
    TransitSearchRequest,
    TravelPlan,
    TravelPlanCreate,
)
from app.services import last_mile_service, travel_service

router = APIRouter()


@router.post(
    "/search-transit",
    response_model=list[TransitJourney],
)
def search_transit(payload: TransitSearchRequest):
    """
    Search real public-transit journeys.

    No authentication required so users can explore possible
    routes before registering or logging in.
    """
    try:
        return travel_service.search_transit(payload)

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )

    except RuntimeError as e:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail=str(e),
        )


@router.post(
    "/generate-plan",
    response_model=TravelPlan,
    status_code=status.HTTP_201_CREATED,
)
def generate_plan(
    payload: TravelPlanCreate,
    auth: AuthContext = Depends(require_user),
):
    """
    Generate a complete NaviCare travel plan for the
    authenticated user.
    """

    # Never allow a user to create a plan for another account.
    if payload.user_id != auth.subject_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Cannot create a plan for another user",
        )

    try:
        return travel_service.generate_plan(payload)

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e),
        )

    except RuntimeError as e:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail=str(e),
        )


@router.get(
    "/plan/{plan_id}",
    response_model=TravelPlan,
)
def get_plan(
    plan_id: str,
    auth: AuthContext = Depends(require_user),
):
    """
    Retrieve a travel plan belonging to the authenticated user.
    """

    plan = travel_service.get_plan(plan_id)

    if not plan:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Travel plan not found",
        )

    if plan.user_id != auth.subject_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not your travel plan",
        )

    return plan


@router.get("/plan/{plan_id}/last-mile")
def get_last_mile_guidance(
    plan_id: str,
    auth: AuthContext = Depends(require_user),
):
    """
    Build current last-mile guidance based on the travel plan's
    current caretaker dispatch status.
    """

    plan = travel_service.get_plan(plan_id)

    if not plan:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Travel plan not found",
        )

    if plan.user_id != auth.subject_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not your travel plan",
        )

    try:
        return last_mile_service.build_last_mile_for_plan(plan_id)

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e),
        )