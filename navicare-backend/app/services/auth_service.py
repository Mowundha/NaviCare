"""
Business logic for dual-role (User / Caretaker) authentication.
Keeps Firestore + Firebase + password logic out of the route handlers.
"""
from app.core.firebase_client import verify_firebase_id_token
from app.core.firestore_client import FirestoreRepository
from app.core.security import Role, create_access_token, create_refresh_token, hash_password, verify_password
from app.models.caretaker import Caretaker, CaretakerAvailabilityUpdate, CaretakerCreate
from app.models.user import User, UserCreate

user_repo = FirestoreRepository("Users", User, "user_id")
caretaker_repo = FirestoreRepository("Caretakers", Caretaker, "caretaker_id")


def repo_for_role(role: Role) -> FirestoreRepository:
    return user_repo if role == Role.USER else caretaker_repo


def subject_id_of(role: Role, account) -> str:
    return account.user_id if role == Role.USER else account.caretaker_id


def verify_otp_and_get_phone(firebase_id_token: str) -> str:
    """Raises on invalid/expired token. Returns the verified phone number."""
    decoded = verify_firebase_id_token(firebase_id_token)
    phone_number = decoded.get("phone_number")
    if not phone_number:
        raise ValueError("Firebase token did not contain a verified phone number")
    return phone_number


def find_account_by_phone(role: Role, phone_number: str):
    return repo_for_role(role).find_one_by("phone_number", phone_number)


def register_user(phone_number: str, payload: UserCreate, password: str) -> User:
    if user_repo.find_one_by("phone_number", phone_number):
        raise ValueError("An account with this phone number already exists")
    data = payload.model_dump()
    data["phone_number"] = phone_number  # always trust the OTP-verified number, not client input
    user = User(user_id=user_repo.generate_id(), hashed_password=hash_password(password), **data)
    return user_repo.create(user)


def register_caretaker(phone_number: str, payload: CaretakerCreate, password: str) -> Caretaker:
    if caretaker_repo.find_one_by("phone_number", phone_number):
        raise ValueError("An account with this phone number already exists")

    data = payload.model_dump()
    data["phone_number"] = phone_number

    # NaviCare controls caretaker pricing.
    data["hourly_rate"] = None
    data["daily_rate"] = settings.CARETAKER_DAILY_RATE

    caretaker = Caretaker(
        caretaker_id=caretaker_repo.generate_id(),
        hashed_password=hash_password(password),
        **data
    )

    return caretaker_repo.create(caretaker)


def login(role: Role, identifier: str, password: str):
    """identifier can be a phone_number or an email. Returns (account, access_token, refresh_token)."""
    repo = repo_for_role(role)
    account = repo.find_one_by("phone_number", identifier)
    if not account:
        email_field = "email" if role == Role.USER else "Email"
        account = repo.find_one_by(email_field, identifier)

    if not account or not account.hashed_password or not verify_password(password, account.hashed_password):
        raise ValueError("Invalid credentials")

    subject_id = subject_id_of(role, account)
    return account, create_access_token(subject_id, role), create_refresh_token(subject_id, role)


def update_caretaker_availability(caretaker_id: str, payload: CaretakerAvailabilityUpdate) -> Caretaker:
    """
    Lets a caretaker toggle themselves available/unavailable, and optionally
    refresh their location at the same time (mobile app can send both in one
    call whenever the caretaker opens the app or moves).
    """
    caretaker = caretaker_repo.get(caretaker_id)
    if not caretaker:
        raise ValueError("Caretaker not found")

    fields: dict = {"is_available": payload.is_available}
    if payload.latitude is not None:
        fields["latitude"] = payload.latitude
    if payload.longitude is not None:
        fields["longitude"] = payload.longitude

    caretaker_repo.update(caretaker_id, fields)
    return caretaker_repo.get(caretaker_id)


def reset_password(role: Role, phone_number: str, new_password: str) -> str:
    """
    OTP-verified password reset. phone_number must already come from a
    verified Firebase token — this function trusts it as-is, same as registration.
    Returns the subject_id so the caller can issue fresh tokens (auto-login after reset).
    """
    repo = repo_for_role(role)
    account = repo.find_one_by("phone_number", phone_number)
    if not account:
        raise ValueError("No account found for this phone number")

    subject_id = subject_id_of(role, account)
    repo.update(subject_id, {"hashed_password": hash_password(new_password)})
    return subject_id
