from datetime import date, datetime, timezone

from pydantic import BaseModel, Field

from app.models.enums import CommunityStatus


class Community(BaseModel):
    """
    Stored document. Deliberately has NO status field — status depends on
    today's date vs trip dates, so storing it would go stale. Always compute
    fresh via community_service.compute_status() instead.
    """
    community_id: str
    creator_user_id: str
    title: str
    destination_name: str
    destination_latitude: float | None = None
    destination_longitude: float | None = None
    trip_start_date: date
    trip_end_date: date
    whatsapp_invite_link: str
    description: str | None = None
    member_user_ids: list[str] = Field(default_factory=list)  # creator is always the first member
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class CommunityCreate(BaseModel):
    title: str
    destination_name: str
    destination_latitude: float | None = None
    destination_longitude: float | None = None
    trip_start_date: date
    trip_end_date: date
    whatsapp_invite_link: str
    description: str | None = None


class CommunityResponse(BaseModel):
    """Includes the computed status + member_count, for API responses."""
    community_id: str
    creator_user_id: str
    title: str
    destination_name: str
    destination_latitude: float | None
    destination_longitude: float | None
    trip_start_date: date
    trip_end_date: date
    whatsapp_invite_link: str
    description: str | None
    member_count: int
    status: CommunityStatus
    created_at: datetime