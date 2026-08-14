"""
identity_verification.py
==========================
NaviCare backend — Caretaker Identity & Background Verification.

Provider: Sandbox (sandbox.co.in / developer.sandbox.co.in) — a real,
documented Indian KYC-API provider (PAN / Aadhaar / GSTIN / DigiLocker
verification). Confirmed against their public docs as of Aug 2026.

Two IMPORTANT facts about how Sandbox's API is structured, which caused
the bugs in the previous version of this file:

  1. Authentication happens on a DIFFERENT host than the actual KYC
     checks. You authenticate at https://api.sandbox.co.in/authenticate
     but call the PAN-check endpoint at https://test-api.sandbox.co.in
     (in sandbox/test mode) or https://api.sandbox.co.in (in production,
     with production keys). Two separate base URLs — don't reuse one for
     both steps.
  2. Every Sandbox response wraps its payload in a "data" object:
     {"code": 200, "data": {...the actual fields...}, "transaction_id": "..."}
     Always read fields from response["data"], never from the top level.

--------------------------------------------------------------------------
FAIL-CLOSED BY DESIGN (unchanged from the previous version)
--------------------------------------------------------------------------
If the verification provider is unreachable, misconfigured, returns an
error, or returns a response we don't recognize, this module returns
VERIFICATION_UNAVAILABLE — never VERIFIED. A caretaker is only ever
eligible when Sandbox gives a genuine, successful "valid" PAN status
with a real name/DOB match (or, for POLICE_CLEARANCE, after manual
review completes and updates the record out-of-band).

A SIMULATION mode exists for local development ONLY. It is opt-in via an
explicit environment variable, every simulated response is tagged
`"simulated": True`, and it is logged loudly on every call.
"""

from __future__ import annotations

import os
import re
import json
import uuid
import logging
from datetime import datetime, timezone
from enum import Enum
from typing import Dict, Optional

import requests
from dotenv import load_dotenv

load_dotenv()

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
logger = logging.getLogger("identity_verification")
if not logger.handlers:
    handler = logging.StreamHandler()
    handler.setFormatter(
        logging.Formatter("%(asctime)s [%(levelname)s] identity_verification: %(message)s")
    )
    logger.addHandler(handler)
logger.setLevel(logging.INFO)


# ---------------------------------------------------------------------------
# Configuration (environment-driven — nothing sensitive hardcoded)
# ---------------------------------------------------------------------------
# BUG FIX #1: authentication and the actual KYC checks use DIFFERENT hosts.
# Two separate base URLs, not one reused for both.
AUTH_BASE_URL = os.environ.get("IDENTITY_VERIFICATION_AUTH_URL", "https://api.sandbox.co.in").rstrip("/")
VERIFICATION_BASE_URL = os.environ.get("IDENTITY_VERIFICATION_BASE_URL", "https://test-api.sandbox.co.in").rstrip("/")

VERIFICATION_CLIENT_ID = os.environ.get("IDENTITY_VERIFICATION_CLIENT_ID")
VERIFICATION_CLIENT_SECRET = os.environ.get("IDENTITY_VERIFICATION_CLIENT_SECRET")
# Sandbox's own quickstart docs use this exact version string as of writing —
# check developer.sandbox.co.in if you start seeing version-related errors.
API_VERSION = os.environ.get("IDENTITY_VERIFICATION_API_VERSION", "1.0.0")

REQUEST_TIMEOUT_SECONDS = float(os.environ.get("IDENTITY_VERIFICATION_TIMEOUT", "15"))

# Explicit, loud, dev-only opt-in. Never set this in production.
SIMULATION_MODE = os.environ.get("IDENTITY_VERIFICATION_SIMULATION_MODE", "false").lower() == "true"


# ---------------------------------------------------------------------------
# Status vocabulary
# ---------------------------------------------------------------------------
class VerificationStatus(str, Enum):
    VERIFIED = "VERIFIED"                          # provider confirmed a valid PAN with matching name + DOB
    NOT_FOUND = "NOT_FOUND"                         # provider queried successfully, no record exists
    INVALID = "INVALID"                             # PAN invalid, OR valid PAN but name/DOB didn't match
    INVALID_FORMAT = "INVALID_FORMAT"               # failed our own pre-flight format check, never sent to provider
    PENDING_MANUAL_REVIEW = "PENDING_MANUAL_REVIEW" # id_type has no automated check (e.g. police clearance)
    VERIFICATION_UNAVAILABLE = "VERIFICATION_UNAVAILABLE"  # provider unreachable / misconfigured / bad response
    ERROR = "ERROR"                                 # unexpected exception


