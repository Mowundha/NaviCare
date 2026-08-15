"""
Gemini Vision integration for automated caretaker certificate verification.
Sends the uploaded certificate image/PDF straight to Gemini with a prompt
that extracts exactly the fields verification_service needs to decide
Verified vs Rejected, as structured JSON.
"""
import json
from datetime import date

from google import genai
from google.genai import types

from app.core.config import settings

_client: genai.Client | None = None

CERTIFICATE_ANALYSIS_PROMPT = """
You are verifying a caregiving/medical accreditation certificate for a caretaker
registering on an accessible-travel platform.

The caretaker registered under the name: "{expected_name}"
Today's date is: {today}

Analyze the attached certificate and respond with ONLY a raw JSON object
(no markdown fences, no preamble, no explanation) with exactly these keys:

{{
  "extracted_name": string or null,
  "name_matches": boolean,
  "expiry_date": string in YYYY-MM-DD format, or null if absent or lifetime-valid,
  "is_expired": boolean,
  "accreditation_keywords_found": list of strings (e.g. "CPR", "Nursing", "Elderly Care", "First Aid", "Home Health Aide"),
  "has_valid_accreditation_keywords": boolean,
  "confidence": float between 0 and 1
}}

Rules:
- name_matches: true if extracted_name reasonably matches "{expected_name}" (allow minor spelling/spacing/order differences).
- is_expired: true only if an expiry date is present and it is before {today}. If no expiry date is found, is_expired must be false.
- has_valid_accreditation_keywords: true only if the document is a genuine medical/caregiving credential (CPR, nursing, elder care, first aid, home health aide, disability support, etc.), not an unrelated document.
"""


def _get_client() -> genai.Client:
    global _client
    if _client is None:
        _client = genai.Client(api_key=settings.GEMINI_API_KEY)
    return _client


def _strip_markdown_fence(text: str) -> str:
    text = text.strip()
    if text.startswith("```"):
        text = text.strip("`")
        if text.lower().startswith("json"):
            text = text[4:]
    return text.strip()


def analyze_certificate(file_bytes: bytes, mime_type: str, expected_name: str) -> dict:
    """
    Returns a dict matching CertificateAnalysis fields.
    Raises on API failure or unparsable response — caller decides how to handle.
    """
    client = _get_client()
    prompt = CERTIFICATE_ANALYSIS_PROMPT.format(expected_name=expected_name, today=date.today().isoformat())

    response = client.models.generate_content(
        model=settings.GEMINI_MODEL,
        contents=[
            types.Part.from_bytes(data=file_bytes, mime_type=mime_type),
            prompt,
        ],
    )

    return json.loads(_strip_markdown_fence(response.text))
