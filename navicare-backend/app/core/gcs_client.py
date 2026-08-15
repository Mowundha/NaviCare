"""
Google Cloud Storage helper for caretaker certificate uploads.
Files are stored privately; callers get a time-limited signed URL to view them.
"""
import uuid
from datetime import timedelta

from google.cloud import storage

from app.core.config import settings

_client: storage.Client | None = None


def get_storage_client() -> storage.Client:
    global _client
    if _client is None:
        _client = storage.Client(project=settings.GCP_PROJECT_ID)
    return _client


def upload_certificate(file_bytes: bytes, original_filename: str, content_type: str, caretaker_id: str) -> str:
    """Uploads the file and returns the GCS blob name (not a public URL)."""
    client = get_storage_client()
    bucket = client.bucket(settings.GCS_BUCKET_CERTIFICATES)

    ext = original_filename.rsplit(".", 1)[-1] if "." in original_filename else "bin"
    blob_name = f"certificates/{caretaker_id}/{uuid.uuid4()}.{ext}"

    blob = bucket.blob(blob_name)
    blob.upload_from_string(file_bytes, content_type=content_type)
    return blob_name


def generate_signed_url(blob_name: str, expiration_minutes: int = 60) -> str:
    """Time-limited read URL — certificates stay private, never made public."""
    client = get_storage_client()
    bucket = client.bucket(settings.GCS_BUCKET_CERTIFICATES)
    blob = bucket.blob(blob_name)
    return blob.generate_signed_url(expiration=timedelta(minutes=expiration_minutes))