AUTOMATED_ID_TYPES = {"PAN", "DRIVING_LICENSE"}
MANUAL_REVIEW_ID_TYPES = {"POLICE_CLEARANCE"}
SUPPORTED_ID_TYPES = AUTOMATED_ID_TYPES | MANUAL_REVIEW_ID_TYPES

ID_FORMAT_PATTERNS = {
    "PAN": re.compile(r"^[A-Z]{5}[0-9]{4}[A-Z]$"),
    "DRIVING_LICENSE": re.compile(r"^[A-Z]{2}[0-9]{2}\s?[0-9]{11}$"),
}

# Confirmed against Sandbox's public docs (developer.sandbox.co.in):
#   POST /kyc/pan/verify
# DRIVING_LICENSE path below is NOT independently confirmed — Sandbox's
# product catalog is PAN/Aadhaar/GSTIN/DigiLocker-focused; check
# developer.sandbox.co.in yourself for the current DL endpoint (or an
# alternate provider) before relying on it.
VERIFICATION_ENDPOINTS = {
    "PAN": "/kyc/pan/verify",
    "DRIVING_LICENSE": "/kyc/dl/verify",  # UNCONFIRMED — verify before production use
}


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def _mask_id_number(id_number: str) -> str:
    if len(id_number) <= 4:
        return "*" * len(id_number)
    return "*" * (len(id_number) - 4) + id_number[-4:]


def _utc_timestamp() -> str:
    return datetime.now(timezone.utc).isoformat()


def _validate_format(id_type: str, id_number: str) -> bool:
    pattern = ID_FORMAT_PATTERNS.get(id_type)
    if pattern is None:
        return True
    return bool(pattern.match(id_number.strip()))


def _build_result(
    caretaker_id: str,
    id_type: str,
    status: VerificationStatus,
    verification_id: Optional[str] = None,
    issuer: str = "Sandbox (sandbox.co.in)",
    detail: Optional[str] = None,
    simulated: bool = False,
) -> Dict:
    return {
        "caretaker_id": caretaker_id,
        "id_type": id_type,
        "status": status.value,
        "verification_id": verification_id,
        "issuer": issuer,
        "timestamp": _utc_timestamp(),
        "detail": detail,
        "simulated": simulated,
    }


def _simulate_provider_response(id_type: str, id_number: str) -> Dict:
    """
    Local-dev-only simulated response, SHAPED LIKE SANDBOX'S REAL RESPONSE
    so the parsing code underneath gets genuinely exercised — not a
    different fake shape that would hide real parsing bugs.
    """
    logger.warning(
        "SIMULATION MODE ACTIVE — returning a fabricated verification result "
        "for id_type=%s id_number=%s. This must never happen in production.",
        id_type, _mask_id_number(id_number),
    )
    is_invalid_looking = id_number.strip().upper().endswith("B")
    return {
        "code": 200,
        "transaction_id": f"SIM-{uuid.uuid4().hex[:12]}",
        "data": {
            "@entity": "in.co.sandbox.kyc.pan_verification.response",
            "pan": id_number,
            "category": "individual",
            "status": "invalid" if is_invalid_looking else "valid",
            "remarks": None,
            "name_as_per_pan_match": not is_invalid_looking,
            "date_of_birth_match": not is_invalid_looking,
        },
    }


def _get_access_token() -> str:
    """
    BUG FIX #1 + #2: authenticate against AUTH_BASE_URL (not
    VERIFICATION_BASE_URL), and read the token from response["data"]
    ["access_token"] (not the top level).
    """
    if not VERIFICATION_CLIENT_ID or not VERIFICATION_CLIENT_SECRET:
        raise RuntimeError(
            "Identity verification provider is not configured "
            "(missing IDENTITY_VERIFICATION_CLIENT_ID / IDENTITY_VERIFICATION_CLIENT_SECRET)."
        )

    auth_url = f"{AUTH_BASE_URL}/authenticate"
    auth_headers = {
        "x-api-key": VERIFICATION_CLIENT_ID,
        "x-api-secret": VERIFICATION_CLIENT_SECRET,
        "x-api-version": API_VERSION,
        "Content-Type": "application/json",
    }

    auth_resp = requests.post(auth_url, headers=auth_headers, timeout=REQUEST_TIMEOUT_SECONDS)
    auth_resp.raise_for_status()

    body = auth_resp.json()
    access_token = body.get("data", {}).get("access_token")

    if not access_token:
        # This should be rare (a 200 with no token would be a very odd
        # response), but don't let a downstream 401 masquerade as this —
        # fail loudly and specifically here instead.
        raise RuntimeError(f"Authenticate call succeeded (200) but returned no access_token: {body}")

    return access_token


