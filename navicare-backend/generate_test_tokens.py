"""
NaviCare — Test Token Generator (local/dev testing only)
===========================================================
Registration/login normally require a real Firebase phone-OTP token, which
you won't have in a local test run. This script issues valid JWTs directly
using the same create_access_token() function the app uses internally —
so the tokens are 100% real and will pass every auth check, they just skip
the Firebase OTP step for convenience.

Run this AFTER seed_mock_data.py.

USAGE:
    cd navicare-backend
    python generate_test_tokens.py
"""
import sys

sys.path.insert(0, ".")

from app.core.security import Role, create_access_token

ACCOUNTS = [
    ("mock-user-001", Role.USER, "Anjali Rao (User)"),
    ("mock-user-002", Role.USER, "Rajesh Kumar (User)"),
    ("mock-caretaker-001", Role.CARETAKER, "Priya Sharma (Caretaker)"),
    ("mock-caretaker-002", Role.CARETAKER, "Suresh Babu (Caretaker)"),
    ("mock-caretaker-003", Role.CARETAKER, "Karthik Iyer (Caretaker, unverified)"),
]

if __name__ == "__main__":
    print("Bearer tokens for testing (paste into Authorization: Bearer <token>)\n")
    for subject_id, role, label in ACCOUNTS:
        token = create_access_token(subject_id, role)
        print(f"# {label} — {subject_id}")
        print(token)
        print()
