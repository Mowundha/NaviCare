"""
PLACEHOLDER transit schedule provider. NaviCare only lists train/bus options
(no booking), so this can be backed by a static admin-curated Firestore
collection, a GTFS feed, or a partner rail/bus data API later — swap the
implementation in this file only; travel_service.py doesn't need to change.
"""

_MOCK_TRAINS = [
    {"name": "Shatabdi Express", "boarding_time": "06:00 AM", "duration": "4h", "arrival_time": "10:00 AM", "specialized_coach_available": True},
    {"name": "Rajdhani Express", "boarding_time": "07:30 AM", "duration": "3.5h", "arrival_time": "11:00 AM", "specialized_coach_available": True},
    {"name": "Duronto Express", "boarding_time": "08:15 AM", "duration": "5h", "arrival_time": "01:15 PM", "specialized_coach_available": False},
    {"name": "Garib Rath", "boarding_time": "09:00 AM", "duration": "6h", "arrival_time": "03:00 PM", "specialized_coach_available": False},
    {"name": "Jan Shatabdi", "boarding_time": "10:45 AM", "duration": "4.5h", "arrival_time": "03:15 PM", "specialized_coach_available": True},
]

_MOCK_BUSES = [
    {"name": "State Express AC Sleeper", "boarding_time": "09:00 PM", "duration": "8h", "arrival_time": "05:00 AM", "specialized_coach_available": False},
    {"name": "Volvo Multi-Axle", "boarding_time": "10:00 PM", "duration": "7.5h", "arrival_time": "05:30 AM", "specialized_coach_available": True},
]


def get_train_options(destination_name: str) -> list[dict]:
    return _MOCK_TRAINS


def get_bus_options(destination_name: str) -> list[dict]:
    return _MOCK_BUSES
