from datetime import datetime, timezone

from pydantic import BaseModel, EmailStr, Field


class User(BaseModel):
    user_id: str
    full_name: str
    email: EmailStr
    phone_number: str
    age: int | None = None
    gender: str | None = None
    disability_types: list[str] = Field(default_factory=list)
    mobility_equipment: str | None = None
    voice_assistant_enabled: bool = False
    emergency_contact_name: str | None = None
    emergency_contact_phone: str | None = None
    Current_latitude: float | None = None
    Current_longitude: float | None = None
    hashed_password: str | None = None  # never returned in API responses
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class UserCreate(BaseModel):
    full_name: str
    email: EmailStr
    phone_number: str
    age: int | None = None
    gender: str | None = None
    disability_types: list[str] = Field(default_factory=list)
    mobility_equipment: str | None = None
    emergency_contact_name: str | None = None
    emergency_contact_phone: str | None = None


class UserPublic(BaseModel):
    """Response schema — excludes hashed_password."""
    user_id: str
    full_name: str
    email: EmailStr
    phone_number: str
    age: int | None
    gender: str | None
    disability_types: list[str]
    mobility_equipment: str | None
    voice_assistant_enabled: bool
    Current_latitude: float | None
    Current_longitude: float | None
    created_at: datetime


class UserLocationUpdate(BaseModel):
    Current_latitude: float
    Current_longitude: float
