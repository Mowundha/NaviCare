"""
User-generated travel communities (like a WhatsApp community directory).
Chat lives in WhatsApp itself — this only tracks membership + the
destination/date metadata needed to list, filter, and auto-close communities.

Replaces the earlier NGOs-collection "connect with NGO communities" concept.
"""
import re
from datetime import date, timedelta

from app.core.firestore_client import FirestoreRepository
from app.models.community import Community, CommunityCreate, CommunityResponse
from app.models.enums import CommunityStatus

community_repo = FirestoreRepository("Communities", Community, "community_id")

WHATSAPP_INVITE_PATTERN = re.compile(r"^https://chat\.whatsapp\.com/[A-Za-z0-9]+$")
JOIN_CUTOFF_DAYS = 10  # community closes to new members this many days before trip_start_date


def validate_whatsapp_link(link: str) -> None:
    if not WHATSAPP_INVITE_PATTERN.match(link):
        raise ValueError("whatsapp_invite_link must be a valid WhatsApp invite link (https://chat.whatsapp.com/...)")


def compute_status(trip_start_date: date, trip_end_date: date, today: date | None = None) -> CommunityStatus:
    today = today or date.today()
    if today > trip_end_date:
        return CommunityStatus.EXPIRED
    if today >= trip_start_date - timedelta(days=JOIN_CUTOFF_DAYS):
        return CommunityStatus.CLOSED
    return CommunityStatus.ACTIVE


def _to_response(community: Community) -> CommunityResponse:
    return CommunityResponse(
        **community.model_dump(exclude={"member_user_ids"}),
        member_count=len(community.member_user_ids),
        status=compute_status(community.trip_start_date, community.trip_end_date),
    )


def create_community(creator_user_id: str, payload: CommunityCreate) -> CommunityResponse:
    validate_whatsapp_link(payload.whatsapp_invite_link)
    if payload.trip_start_date > payload.trip_end_date:
        raise ValueError("trip_start_date must be before trip_end_date")
    if payload.trip_start_date < date.today():
        raise ValueError("trip_start_date cannot be in the past")

    community = Community(
        community_id=community_repo.generate_id(),
        creator_user_id=creator_user_id,
        title=payload.title,
        destination_name=payload.destination_name,
        destination_latitude=payload.destination_latitude,
        destination_longitude=payload.destination_longitude,
        trip_start_date=payload.trip_start_date,
        trip_end_date=payload.trip_end_date,
        whatsapp_invite_link=payload.whatsapp_invite_link,
        description=payload.description,
        member_user_ids=[creator_user_id],
    )
    created = community_repo.create(community)
    return _to_response(created)


def join_community(community_id: str, user_id: str) -> CommunityResponse:
    community = community_repo.get(community_id)
    if not community:
        raise ValueError("Community not found")

    status = compute_status(community.trip_start_date, community.trip_end_date)
    if status != CommunityStatus.ACTIVE:
        raise ValueError(f"This community is no longer open to new members (status: {status.value})")

    if user_id in community.member_user_ids:
        raise ValueError("Already a member of this community")

    updated_members = community.member_user_ids + [user_id]
    community_repo.update(community_id, {"member_user_ids": updated_members})
    return _to_response(community_repo.get(community_id))


def get_community(community_id: str) -> CommunityResponse | None:
    community = community_repo.get(community_id)
    return _to_response(community) if community else None


def list_active_communities(destination_name: str | None = None, limit: int = 100) -> list[CommunityResponse]:
    all_communities = community_repo.list_all(limit=500)
    active = [c for c in all_communities if compute_status(c.trip_start_date, c.trip_end_date) == CommunityStatus.ACTIVE]

    if destination_name:
        needle = destination_name.strip().lower()
        active = [c for c in active if needle in c.destination_name.lower()]

    return [_to_response(c) for c in active[:limit]]


def find_communities_near_destination(destination_name: str, limit: int = 5) -> list[CommunityResponse]:
    """Used by travel_service.generate_plan to surface active communities heading to the same place."""
    return list_active_communities(destination_name=destination_name, limit=limit)