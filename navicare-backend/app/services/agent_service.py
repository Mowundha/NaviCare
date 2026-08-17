"""
Endpoints backing the AI voice/text agent. Each function wraps existing
travel_service/dispatch_service logic, builds a natural-language response
string for the agent to speak/display, and logs the turn to AI_Agent_History.
"""
from app.core.firestore_client import FirestoreRepository
from app.models.agent import AgentBookCaretakerRequest, AgentQueryTransitRequest, AgentResponse, AgentTripPlanRequest
from app.models.misc import AgentHistory
from app.models.travel_plan import TransitSearchRequest
from app.services import dispatch_service, travel_service
from app.services.auth_service import caretaker_repo

agent_history_repo = FirestoreRepository("AI_Agent_History", AgentHistory, "interaction_id")


def _log(session_id, user_id, input_mode, transcription, response_text, detected_intent, context_state=None):
    entry = AgentHistory(
        interaction_id=agent_history_repo.generate_id(),
        session_id=session_id,
        user_id=user_id,
        input_mode=input_mode,
        user_speech_transcription=transcription,
        agent_response_text=response_text,
        detected_intent=detected_intent,
        context_state=context_state or {},
    )
    agent_history_repo.create(entry)


def query_transit(user_id: str, payload: AgentQueryTransitRequest) -> AgentResponse:
    options = travel_service.search_transit(
        TransitSearchRequest(
            source_latitude=payload.source_latitude,
            source_longitude=payload.source_longitude,
            destination_name=payload.destination_name,
        )
    )

    train_modes = {"TRAIN", "SUBWAY", "RAIL", "LIGHT_RAIL"}

    def _journey_modes(journey):
        return {leg.mode.upper() for leg in journey.legs if leg.mode}

    train_count = sum(1 for o in options if _journey_modes(o) & train_modes)
    bus_count = sum(1 for o in options if "BUS" in _journey_modes(o))

    if options:
        earliest = options[0]
        journey_label = " + ".join(
            dict.fromkeys(leg.mode for leg in earliest.legs if leg.mode and leg.mode != "WALK")
        ) or "a route"
        if earliest.departure_time:
            response_text = (
                f"I found {train_count} train and {bus_count} bus option(s) to {payload.destination_name}. "
                f"The earliest is {journey_label}, departing at {earliest.departure_time.strftime('%I:%M %p')}."
            )
        else:
            response_text = (
                f"I found {train_count} train and {bus_count} bus option(s) to {payload.destination_name}. "
                f"The earliest is {journey_label}."
            )
    else:
        response_text = f"I couldn't find any transit options to {payload.destination_name} right now."

    _log(
        payload.session_id, user_id, payload.input_mode, payload.user_speech_transcription,
        response_text, "query_transit", {"destination_name": payload.destination_name},
    )

    return AgentResponse(
        session_id=payload.session_id,
        detected_intent="query_transit",
        agent_response_text=response_text,
        data=[o.model_dump() for o in options],
    )


def book_caretaker(user_id: str, payload: AgentBookCaretakerRequest) -> AgentResponse:
    caretaker = caretaker_repo.get(payload.caretaker_id)
    caretaker_name = caretaker.full_name if caretaker else "the caretaker"

    try:
        plan = dispatch_service.request_caretaker(payload.plan_id, payload.caretaker_id, user_id)
        response_text = f"I've requested {caretaker_name} for your trip. They'll be notified and should respond shortly."
        detected_intent = "book_caretaker_success"
        data = {"plan_id": plan.plan_id, "dispatch_status": plan.dispatch_status}
    except (ValueError, PermissionError) as e:
        response_text = f"I couldn't request {caretaker_name}: {e}"
        detected_intent = "book_caretaker_failed"
        data = None

    _log(
        payload.session_id, user_id, payload.input_mode, payload.user_speech_transcription,
        response_text, detected_intent, {"plan_id": payload.plan_id, "caretaker_id": payload.caretaker_id},
    )

    return AgentResponse(
        session_id=payload.session_id, detected_intent=detected_intent, agent_response_text=response_text, data=data
    )


def get_trip_plan(user_id: str, plan_id: str, payload: AgentTripPlanRequest) -> AgentResponse:
    plan = travel_service.get_plan(plan_id)

    if not plan:
        response_text = "I couldn't find that trip plan."
        detected_intent = "trip_plan_not_found"
        data = None
    elif plan.user_id != user_id:
        response_text = "That trip plan doesn't belong to you."
        detected_intent = "trip_plan_forbidden"
        data = None
    else:
        place_count = len(plan.itinerary_data.get("recommended_places", []))
        status_label = getattr(plan.status, "value", plan.status)
        response_text = (
            f"Your trip to {plan.destination_name} from {plan.start_date} to {plan.end_date} is currently "
            f"{status_label}. I found {place_count} accessible place(s) nearby."
        )
        detected_intent = "trip_plan_found"
        data = plan.model_dump()

    _log(payload.session_id, user_id, payload.input_mode, payload.user_speech_transcription, response_text, detected_intent, {"plan_id": plan_id})

    return AgentResponse(
        session_id=payload.session_id, detected_intent=detected_intent, agent_response_text=response_text, data=data
    )