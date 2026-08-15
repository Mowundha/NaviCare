"""
Centralized configuration for NaviCare backend.
All secrets/config come from environment variables (set via Cloud Run
env vars or Secret Manager in production, .env locally).
"""
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    # --- General ---
    PROJECT_NAME: str = "NaviCare Backend"
    ENVIRONMENT: str = "development"  # development | staging | production
    API_V1_PREFIX: str = "/api/v1"

    # --- GCP ---
    GCP_PROJECT_ID: str
    FIRESTORE_DATABASE: str = "(default)"
    GCS_BUCKET_CERTIFICATES: str  # bucket for caretaker certificate uploads
    GCS_BUCKET_MISC: str = ""     # optional bucket for other uploads

    # --- Document AI / Gemini Vision ---
    DOCUMENT_AI_PROCESSOR_ID: str = ""
    DOCUMENT_AI_LOCATION: str = "us"
    GEMINI_API_KEY: str = ""
    GEMINI_MODEL: str = "gemini-flash-latest"

    # --- Auth / JWT ---
    JWT_SECRET_KEY: str
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24        # 1 day
    REFRESH_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 30  # 30 days

    # --- Firebase (phone OTP) ---
    FIREBASE_CREDENTIALS_PATH: str = ""  # path to service account json, or unset if using ADC

    # --- Payments ---
    RAZORPAY_KEY_ID: str = ""
    RAZORPAY_KEY_SECRET: str = ""
    RAZORPAY_WEBHOOK_SECRET: str = ""
    STRIPE_SECRET_KEY: str = ""
    STRIPE_WEBHOOK_SECRET: str = ""
    PLATFORM_FEE_PERCENT: float = 15.0  # % commission taken from gross_amount
    PAYOUT_SIMULATION_MODE: bool = True  # True until RazorpayX is enabled — see payment_service.py
    # --- CORS ---
    ALLOWED_ORIGINS: list[str] = ["*"]


settings = Settings()
