import jwt
from fastapi import APIRouter, Depends, HTTPException, status

from app.api.deps import AuthContext, require_caretaker, require_user
from app.core.security import Role, create_access_token, create_refresh_token, decode_token
from app.models.auth import (
    CaretakerRegisterRequest,
    LoginRequest,
    OtpVerifyRequest,
    OtpVerifyResponse,
    PasswordResetRequest,
    RefreshRequest,
    TokenResponse,
    UserRegisterRequest,
)
from app.models.caretaker import CaretakerPublic
from app.models.user import UserPublic
from app.services import auth_service

router = APIRouter()


@router.post("/otp/verify", response_model=OtpVerifyResponse)
def verify_otp(payload: OtpVerifyRequest):
    """
    Client calls this right after Firebase phone-OTP auth succeeds.
    Tells the client whether to show the Register screen or the Login screen next.
    """
    try:
        phone_number = auth_service.verify_otp_and_get_phone(payload.firebase_id_token)
    except Exception:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired OTP token")

    account = auth_service.find_account_by_phone(payload.role, phone_number)
    return OtpVerifyResponse(phone_number=phone_number, role=payload.role, account_exists=account is not None)


@router.post("/register/user", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
def register_user(payload: UserRegisterRequest):
    try:
        phone_number = auth_service.verify_otp_and_get_phone(payload.firebase_id_token)
    except Exception:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired OTP token")

    try:
        user = auth_service.register_user(phone_number, payload.profile, payload.password)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

    return TokenResponse(
        access_token=create_access_token(user.user_id, Role.USER),
        refresh_token=create_refresh_token(user.user_id, Role.USER),
        role=Role.USER,
        subject_id=user.user_id,
    )


@router.post("/register/caretaker", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
def register_caretaker(payload: CaretakerRegisterRequest):
    try:
        phone_number = auth_service.verify_otp_and_get_phone(payload.firebase_id_token)
    except Exception:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired OTP token")

    try:
        caretaker = auth_service.register_caretaker(phone_number, payload.profile, payload.password)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

    return TokenResponse(
        access_token=create_access_token(caretaker.caretaker_id, Role.CARETAKER),
        refresh_token=create_refresh_token(caretaker.caretaker_id, Role.CARETAKER),
        role=Role.CARETAKER,
        subject_id=caretaker.caretaker_id,
    )


@router.post("/login", response_model=TokenResponse)
def login(payload: LoginRequest):
    """Password login for a returning user/caretaker (after their first OTP-based registration)."""
    try:
        account, access_token, refresh_token = auth_service.login(payload.role, payload.identifier, payload.password)
    except ValueError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")

    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        role=payload.role,
        subject_id=auth_service.subject_id_of(payload.role, account),
    )


@router.post("/password-reset", response_model=TokenResponse)
def reset_password(payload: PasswordResetRequest):
    """
    Forgot-password flow: client completes Firebase phone OTP again, then
    calls this with the resulting token + a new password. No old password
    needed — OTP re-proves phone ownership instead. Logs the account in
    immediately after resetting, so the user doesn't need a separate login step.
    """
    try:
        phone_number = auth_service.verify_otp_and_get_phone(payload.firebase_id_token)
    except Exception:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired OTP token")

    try:
        subject_id = auth_service.reset_password(payload.role, phone_number, payload.new_password)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))

    return TokenResponse(
        access_token=create_access_token(subject_id, payload.role),
        refresh_token=create_refresh_token(subject_id, payload.role),
        role=payload.role,
        subject_id=subject_id,
    )


@router.post("/refresh", response_model=TokenResponse)
def refresh(payload: RefreshRequest):
    try:
        decoded = decode_token(payload.refresh_token)
    except jwt.PyJWTError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired refresh token")

    role = Role(decoded["role"])
    subject_id = decoded["sub"]
    return TokenResponse(
        access_token=create_access_token(subject_id, role),
        refresh_token=create_refresh_token(subject_id, role),
        role=role,
        subject_id=subject_id,
    )


@router.get("/me/user", response_model=UserPublic)
def get_me_user(auth: AuthContext = Depends(require_user)):
    user = auth_service.user_repo.get(auth.subject_id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return UserPublic(**user.model_dump())


@router.get("/me/caretaker", response_model=CaretakerPublic)
def get_me_caretaker(auth: AuthContext = Depends(require_caretaker)):
    caretaker = auth_service.caretaker_repo.get(auth.subject_id)
    if not caretaker:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Caretaker not found")
    return CaretakerPublic(**caretaker.model_dump())
