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
    destination_latitude: float
    destination_longitude: float

    travel_date: date | None = None
    departure_time: datetime | None = None

    preference: str = "LESS_WALKING"



class TransitLocation(BaseModel):
    name: str | None = None
    latitude: float
    longitude: float


class TransitLeg(BaseModel):
    mode: str
    name: str | None = None

    departure_location: TransitLocation
    arrival_location: TransitLocation

    departure_time: datetime | None = None
    arrival_time: datetime | None = None
    duration_seconds: int | None = None

    distance_meters: int | None = None

    departure_stop: str | None = None
    arrival_stop: str | None = None

    wheelchair_accessible: bool | None = None
    accessibility_status: str = "UNKNOWN"

    instructions: str | None = None


class TransitJourney(BaseModel):
    journey_id: str

    origin: TransitLocation
    destination: TransitLocation

    departure_time: datetime | None = None
    arrival_time: datetime | None = None

    duration_seconds: int | None = None
    distance_meters: int | None = None

    number_of_transfers: int = 0

    legs: list[TransitLeg] = Field(default_factory=list)

    accessibility_summary: list[str] = Field(default_factory=list)

    navigation_url: str | None = None

    provider: str = "google_routes"