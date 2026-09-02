"""
NaviCare — Mock Data Seeder (for local/dev testing only)
==========================================================
Writes realistic test data straight into Firestore: 2 Users, 3 Caretakers,
4 Accessible_Places (one deliberately "Unverified" — this is the exact case
that used to crash /travel/generate-plan before today's fix), 3 Transit_Nodes,
and 1 Community.

WHY THIS BYPASSES /auth/register:
Registration normally requires a real Firebase phone-OTP token
(firebase_id_token). For local testing without wiring up Firebase, this
script writes documents directly with FirestoreRepository — the same
repository the app itself uses — so the data looks exactly like what
registration would have produced.

USAGE:
    cd navicare-backend
    pip install -r requirements.txt
    python seed_mock_data.py
    (needs GOOGLE_APPLICATION_CREDENTIALS or ADC set up, same as running the app)

After running this, use generate_test_tokens.py to get JWTs for the mock
User/Caretaker accounts so you can call protected endpoints without going
through Firebase OTP.
"""
import sys
from datetime import date, timedelta

sys.path.insert(0, ".")

from app.core.security import hash_password
from app.models.caretaker import Caretaker
from app.models.community import Community
from app.models.directory import AccessiblePlace, TransitNode
from app.models.enums import PlaceVerificationStatus, TransitType, VerificationStatus
from app.models.user import User
from app.services.auth_service import caretaker_repo, user_repo
from app.services.community_service import community_repo
from app.services.travel_service import place_repo, transit_repo

MOCK_PASSWORD = "Test@1234"  # same password for every mock account, for convenience

# ---------------------------------------------------------------------------
# Users — Chennai, T. Nagar area
# ---------------------------------------------------------------------------
USERS = [
    User(
        user_id="mock-user-001",
        full_name="Anjali Rao",
        email="anjali.rao@example.com",
        phone_number="+919800000001",
        age=34,
        gender="Female",
        disability_types=["mobility", "visual"],
        mobility_equipment="Manual wheelchair",
        additional_notes="Prefers ground-floor accessible routes where possible.",
        emergency_contact_name="Kiran Rao",
        emergency_contact_phone="+919800000099",
        Current_latitude=13.0418,
        Current_longitude=80.2341,
        hashed_password=hash_password(MOCK_PASSWORD),
    ),
    User(
        user_id="mock-user-002",
        full_name="Rajesh Kumar",
        email="rajesh.kumar@example.com",  # deliberately no email — matches your registration screen
        phone_number="+919800000002",
        age=41,
        gender="Male",
        disability_types=["auditory"],
        additional_notes="Uses a hearing aid; prefers text-based instructions.",
        emergency_contact_phone="+919800000098",
        Current_latitude=13.0350,
        Current_longitude=80.2400,
        hashed_password=hash_password(MOCK_PASSWORD),
    ),
]

# ---------------------------------------------------------------------------
# Caretakers — positioned near the mock destination (Marina Beach area)
# so the matching engine actually finds them within range.
# ---------------------------------------------------------------------------
CARETAKERS = [
    Caretaker(
        caretaker_id="mock-caretaker-001",
        full_name="Priya Sharma",
        phone_number="+919800000011",
        gender="Female",
        hourly_rate=250.0,
        daily_rate=1800.0,
        certifications=["First Aid", "Elderly Care"],
        verification_status=VerificationStatus.VERIFIED,
        latitude=13.0520,
        longitude=80.2800,
        Email="priya.sharma@example.com",
        is_available=True,
        supported_disabilities=["mobility", "visual"],
        hashed_password=hash_password(MOCK_PASSWORD),
    ),
    Caretaker(
        caretaker_id="mock-caretaker-002",
        full_name="Suresh Babu",
        phone_number="+919800000012",
        gender="Male",
        hourly_rate=220.0,
        daily_rate=1600.0,
        certifications=["CPR", "Mobility Assistance"],
        verification_status=VerificationStatus.VERIFIED,
        latitude=13.0600,
        longitude=80.2750,
        Email="suresh.babu@example.com",
        is_available=True,
        supported_disabilities=["mobility", "auditory"],
        hashed_password=hash_password(MOCK_PASSWORD),
    ),
    Caretaker(
        caretaker_id="mock-caretaker-003",
        full_name="Karthik Iyer",
        phone_number="+919800000013",
        gender="Male",
        hourly_rate=200.0,
        certifications=["First Aid"],
        verification_status=VerificationStatus.PENDING,  # not yet verified — should NOT show up in matches
        latitude=13.0550,
        longitude=80.2780,
        Email="karthik.iyer@example.com",
        is_available=True,
        supported_disabilities=["mobility"],
        hashed_password=hash_password(MOCK_PASSWORD),
    ),
]

