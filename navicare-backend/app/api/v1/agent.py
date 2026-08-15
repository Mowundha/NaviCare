from fastapi import APIRouter, Depends

from app.api.deps import AuthContext, require_user
from app.models.agent import AgentBookCaretakerRequest, AgentQueryTransitRequest, AgentResponse, AgentTripPlanRequest
from app.models.enums import AgentInputMode
from app.services import agent_service

router = APIRouter()


@router.post("/query-transit", response_model=AgentResponse)
def query_transit(payload: AgentQueryTransitRequest, auth: AuthContext = Depends(require_user)):
    return agent_service.query_transit(auth.subject_id, payload)


@router.post("/book-caretaker", response_model=AgentResponse)
def book_caretaker(payload: AgentBookCaretakerRequest, auth: AuthContext = Depends(require_user)):
    return agent_service.book_caretaker(auth.subject_id, payload)


@router.get("/trip-plan/{plan_id}", response_model=AgentResponse)
def trip_plan(
    plan_id: str,
    session_id: str,
    input_mode: AgentInputMode = AgentInputMode.TEXT,
    auth: AuthContext = Depends(require_user),
):
    payload = AgentTripPlanRequest(session_id=session_id, input_mode=input_mode)
    return agent_service.get_trip_plan(auth.subject_id, plan_id, payload)