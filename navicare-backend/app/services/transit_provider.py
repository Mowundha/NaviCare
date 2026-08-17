"""
Google Routes API transit provider for NaviCare.

This module:
- requests real public-transit routes from Google Routes API
- supports buses, trains and walking connections
- converts Google's response into NaviCare TransitJourney models
- does NOT handle bookings
- does NOT expose the Google API key to the frontend
"""

import os
import re
from datetime import datetime, time, timezone, timedelta

import requests
from dotenv import load_dotenv

from app.models.travel_plan import (
    TransitJourney,
    TransitLeg,
    TransitLocation,
    TransitSearchRequest,
)

load_dotenv()


GOOGLE_ROUTES_URL = (
    "https://routes.googleapis.com/directions/v2:computeRoutes"
)


def _parse_duration_seconds(duration: str | None) -> int | None:
    """
    Google returns durations such as:
        "123s"
        "3600s"
    """
    if not duration:
        return None

    match = re.match(r"^(\d+(?:\.\d+)?)s$", duration)

    if not match:
        return None

    return int(float(match.group(1)))


def _parse_datetime(value: str | None) -> datetime | None:
    """
    Convert Google's RFC3339 timestamp into a Python datetime.
    """
    if not value:
        return None

    try:
        return datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError:
        return None


def _location_from_google(
    location: dict | None,
    fallback_name: str | None = None,
) -> TransitLocation:
    """
    Convert Google's LatLng location into NaviCare's TransitLocation.
    """
    lat_lng = (location or {}).get("latLng", {})

    return TransitLocation(
        name=fallback_name,
        latitude=float(lat_lng.get("latitude", 0.0)),
        longitude=float(lat_lng.get("longitude", 0.0)),
    )


def _build_departure_time(
    request: TransitSearchRequest,
) -> datetime | None:
    """
    Decide when Google should search for the transit journey.

    Priority:
    1. Explicit departure_time supplied by caller.
    2. travel_date supplied -> 09:00 AM IST on that date.
    3. None -> Google uses the current time.
    """

    if request.departure_time:
        return request.departure_time

    if request.travel_date:
        india_timezone = timezone(timedelta(hours=5, minutes=30))

        return datetime.combine(
            request.travel_date,
            time(hour=9, minute=0),
            tzinfo=india_timezone,
        )

    return None


def _build_request_body(
    request: TransitSearchRequest,
) -> dict:
    """
    Build the request body expected by Google Routes API.
    """

    body = {
        "origin": {
            "location": {
                "latLng": {
                    "latitude": request.source_latitude,
                    "longitude": request.source_longitude,
                }
            }
        },
        "destination": {
            "location": {
                "latLng": {
                    "latitude": request.destination_latitude,
                    "longitude": request.destination_longitude,
                }
            }
        },
        "travelMode": "TRANSIT",
        "computeAlternativeRoutes": True,
        "transitPreferences": {
            "routingPreference": request.preference,
            "allowedTravelModes": [
                "BUS",
                "TRAIN",
                "SUBWAY",
                "LIGHT_RAIL",
                "RAIL",
            ],
        },
    }

    departure_time = _build_departure_time(request)

    if departure_time:
        body["departureTime"] = departure_time.astimezone(
            timezone.utc
        ).isoformat().replace("+00:00", "Z")

    return body

def _build_field_mask() -> str:
    """
    Request only the fields NaviCare needs from Google Routes API.
    """

    return ",".join(
        [
            "routes.duration",
            "routes.distanceMeters",
            "routes.legs.steps.travelMode",
            "routes.legs.steps.startLocation",
            "routes.legs.steps.endLocation",
            "routes.legs.steps.staticDuration",
            "routes.legs.steps.distanceMeters",
            "routes.legs.steps.navigationInstruction",
            "routes.legs.steps.transitDetails",
            "routes.legs.steps.localizedValues",
        ]
    )


def _parse_transit_step(
    step: dict,
) -> TransitLeg:
    """
    Convert one Google route step into one NaviCare TransitLeg.
    """

    mode = step.get("travelMode", "UNKNOWN")

    start_location = _location_from_google(
        step.get("startLocation")
    )

    end_location = _location_from_google(
        step.get("endLocation")
    )

    duration_seconds = _parse_duration_seconds(
        step.get("staticDuration")
    )

    distance_meters = step.get("distanceMeters")

    instructions = (
        step.get("navigationInstruction", {})
        .get("instructions")
    )

    transit_details = step.get("transitDetails") or {}

    stop_details = transit_details.get("stopDetails") or {}

    departure_stop = stop_details.get("departureStop") or {}
    arrival_stop = stop_details.get("arrivalStop") or {}

    departure_stop_name = departure_stop.get("name")
    arrival_stop_name = arrival_stop.get("name")

    # Walking steps don't contain transitDetails.
    if not transit_details:

        start_location.name = start_location.name or departure_stop_name
        end_location.name = end_location.name or arrival_stop_name

        return TransitLeg(
            mode=mode,
            name=None,
            departure_location=start_location,
            arrival_location=end_location,
            duration_seconds=duration_seconds,
            distance_meters=distance_meters,
            departure_stop=departure_stop_name,
            arrival_stop=arrival_stop_name,
            wheelchair_accessible=None,
            accessibility_status="UNKNOWN",
            instructions=instructions,
        )

    transit_line = transit_details.get("transitLine") or {}

    vehicle = transit_line.get("vehicle") or {}

    vehicle_type = vehicle.get("type", mode)

    line_name = (
        transit_line.get("name")
        or transit_line.get("nameShort")
        or vehicle.get("name", {}).get("text")
    )

    departure_time = _parse_datetime(
        stop_details.get("departureTime")
    )

    arrival_time = _parse_datetime(
        stop_details.get("arrivalTime")
    )

    start_location = _location_from_google(
        departure_stop.get("location"),
        departure_stop_name,
    )

    end_location = _location_from_google(
        arrival_stop.get("location"),
        arrival_stop_name,
    )

    return TransitLeg(
        mode=vehicle_type,
        name=line_name,
        departure_location=start_location,
        arrival_location=end_location,
        departure_time=departure_time,
        arrival_time=arrival_time,
        duration_seconds=duration_seconds,
        distance_meters=distance_meters,
        departure_stop=departure_stop_name,
        arrival_stop=arrival_stop_name,
        wheelchair_accessible=None,
        accessibility_status="UNKNOWN",
        instructions=instructions,
    )

