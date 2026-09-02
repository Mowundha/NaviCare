"""
Firebase Admin integration — used ONLY to verify the ID token issued by
Firebase after the client app completes phone OTP verification.
The backend never receives or checks the OTP code itself.
"""
import firebase_admin
from firebase_admin import auth as firebase_auth, credentials

from app.core.config import settings

_app: firebase_admin.App | None = None


def get_firebase_app() -> firebase_admin.App:
    global _app
    if _app is None:
        if settings.FIREBASE_CREDENTIALS_PATH:
            cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
            _app = firebase_admin.initialize_app(cred)
        else:
            # Falls back to Application Default Credentials (fine on Cloud Run)
            _app = firebase_admin.initialize_app()
    return _app


def verify_firebase_id_token(id_token: str) -> dict:
    """
    Verifies a Firebase ID token (issued client-side after phone OTP auth).
    Returns the decoded token, which includes 'phone_number' and 'uid'.
    Raises firebase_admin.auth.InvalidIdTokenError / ExpiredIdTokenError on failure.
    """
    get_firebase_app()
    return firebase_auth.verify_id_token(id_token)
