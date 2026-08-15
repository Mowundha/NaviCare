from pydantic import BaseModel

from app.core.security import Role
from app.models.caretaker import CaretakerCreate
from app.models.user import UserCreate


class OtpVerifyRequest(BaseModel):
    firebase_id_token: str
    role: Role


class OtpVerifyResponse(BaseModel):
    phone_number: str
    role: Role
    account_exists: bool  # tells the client app whether to show Register or Login


class UserRegisterRequest(BaseModel):
    firebase_id_token: str  # proves phone OTP was completed
    profile: UserCreate
    password: str


class CaretakerRegisterRequest(BaseModel):
    firebase_id_token: str
    profile: CaretakerCreate
    password: str


class LoginRequest(BaseModel):
    role: Role
    identifier: str  # phone_number or email
    password: str


class PasswordResetRequest(BaseModel):
    firebase_id_token: str  # proves phone OTP was completed for this reset
    role: Role
    new_password: str


class RefreshRequest(BaseModel):
    refresh_token: str


class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    role: Role
    subject_id: str