# ---------------------------------------------------------------------------
# Accessible Places — near the mock destination.
# P004 is deliberately "Unverified": this is the exact case that used to
# crash /travel/generate-plan before today's enum fix. It should now be
# silently filtered out, not cause an error.
# ---------------------------------------------------------------------------
PLACES = [
    AccessiblePlace(
        place_id="mock-place-001",
        name="Marina Accessible Cafe",
        category="Restaurant",
        address="Marina Beach Rd, Chennai",
        latitude=13.0500,
        longitude=80.2824,
        has_wheelchair_ramp=True,
        has_accessible_restrooms=True,
        has_braille_menu=True,
        has_audio_guides=False,
        verification_status=PlaceVerificationStatus.VERIFIED,
    ),
    AccessiblePlace(
        place_id="mock-place-002",
        name="Hotel Comfort Stay",
        category="Hotel",
        address="Kamarajar Salai, Chennai",
        latitude=13.0480,
        longitude=80.2790,
        has_wheelchair_ramp=True,
        has_accessible_restrooms=True,
        has_braille_menu=False,
        has_audio_guides=False,
        verification_status=PlaceVerificationStatus.VERIFIED,
    ),
    AccessiblePlace(
        place_id="mock-place-003",
        name="City Heritage Museum",
        category="Tourist Spot",
        address="Pantheon Rd, Chennai",
        latitude=13.0605,
        longitude=80.2496,
        has_wheelchair_ramp=True,
        has_accessible_restrooms=True,
        has_braille_menu=True,
        has_audio_guides=True,
        verification_status=PlaceVerificationStatus.VERIFIED,
    ),
    AccessiblePlace(
        place_id="mock-place-004",
        name="New Bistro (not yet reviewed)",
        category="Restaurant",
        address="Anna Salai, Chennai",
        latitude=13.0510,
        longitude=80.2810,
        has_wheelchair_ramp=True,
        has_accessible_restrooms=False,
        has_braille_menu=False,
        has_audio_guides=False,
        verification_status=PlaceVerificationStatus.UNVERIFIED,  # <- the crash-triggering status
    ),
]

# ---------------------------------------------------------------------------
# Transit nodes — used by last-mile guidance
# ---------------------------------------------------------------------------
TRANSIT_NODES = [
    TransitNode(
        transit_id="mock-transit-001",
        type=TransitType.BUS_STOP,
        station_name="Marina Beach Bus Stop",
        latitude=13.0495,
        longitude=80.2815,
        wheelchair_lift_working=True,
        tactile_flooring_present=True,
    ),
    TransitNode(
        transit_id="mock-transit-002",
        type=TransitType.TRAIN_STATION,
        station_name="Chennai Central",
        latitude=13.0827,
        longitude=80.2757,
        wheelchair_lift_working=False,
        tactile_flooring_present=False,
    ),
    TransitNode(
        transit_id="mock-transit-003",
        type=TransitType.BUS_STOP,
        station_name="T. Nagar Bus Terminus",
        latitude=13.0410,
        longitude=80.2337,
        wheelchair_lift_working=True,
        tactile_flooring_present=False,
    ),
]

# ---------------------------------------------------------------------------
# Community — active, joinable
# ---------------------------------------------------------------------------
COMMUNITY = Community(
    community_id="mock-community-001",
    creator_user_id="mock-user-001",
    title="Chennai Marina Weekend Trip",
    destination_name="Marina Beach, Chennai",
    destination_latitude=13.0500,
    destination_longitude=80.2824,
    trip_start_date=date.today() + timedelta(days=30),
    trip_end_date=date.today() + timedelta(days=32),
    whatsapp_invite_link="https://chat.whatsapp.com/MockInviteLinkABC123",
    description="A small group heading to Marina Beach — accessible meetup point at the lighthouse.",
    member_user_ids=["mock-user-001"],
)


def seed():
    print("Seeding Users...")
    for u in USERS:
        user_repo.create(u)
        print(f"  + {u.user_id} ({u.full_name})")

    print("Seeding Caretakers...")
    for c in CARETAKERS:
        caretaker_repo.create(c)
        print(f"  + {c.caretaker_id} ({c.full_name}, verified={c.verification_status.value})")

    print("Seeding Accessible Places...")
    for p in PLACES:
        place_repo.create(p)
        print(f"  + {p.place_id} ({p.name}, status={p.verification_status.value})")

    print("Seeding Transit Nodes...")
    for t in TRANSIT_NODES:
        transit_repo.create(t)
        print(f"  + {t.transit_id} ({t.station_name})")

    print("Seeding Community...")
    community_repo.create(COMMUNITY)
    print(f"  + {COMMUNITY.community_id} ({COMMUNITY.title})")

    print("\nDone. Mock password for every seeded account:", MOCK_PASSWORD)
    print("Run generate_test_tokens.py next to get JWTs for calling protected endpoints.")


if __name__ == "__main__":
    seed()
