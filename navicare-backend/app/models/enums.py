from enum import Enum


class VerificationStatus(str, Enum):
    PENDING = "Pending"
    VERIFIED = "Verified"
    REJECTED = "Rejected"


class PlaceVerificationStatus(str, Enum):
    """Accessible_Places uses 'Unverified' instead of 'Rejected' — kept
    separate from VerificationStatus (Caretakers/NGOs) so the two can't
    drift into each other's values."""
    PENDING = "Pending"
    VERIFIED = "Verified"
    UNVERIFIED = "Unverified"

class CommunityStatus(str, Enum):
    """Computed on read from trip dates, never stored — see community_service.compute_status."""
    ACTIVE = "Active"      # open to new members
    CLOSED = "Closed"      # within 10 days of trip start — no new joins, but trip hasn't happened
    EXPIRED = "Expired"    # trip end date has passed

class TravelPlanStatus(str, Enum):
    DRAFT = "Draft"
    CONFIRMED = "Confirmed"
    COMPLETED = "Completed"
    CANCELLED = "Cancelled"


class PaymentStatus(str, Enum):
    PENDING = "Pending"
    HELD_IN_ESCROW = "Held_In_Escrow"
    RELEASED = "Released"
    REFUNDED = "Refunded"


class PayoutStatus(str, Enum):
    PROCESSING = "Processing"
    TRANSFERRED = "Transferred"
    FAILED = "Failed"


class DispatchStatus(str, Enum):
    REQUESTED = "REQUESTED"
    ACCEPTED = "ACCEPTED"
    ARRIVED = "ARRIVED"
    IN_PROGRESS = "IN_PROGRESS"
    COMPLETED = "COMPLETED"
    CANCELLED = "CANCELLED"


class TransitType(str, Enum):
    TRAIN_STATION = "Train Station"
    BUS_STOP = "Bus Stop"
    AIRPORT = "Airport"


class ReviewTargetType(str, Enum):
    PLACE = "Place"
    CARETAKER = "Caretaker"
    TRANSIT = "Transit"


class AgentInputMode(str, Enum):
    VOICE = "Voice"
    TEXT = "Text"
