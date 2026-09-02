from pydantic import BaseModel, Field

from app.models.enums import VerificationStatus


class CertificateAnalysis(BaseModel):
    extracted_name: str | None = None
    name_matches: bool = False
    expiry_date: str | None = None
    is_expired: bool = True
    accreditation_keywords_found: list[str] = Field(default_factory=list)
    has_valid_accreditation_keywords: bool = False
    confidence: float = 0.0


class CertificateVerificationResponse(BaseModel):
    verification_status: VerificationStatus
    analysis: CertificateAnalysis
    certificate_url: str
