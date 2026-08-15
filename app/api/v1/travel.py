from fastapi import APIRouter, Depends, HTTPException, status

from app.api.deps import AuthContext, require_user
from app.models.travel_plan import TransitOption, TransitSearchRequest, TravelPlan, TravelPlanCreate
from app.services import last_mile_service,travel_service

router = APIRouter()


@router.post("/search-transit", response_model=list[TransitOption])
def search_transit(payload: TransitSearchRequest):
    """No auth required — lets the app show transit options before login/signup."""
    return travel_service.search_transit(payload)


@router.post("/generate-plan", response_model=TravelPlan, status_code=status.HTTP_201_CREATED)
def generate_plan(payload: TravelPlanCreate, auth: AuthContext = Depends(require_user)):
    if payload.user_id != auth.subject_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Cannot create a plan for another user")

    try:
        return travel_service.generate_plan(payload)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))


@router.get("/plan/{plan_id}", response_model=TravelPlan)
def get_plan(plan_id: str, auth: AuthContext = Depends(require_user)):
    plan = travel_service.get_plan(plan_id)
    if not plan:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Travel plan not found")
    if plan.user_id != auth.subject_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not your travel plan")
    return plan

@router.get("/plan/{plan_id}/last-mile")
def get_last_mile_guidance(plan_id: str, auth: AuthContext = Depends(require_user)):
    """
    Computed fresh every call — reflects the CURRENT dispatch_status (no
    caretaker -> ACCEPTED -> ARRIVED...), not whatever it was when the plan
    was first generated.
    """
    plan = travel_service.get_plan(plan_id)
    if not plan:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Travel plan not found")
    if plan.user_id != auth.subject_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not your travel plan")

    try:
        return last_mile_service.build_last_mile_for_plan(plan_id)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
