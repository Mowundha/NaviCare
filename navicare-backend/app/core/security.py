"""
JWT issuance/verification and password hashing.
Role is embedded in the token ("user" | "caretaker") so every protected
route can enforce which role is allowed to call it.
"""
from __future__ import annotations

from datetime import datetime, timedelta, timezone
from enum import Enum

import bcrypt
import jwt

from app.core.config import settings


class Role(str, Enum):
    USER = "user"
    CARETAKER = "caretaker"


def hash_password(plain_password: str) -> str:
    hashed = bcrypt.hashpw(plain_password.encode("utf-8"), bcrypt.gensalt())
    return hashed.decode("utf-8")


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return bcrypt.checkpw(plain_password.encode("utf-8"), hashed_password.encode("utf-8"))


def create_token(subject_id: str, role: Role, expires_minutes: int) -> str:
    now = datetime.now(timezone.utc)
    payload = {
        "sub": subject_id,
        "role": role.value,
        "iat": now,
        "exp": now + timedelta(minutes=expires_minutes),
    }
    return jwt.encode(payload, settings.JWT_SECRET_KEY, algorithm=settings.JWT_ALGORITHM)


def create_access_token(subject_id: str, role: Role) -> str:
    return create_token(subject_id, role, settings.ACCESS_TOKEN_EXPIRE_MINUTES)


def create_refresh_token(subject_id: str, role: Role) -> str:
    return create_token(subject_id, role, settings.REFRESH_TOKEN_EXPIRE_MINUTES)


def decode_token(token: str) -> dict:
    """Raises jwt.PyJWTError (ExpiredSignatureError, InvalidTokenError, ...) on failure."""
    return jwt.decode(token, settings.JWT_SECRET_KEY, algorithms=[settings.JWT_ALGORITHM])