def _merge_same_mode_legs(legs: list[TransitLeg]) -> list[TransitLeg]:
    """
    Google can split one continuous journey into many small steps.

    Example:
        WALK
        WALK
        WALK
        BUS
        WALK
        WALK

    becomes:
        WALK
        BUS
        WALK

    We keep transit modes such as BUS/TRAIN as separate legs and
    only merge consecutive legs with the same mode.
    """

    if not legs:
        return []

    merged: list[TransitLeg] = []

    for current in legs:
        if not merged:
            merged.append(current)
            continue

        previous = merged[-1]

        if previous.mode != current.mode:
            merged.append(current)
            continue

        # Merge consecutive legs with the same mode.
        previous.arrival_location = current.arrival_location
        previous.arrival_time = current.arrival_time

        if current.arrival_stop:
            previous.arrival_stop = current.arrival_stop

        if current.distance_meters is not None:
            previous.distance_meters = (
                (previous.distance_meters or 0)
                + current.distance_meters
            )

        if current.duration_seconds is not None:
            previous.duration_seconds = (
                (previous.duration_seconds or 0)
                + current.duration_seconds
            )

        if current.instructions:
            if previous.instructions:
                previous.instructions += f" → {current.instructions}"
            else:
                previous.instructions = current.instructions

    return merged

def _parse_route(
    route: dict,
    request: TransitSearchRequest,
    route_index: int,
) -> TransitJourney:
    """
    Convert one Google route into one NaviCare TransitJourney.
    """

    route_legs = route.get("legs") or []

    all_steps: list[dict] = []

    for route_leg in route_legs:
        all_steps.extend(route_leg.get("steps") or [])

    transit_legs = [
    _parse_transit_step(step)
    for step in all_steps
    ]

    transit_legs = _merge_same_mode_legs(transit_legs)

    origin = TransitLocation(
        name="Current location",
        latitude=request.source_latitude,
        longitude=request.source_longitude,
    )

    destination = TransitLocation(
        name=request.destination_name,
        latitude=request.destination_latitude,
        longitude=request.destination_longitude,
    )

    departure_time = None
    arrival_time = None

    # Use the first transit departure time if available.
    for leg in transit_legs:
        if leg.departure_time:
            departure_time = leg.departure_time
            break

    # Use the last transit arrival time if available.
    for leg in reversed(transit_legs):
        if leg.arrival_time:
            arrival_time = leg.arrival_time
            break

    number_of_transfers = max(
        0,
        sum(
            1
            for leg in transit_legs
            if leg.mode
            not in {"WALK", "BICYCLE"}
        )
        - 1,
    )

    accessibility_summary = [
        "Accessibility information for individual transit vehicles "
        "and stations is not guaranteed by the transit provider."
    ]

    return TransitJourney(
        journey_id=f"google-route-{route_index + 1}",
        origin=origin,
        destination=destination,
        departure_time=departure_time,
        arrival_time=arrival_time,
        duration_seconds=_parse_duration_seconds(
            route.get("duration")
        ),
        distance_meters=route.get("distanceMeters"),
        number_of_transfers=number_of_transfers,
        legs=transit_legs,
        accessibility_summary=accessibility_summary,
        provider="google_routes",
    )


def search_transit_routes(
    request: TransitSearchRequest,
) -> list[TransitJourney]:
    """
    Search real public-transit journeys using Google Routes API.
    """

    api_key = os.getenv("GOOGLE_MAPS_API_KEY")

    if not api_key:
        raise RuntimeError(
            "GOOGLE_MAPS_API_KEY is not configured."
        )

    request_body = _build_request_body(request)

    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": api_key,
        "X-Goog-FieldMask": _build_field_mask(),
    }

    try:
        response = requests.post(
            GOOGLE_ROUTES_URL,
            headers=headers,
            json=request_body,
            timeout=20,
        )

        if not response.ok:
            print("\n===== GOOGLE ROUTES API ERROR =====")
            print("Status:", response.status_code)
            print("Response:", response.text)
            print("===================================\n")

        response.raise_for_status()

    except requests.RequestException as exc:
        raise RuntimeError(
            f"Google Routes API request failed: {exc}"
        ) from exc
    data = response.json()

    routes = data.get("routes") or []

    if not routes:
        return []

    return [
        _parse_route(
            route=route,
            request=request,
            route_index=index,
        )
        for index, route in enumerate(routes)
    ]