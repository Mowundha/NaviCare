"""
Caretaker certificate verification pipeline:
upload to GCS -> analyze with Gemini Vision -> decide Verified/Rejected -> update Firestore.
"""
from app.core.gcs_client import generate_signed_url, upload_certificate
from app.core.gemini_client import analyze_certificate
from app.models.enums import VerificationStatus
from app.services.auth_service import caretaker_repo

ACCEPTED_CONTENT_TYPES = {"application/pdf", "image/jpeg", "image/png"}
MAX_FILE_SIZE_MB = 10


def process_certificate_upload(caretaker_id: str, file_bytes: bytes, filename: str, content_type: str) -> dict:
    caretaker = caretaker_repo.get(caretaker_id)
    if not caretaker:
        raise ValueError("Caretaker not found")

    blob_name = upload_certificate(file_bytes, filename, content_type, caretaker_id)
    certificate_url = generate_signed_url(blob_name)

    analysis = analyze_certificate(file_bytes, content_type, caretaker.full_name)

    name_ok = bool(analysis.get("name_matches"))
    not_expired = not analysis.get("is_expired", True)
    keywords_ok = bool(analysis.get("has_valid_accreditation_keywords"))

    new_status = VerificationStatus.VERIFIED if (name_ok and not_expired and keywords_ok) else VerificationStatus.REJECTED

    update_fields = {
        "certificate_scan_url": blob_name,
        "verification_status": new_status.value,
    }
    found_keywords = analysis.get("accreditation_keywords_found")
    if found_keywords:
        update_fields["certifications"] = found_keywords

    caretaker_repo.update(caretaker_id, update_fields)

    return {
        "verification_status": new_status,
        "analysis": analysis,
        "certificate_url": certificate_url,
    }
