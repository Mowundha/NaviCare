from datetime import datetime, timezone

from pydantic import BaseModel, EmailStr, Field

from app.models.enums import VerificationStatus


class BankAccountDetails(BaseModel):
    account_holder_name: str
    account_number: str
    ifsc_code: str
    bank_name: str | None = None


class Caretaker(BaseModel):
    caretaker_id: str
    agency_name: str | None = None
    full_name: str
    phone_number: str
    gender: str
    certifications: list[str] = Field(default_factory=list)
    certificate_scan_url: str | None = None
    verification_status: VerificationStatus = VerificationStatus.PENDING
    latitude: float | None = None
    longitude: float | None = None
    Email: EmailStr
    is_available: bool = False
    bank_account_details: BankAccountDetails | None = None
    supported_disabilities: list[str] = Field(default_factory=list)
    hashed_password: str | None = None
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class CaretakerCreate(BaseModel):
    agency_name: str | None = None
    full_name: str
    phone_number: str
    gender: str
    Email: EmailStr
    hourly_rate: float | None = None
    daily_rate: float | None = None
    supported_disabilities: list[str] = Field(default_factory=list)


class CaretakerPublic(BaseModel):
    caretaker_id: str
    agency_name: str | None
    full_name: str
    gender: str
    hourly_rate: float | None
    daily_rate: float | None
    certifications: list[str]
    verification_status: VerificationStatus
    latitude: float | None
    longitude: float | None
    is_available: bool
    supported_disabilities: list[str]


class CaretakerAvailabilityUpdate(BaseModel):
    is_available: bool
    latitude: float | None = None
    longitude: float | None = None
