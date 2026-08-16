from typing import Any

from pydantic import BaseModel, Field

from app.models.enums import AgentInputMode


class AgentQueryTransitRequest(BaseModel):
    session_id: str
    input_mode: AgentInputMode
    user_speech_transcription: str | None = None
    source_latitude: float
    source_longitude: float
    destination_name: str


class AgentBookCaretakerRequest(BaseModel):
    session_id: str
    input_mode: AgentInputMode
    user_speech_transcription: str | None = None
    plan_id: str
    caretaker_id: str


class AgentTripPlanRequest(BaseModel):
    session_id: str
    input_mode: AgentInputMode
    user_speech_transcription: str | None = None


class AgentResponse(BaseModel):
    session_id: str
    detected_intent: str
    agent_response_text: str
    data: Any = None