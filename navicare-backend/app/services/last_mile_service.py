"""
Last-mile guidance: for each place already recommended in a travel plan's
itinerary, suggests how to actually get there from the arrival point (nearest
transit node) — nearest-stop accessibility info, a mode suggestion that's
aware of whether a caretaker is currently assigned, and a Google Maps
navigation handoff link.

Computed fresh on every call rather than stored in the plan — dispatch_status
changes over the course of a trip (no caretaker -> ACCEPTED -> ARRIVED...),
so a cached recommendation would go stale exactly when it matters most.
"""
from app.models.enums import DispatchStatus
from app.services import recommendation_engine as rec
from app.services.auth_service import user_repo
from app.services.travel_service import place_repo, plan_repo, transit_repo

WALKING_SAFE_DISTANCE_KM = 1.0  # only applies to solo non-visually-impaired users, see logic below


def _nearest_transit_node(latitude: float, longitude: float, max_distance_km: float = 10.0):
    nearest, nearest_dist = None, None
    for node in transit_repo.list_all(limit=500):
        d = rec.haversine_distance(latitude, longitude, node.latitude, node.longitude)
        if d <= max_distance_km and (nearest_dist is None or d < nearest_dist):
            nearest, nearest_dist = node, d
    return nearest, nearest_dist


def _maps_navigation_url(
    destination_lat: float,
    destination_lng: float,
    travel_mode: str,
    origin_lat: float | None = None,
    origin_lng: float | None = None,
) -> str:
    """
    Deep link into the Google Maps app — no API key or billing needed, this
    is just a URL scheme Google Maps opens directly, with its own built-in
    spoken turn-by-turn accessibility support. Distinct from the separate
    (paid, optional) Google Maps Platform Directions API, which would give
    real route distances/times instead of our current straight-line Haversine
    estimates — a good upgrade later, not required for this to work.

    origin is optional: omit it and Google Maps uses the phone's live GPS
    location as the starting point (the normal case). Pass it explicitly when
    building a specific hop — e.g. "from this transit stop to that place" —
    where the starting point isn't wherever the user happens to be standing
    right now.
    """
    url = f"https://www.google.com/maps/dir/?api=1&destination={destination_lat},{destination_lng}&travelmode={travel_mode}"
    if origin_lat is not None and origin_lng is not None:
        url += f"&origin={origin_lat},{origin_lng}"
    return url


def build_last_mile_entry(
    place_latitude: float,
    place_longitude: float,
    place_name: str,
    user_disability_types: list[str],
    has_active_caretaker: bool,
    user_latitude: float | None = None,
    user_longitude: float | None = None,
) -> dict:
    is_blind_or_low_vision = any(
        d.lower() in ("visual", "visual_impairment", "blind", "low_vision") for d in user_disability_types
    )

    nearest_node, last_mile_distance_km = _nearest_transit_node(place_latitude, place_longitude)

    if has_active_caretaker:
        mode, travel_mode_param = "walking_with_caretaker", "walking"
        instruction = f"Your caretaker can walk with you to {place_name}."
    elif is_blind_or_low_vision:
        # Never suggest solo walking for a blind/low-vision user, regardless of
        # distance — straight-line distance doesn't capture how safe or
        # navigable the actual route/crossings are.
        mode, travel_mode_param = "auto_rickshaw", "transit"
        instruction = f"Take an auto-rickshaw directly to {place_name} rather than walking alone."
    elif last_mile_distance_km is not None and last_mile_distance_km <= WALKING_SAFE_DISTANCE_KM:
        mode, travel_mode_param = "walking_solo", "walking"
        instruction = f"{place_name} is close enough to walk to on your own."
    else:
        mode, travel_mode_param = "auto_rickshaw", "transit"
        instruction = f"Take an auto-rickshaw or a nearby bus to {place_name}."

    if nearest_node:
        lift_note = "a working wheelchair lift" if nearest_node.wheelchair_lift_working else "no confirmed working wheelchair lift"
        instruction += (
            f" Nearest stop: {nearest_node.station_name} "
            f"({round(last_mile_distance_km, 2)} km away, {lift_note})."
        )

    result = {
        "place_name": place_name,
        "suggested_mode": mode,
        "instruction": instruction,
        "nearest_transit_node": nearest_node.station_name if nearest_node else None,
        "nearest_transit_distance_km": round(last_mile_distance_km, 2) if last_mile_distance_km is not None else None,
        # Single-hop link: wherever the user is standing -> the final place.
        # Fine for most cases, but on a long/complex route this is one big
        # jump instead of clear stages.
        "navigation_url": _maps_navigation_url(place_latitude, place_longitude, travel_mode_param),
    }

    # Two-hop links, when we have enough info to build them: current location
    # -> nearest transit stop, then that stop -> the final place. Gives the
    # user two short, clear directions instead of one long ambiguous one —
    # especially useful for the auto-rickshaw/transit cases above.
    if nearest_node and user_latitude is not None and user_longitude is not None:
        result["hop_to_transit_url"] = _maps_navigation_url(
            nearest_node.latitude, nearest_node.longitude, "transit",
            origin_lat=user_latitude, origin_lng=user_longitude,
        )
        result["hop_to_place_url"] = _maps_navigation_url(
            place_latitude, place_longitude, travel_mode_param,
            origin_lat=nearest_node.latitude, origin_lng=nearest_node.longitude,
        )

    return result


def build_last_mile_for_plan(plan_id: str) -> list[dict]:
    plan = plan_repo.get(plan_id)
    if not plan:
        raise ValueError("Travel plan not found")

    has_active_caretaker = plan.dispatch_status in (
        DispatchStatus.ACCEPTED,
        DispatchStatus.ARRIVED,
        DispatchStatus.IN_PROGRESS,
    )

    user = user_repo.get(plan.user_id)
    disability_types = user.disability_types if user else []
    user_latitude = user.Current_latitude if user else None
    user_longitude = user.Current_longitude if user else None

    results = []
    for rp in plan.itinerary_data.get("recommended_places", []):
        place = place_repo.get(rp["place_id"])
        if not place:
            continue
        results.append(
            build_last_mile_entry(
                place.latitude, place.longitude, place.name, disability_types, has_active_caretaker,
                user_latitude=user_latitude, user_longitude=user_longitude,
            )
        )
    return results