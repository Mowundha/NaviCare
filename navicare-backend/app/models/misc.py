from datetime import datetime, timezone
from typing import Any

from pydantic import BaseModel, Field

from app.models.enums import AgentInputMode, ReviewTargetType


class Review(BaseModel):
    review_id: str
    user_id: str
    target_id: str
    target_type: ReviewTargetType
    rating: int = Field(ge=1, le=5)
    written_feedback: str | None = None
    voice_note_url: str | None = None
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class ReviewCreate(BaseModel):
    user_id: str
    target_id: str
    target_type: ReviewTargetType
    rating: int = Field(ge=1, le=5)
    written_feedback: str | None = None
    voice_note_url: str | None = None


class AgentHistory(BaseModel):
    interaction_id: str  # ADDED: unique per turn — session_id groups many turns, can't be the doc ID itself
    session_id: str
    user_id: str
    input_mode: AgentInputMode
    user_speech_transcription: str | None = None
    agent_response_text: str | None = None
    agent_audio_url: str | None = None
    detected_intent: str | None = None
    context_state: dict[str, Any] = Field(default_factory=dict)
    timestamp: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))