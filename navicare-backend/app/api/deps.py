"""
Reusable FastAPI dependencies for role-gated routes.
Usage:
    @router.get("/me")
    def me(current=Depends(require_user)): ...
"""
import jwt
from fastapi import Depends, Header, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.core.config import settings
from app.core.security import Role, decode_token

bearer_scheme = HTTPBearer()


class AuthContext:
    def __init__(self, subject_id: str, role: Role):
        self.subject_id = subject_id
        self.role = role


def get_current_auth(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
) -> AuthContext:
    try:
        payload = decode_token(credentials.credentials)
        return AuthContext(subject_id=payload["sub"], role=Role(payload["role"]))
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token expired")
    except (jwt.PyJWTError, KeyError, ValueError):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")


def require_user(auth: AuthContext = Depends(get_current_auth)) -> AuthContext:
    if auth.role != Role.USER:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="User role required")
    return auth


def require_caretaker(auth: AuthContext = Depends(get_current_auth)) -> AuthContext:
    if auth.role != Role.CARETAKER:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Caretaker role required")
    return auth


def require_admin_key(x_admin_key: str = Header(default="")) -> None:
    """
    Placeholder admin gate until a real admin role exists. Not meant to be
    the long-term answer — swap for a proper admin auth flow once you have
    a small team managing place/transit data instead of just you.
    """
    if not settings.ADMIN_API_KEY or x_admin_key != settings.ADMIN_API_KEY:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Admin access required")
