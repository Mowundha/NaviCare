from fastapi import APIRouter, Depends, File, HTTPException, UploadFile, status

from app.api.deps import AuthContext, require_caretaker
from app.models.verification import CertificateAnalysis, CertificateVerificationResponse
from app.services import verification_service

router = APIRouter()


@router.post("/caretaker/certificate", response_model=CertificateVerificationResponse)
async def upload_certificate(
    file: UploadFile = File(...),
    auth: AuthContext = Depends(require_caretaker),
):
    """
    Caretaker uploads a qualification certificate (PDF/JPEG/PNG).
    Runs automatically through Gemini Vision and updates
    Caretakers.verification_status to 'Verified' or 'Rejected'.
    """
    if file.content_type not in verification_service.ACCEPTED_CONTENT_TYPES:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Only PDF, JPEG, or PNG files are accepted",
        )

    file_bytes = await file.read()
    max_bytes = verification_service.MAX_FILE_SIZE_MB * 1024 * 1024
    if len(file_bytes) > max_bytes:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"File exceeds {verification_service.MAX_FILE_SIZE_MB}MB limit",
        )

    try:
        result = verification_service.process_certificate_upload(
            auth.subject_id, file_bytes, file.filename or "certificate", file.content_type
        )
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail=f"Verification pipeline failed: {e}",
        )

    return CertificateVerificationResponse(
        verification_status=result["verification_status"],
        analysis=CertificateAnalysis(**result["analysis"]),
        certificate_url=result["certificate_url"],
    )
