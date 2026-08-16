"""Read-mostly directory collections: NGOs, Accessible_Places, Transit_Nodes."""
from pydantic import BaseModel, EmailStr, Field

from app.models.enums import PlaceVerificationStatus, TransitType


class AccessiblePlace(BaseModel):
    place_id: str
    name: str
    category: str  # 'Restaurant', 'Hotel', 'Tourist Spot', 'Restroom'
    address: str
    latitude: float
    longitude: float
    has_wheelchair_ramp: bool = False
    has_accessible_restrooms: bool = False
    has_braille_menu: bool = False
    has_audio_guides: bool = False
    accessibility_audit_doc: str | None = None
    verification_status: PlaceVerificationStatus = PlaceVerificationStatus.PENDING


class AccessiblePlaceCreate(BaseModel):
    name: str
    category: str
    address: str
    latitude: float
    longitude: float
    has_wheelchair_ramp: bool = False
    has_accessible_restrooms: bool = False
    has_braille_menu: bool = False
    has_audio_guides: bool = False
    accessibility_audit_doc: str | None = None


class TransitNode(BaseModel):
    transit_id: str
    type: TransitType
    station_name: str
    latitude: float
    longitude: float
    wheelchair_lift_working: bool = False
    tactile_flooring_present: bool = False


class TransitNodeCreate(BaseModel):
    type: TransitType
    station_name: str
    latitude: float
    longitude: float
    wheelchair_lift_working: bool = False
    tactile_flooring_present: bool = False