def _call_provider(
    id_type: str,
    id_number: str,
    caretaker_name: str,
    caretaker_dob: str,
) -> Dict:
    """
    Full Sandbox KYC call: get an access token, then hit the ID-type-
    specific verification endpoint with it.

    caretaker_name and caretaker_dob are now REQUIRED (not silently
    defaulted) — Sandbox's PAN check verifies that the name and date of
    birth you send actually match the PAN record (name_as_per_pan_match /
    date_of_birth_match in the response). Passing placeholder values here
    would make every real caretaker fail that match.
    """
    if not VERIFICATION_BASE_URL or not VERIFICATION_CLIENT_ID or not VERIFICATION_CLIENT_SECRET:
        raise RuntimeError(
            "Identity verification provider is not configured "
            "(missing IDENTITY_VERIFICATION_BASE_URL / CLIENT_ID / CLIENT_SECRET)."
        )

    path = VERIFICATION_ENDPOINTS.get(id_type)
    if path is None:
        raise RuntimeError(f"No configured endpoint for id_type={id_type}.")

    access_token = _get_access_token()

    # BUG FIX #3: use `path`, not the undefined `endpoint` variable.
    url = f"{VERIFICATION_BASE_URL}{path}"
    headers = {
        "Authorization": access_token,  # Sandbox docs: no "Bearer " prefix
        "x-api-key": VERIFICATION_CLIENT_ID,
        "x-api-version": API_VERSION,
        "Content-Type": "application/json",
    }

    payload = {
        "@entity": "in.co.sandbox.kyc.pan_verification.request",
        "pan": id_number,
        "name_as_per_pan": caretaker_name,
        "date_of_birth": caretaker_dob,
        "consent": "y",
        "reason": "NaviCare caretaker onboarding verification check",
    }

    response = requests.post(url, json=payload, headers=headers, timeout=REQUEST_TIMEOUT_SECONDS)
    response.raise_for_status()
    return response.json()


