from datetime import date, datetime, timezone
from typing import Any

from pydantic import BaseModel, Field

from app.models.enums import DispatchStatus, TravelPlanStatus


class TravelPlan(BaseModel):
    plan_id: str
    user_id: str
    destination_name: str
    start_date: date
    end_date: date
    itinerary_data: dict[str, Any] = Field(default_factory=dict)
    assigned_caretaker_id: str | None = None
    dispatch_status: DispatchStatus | None = None  # ADDED: not in original docx schema — needed to persist the request lifecycle
    status: TravelPlanStatus = TravelPlanStatus.DRAFT
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class TravelPlanCreate(BaseModel):
    user_id: str
    destination_name: str
    destination_latitude: float
    destination_longitude: float
    start_date: date
    end_date: date
    itinerary_data: dict[str, Any] = Field(default_factory=dict)


class TravelPlanStatusUpdate(BaseModel):
    status: TravelPlanStatus


class TransitSearchRequest(BaseModel):
    source_latitude: float
    source_longitude: float
    destination_name: str
    destination_latitude: float | None = None
    destination_longitude: float | None = None
    travel_date: date | None = None


class TransitOption(BaseModel):
    transit_id: str | None = None
    mode: str  # 'train' | 'bus'
    name: str
    boarding_time: str
    duration: str
    arrival_time: str
    wheelchair_lift_working: bool | None = None
    tactile_flooring_present: bool | None = None
    specialized_coach_available: bool | None = None