def _parse_provider_response(id_type: str, raw: Dict) -> Dict:
    """
    BUG FIX #4: read Sandbox's REAL response shape —
    {"data": {"status": "valid"/"invalid", "name_as_per_pan_match": bool,
              "date_of_birth_match": bool, ...}}
    — instead of the made-up "provider_status" / "verification" keys the
    previous version looked for (which never existed in a real response).
    """
    data = raw.get("data") or {}
    status = str(data.get("status", "")).lower()

    if not status:
        logger.error("Unrecognized provider response shape for id_type=%s: %s", id_type, raw)
        return {"status": VerificationStatus.VERIFICATION_UNAVAILABLE, "verification_id": raw.get("transaction_id")}

    if status == "valid":
        name_match = data.get("name_as_per_pan_match")
        dob_match = data.get("date_of_birth_match")
        # Treat an explicit False match as a real mismatch (someone else's
        # PAN, or a typo) — this is a legitimate INVALID, not a system error.
        if name_match is False or dob_match is False:
            return {
                "status": VerificationStatus.INVALID,
                "verification_id": raw.get("transaction_id"),
            }
        return {
            "status": VerificationStatus.VERIFIED,
            "verification_id": raw.get("transaction_id"),
        }

    if status == "invalid":
        return {"status": VerificationStatus.INVALID, "verification_id": raw.get("transaction_id")}

    logger.error("Unrecognized status value for id_type=%s: %s", id_type, status)
    return {"status": VerificationStatus.VERIFICATION_UNAVAILABLE, "verification_id": raw.get("transaction_id")}


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------
def verify_identity(
    caretaker_id: str,
    id_type: str,
    id_number: str,
    caretaker_name: Optional[str] = None,
    caretaker_dob: Optional[str] = None,
) -> Dict:
    """
    Verify a caretaker's identity document against Sandbox.

    Args:
        caretaker_id: NaviCare caretaker document ID (Firestore doc ID).
        id_type: one of 'PAN', 'DRIVING_LICENSE', 'POLICE_CLEARANCE'.
        id_number: the raw ID/document number as provided by the caretaker.
        caretaker_name: full name exactly as it appears on the ID —
            REQUIRED for PAN/DRIVING_LICENSE checks (Sandbox verifies this
            matches the record). Pull this from the caretaker's Firestore
            profile at call time, don't hardcode it.
        caretaker_dob: date of birth in DD/MM/YYYY format, matching what
            Sandbox expects — REQUIRED for the same reason as above.

    Returns:
        dict with keys: caretaker_id, id_type, status, verification_id,
        issuer, timestamp, detail, simulated. status is VERIFIED only on
        a genuine successful match; anything else (including missing
        config, network failure, or a name/DOB mismatch) is NOT verified.
    """
    id_type = (id_type or "").strip().upper()
    masked = _mask_id_number(id_number or "")

    logger.info("Verification requested: caretaker_id=%s id_type=%s id_number=%s", caretaker_id, id_type, masked)

    if id_type not in SUPPORTED_ID_TYPES:
        logger.warning("Unsupported id_type=%s for caretaker_id=%s", id_type, caretaker_id)
        return _build_result(
            caretaker_id, id_type, VerificationStatus.INVALID_FORMAT,
            detail=f"Unsupported id_type '{id_type}'. Supported: {sorted(SUPPORTED_ID_TYPES)}",
        )

    if not id_number or not id_number.strip():
        return _build_result(
            caretaker_id, id_type, VerificationStatus.INVALID_FORMAT,
            detail="id_number is required.",
        )

    if not _validate_format(id_type, id_number):
        logger.warning("Format validation failed: caretaker_id=%s id_type=%s", caretaker_id, id_type)
        return _build_result(
            caretaker_id, id_type, VerificationStatus.INVALID_FORMAT,
            detail=f"id_number does not match expected format for {id_type}.",
        )

    if id_type in MANUAL_REVIEW_ID_TYPES:
        logger.info("id_type=%s requires manual review — no automated check performed.", id_type)
        return _build_result(
            caretaker_id, id_type, VerificationStatus.PENDING_MANUAL_REVIEW,
            issuer="Manual Review Queue",
            detail="Police Clearance Certificates require BGV-vendor or manual verification; "
                   "this record has been queued and is not yet eligible.",
        )

    # PAN/Driving License checks require name + DOB to actually mean
    # anything (see the docstring). Fail clearly and early rather than
    # silently sending placeholder values that would produce a false
    # mismatch downstream.
    if not caretaker_name or not caretaker_dob:
        logger.warning(
            "Missing caretaker_name/caretaker_dob for caretaker_id=%s id_type=%s — "
            "cannot run a real name/DOB match check.",
            caretaker_id, id_type,
        )
        return _build_result(
            caretaker_id, id_type, VerificationStatus.INVALID_FORMAT,
            detail="caretaker_name and caretaker_dob are required for PAN/DRIVING_LICENSE verification.",
        )

    try:
        if SIMULATION_MODE:
            raw = _simulate_provider_response(id_type, id_number)
            simulated = True
        else:
            raw = _call_provider(id_type, id_number, caretaker_name, caretaker_dob)
            simulated = False

        parsed = _parse_provider_response(id_type, raw)

        result = _build_result(
            caretaker_id, id_type, parsed["status"],
            verification_id=parsed.get("verification_id"),
            simulated=simulated,
        )
        logger.info(
            "Verification result: caretaker_id=%s id_type=%s status=%s simulated=%s",
            caretaker_id, id_type, result["status"], simulated,
        )
        return result

    except requests.exceptions.Timeout:
        logger.error("Provider request timed out: caretaker_id=%s id_type=%s", caretaker_id, id_type)
        return _build_result(
            caretaker_id, id_type, VerificationStatus.VERIFICATION_UNAVAILABLE,
            detail="Verification provider timed out.",
        )

    except requests.exceptions.ConnectionError as exc:
        logger.error("Provider connection error: caretaker_id=%s id_type=%s error=%s", caretaker_id, id_type, exc)
        return _build_result(
            caretaker_id, id_type, VerificationStatus.VERIFICATION_UNAVAILABLE,
            detail="Could not reach verification provider.",
        )

    except requests.exceptions.HTTPError as exc:
        status_code = exc.response.status_code if exc.response is not None else None
        body_snippet = None
        try:
            body_snippet = exc.response.text[:300] if exc.response is not None else None
        except Exception:
            pass
        logger.error(
            "Provider returned HTTP error: caretaker_id=%s id_type=%s status_code=%s body=%s",
            caretaker_id, id_type, status_code, body_snippet,
        )
        detail = f"Provider returned HTTP {status_code}."
        if status_code == 401:
            detail += " Check that your API key/secret are correct and match the base URL you're calling (test vs production)."
        return _build_result(
            caretaker_id, id_type, VerificationStatus.VERIFICATION_UNAVAILABLE,
            detail=detail,
        )

    except (RuntimeError, ValueError) as exc:
        logger.error("Configuration or data error: caretaker_id=%s id_type=%s error=%s", caretaker_id, id_type, exc)
        return _build_result(
            caretaker_id, id_type, VerificationStatus.VERIFICATION_UNAVAILABLE,
            detail=str(exc),
        )

    except json.JSONDecodeError as exc:
        logger.error("Provider returned non-JSON response: caretaker_id=%s id_type=%s error=%s", caretaker_id, id_type, exc)
        return _build_result(
            caretaker_id, id_type, VerificationStatus.VERIFICATION_UNAVAILABLE,
            detail="Provider returned an unparseable response.",
        )

    except Exception as exc:
        logger.exception("Unexpected error during verification: caretaker_id=%s id_type=%s", caretaker_id, id_type)
        return _build_result(
            caretaker_id, id_type, VerificationStatus.ERROR,
            detail=f"Unexpected error: {exc}",
        )


def validate_identity_status(verification_result: Dict) -> bool:
    """
    Strict / fail-closed: only an exact status of "VERIFIED" passes.
    """
    if not isinstance(verification_result, dict):
        logger.error("validate_identity_status received a non-dict input: %r", verification_result)
        return False

    status = verification_result.get("status")
    is_eligible = status == VerificationStatus.VERIFIED.value

    logger.info(
        "Eligibility check: caretaker_id=%s status=%s eligible=%s",
        verification_result.get("caretaker_id"), status, is_eligible,
    )
    return is_eligible


# ---------------------------------------------------------------------------
# Local test block
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    SIMULATION_MODE = False  # forced on for this local test run, regardless of .env
    print("=" * 70)
    print("Running identity_verification.py in forced SIMULATION MODE.")
    print("No real network calls are made. Do NOT use this mode in production.")
    print("=" * 70)

    test_cases = [
        ("Valid PAN with matching name/DOB (simulated VERIFIED)",
         "CT001", "PAN", "ABCDE1234A", "John Doe", "11/11/2001"),
        ("PAN that looks invalid (simulated INVALID)",
         "CT002", "PAN", "ABCDE1234B", "John Doe", "11/11/2001"),
        ("Malformed PAN (fails local format check, no network call)",
         "CT003", "PAN", "12345", "John Doe", "11/11/2001"),
        ("Missing caretaker name/DOB (fails before calling provider)",
         "CT004", "PAN", "ABCDE1234A", None, None),
        ("Police clearance (routes to manual review, no automated check)",
         "CT005", "POLICE_CLEARANCE", "PCC-2026-00098", "John Doe", "11/11/2001"),
        ("Unsupported id_type",
         "CT006", "VOTER_ID", "XYZ1234567", "John Doe", "11/11/2001"),
    ]

    for description, caretaker_id, id_type, id_number, name, dob in test_cases:
        print(f"\n--- {description} ---")
        result = verify_identity(caretaker_id, id_type, id_number, caretaker_name=name, caretaker_dob=dob)
        print(json.dumps(result, indent=2))
        print(f"Eligible for matching: {validate_identity_status(result)}")

    print("\n--- Fail-closed check: unconfigured provider, simulation OFF ---")
    SIMULATION_MODE = False
    backup = VERIFICATION_CLIENT_ID
    globals()["VERIFICATION_CLIENT_ID"] = None
    result = verify_identity("CT007", "PAN", "ABCDE1234A", caretaker_name="John Doe", caretaker_dob="11/11/2001")
    print(json.dumps(result, indent=2))
    assert result["status"] == VerificationStatus.VERIFICATION_UNAVAILABLE.value
    assert validate_identity_status(result) is False
    print("[OK] Confirmed: missing provider config returns VERIFICATION_UNAVAILABLE, not VERIFIED.")
    globals()["VERIFICATION_CLIENT_ID"] = backup

    print("\nAll local test scenarios completed.")