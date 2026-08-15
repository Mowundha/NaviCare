# What changed in this fix pass

## Bugs fixed
1. app/services/travel_service.py - generate_plan() referenced an undefined
   `nearby_communities` variable, which crashed every call to
   POST /travel/generate-plan (your core "create a trip" endpoint). Now
   correctly calls community_service.find_communities_near_destination(...).
2. Caretaker availability - added PATCH /caretaker/availability so a
   caretaker can toggle themselves available/unavailable. Previously the
   model existed (CaretakerAvailabilityUpdate) but no route used it.
3. Admin data entry - added POST /admin/places, GET /admin/places,
   PATCH /admin/places/{id}/verification, POST /admin/transit,
   GET /admin/transit. Previously there was no way to add hotels,
   restaurants, tourist spots, or train/bus stations except by hand-editing
   Firestore. These routes are gated by a new X-Admin-Key header - set
   ADMIN_API_KEY in your .env to a long random string.
4. Reviews - added POST /reviews/ and GET /reviews/{target_type}/{target_id}.
   The Review model existed but had zero service or route behind it.

## Feature addition
- app/services/last_mile_service.py - navigation links now also include
  hop_to_transit_url and hop_to_place_url: two shorter Google Maps
  hand-off links (current location -> nearest transit stop, then stop ->
  final place) instead of one long jump. The original single-hop
  navigation_url is kept too, unchanged.

## How to apply this to your real project
1. Copy every file in this folder over the matching path in your project
   (same folder structure: app/..., Dockerfile, requirements.txt). Your
   .gitignore, .venv, and existing .env are untouched by this - they were
   deliberately excluded from this package.
2. Open your real .env and add one new line:
   ADMIN_API_KEY=<make up a long random string>
3. Restart your server (uvicorn app.main:app --reload) and confirm it
   boots with no errors - python -m pyflakes app/ should report nothing
   except a few pre-existing harmless "imported but unused" warnings.

## Still flagged from the review, not fixed yet (your call on priority)
- .env has live API keys committed in the zip you sent me - rotate the
  Gemini and Razorpay keys, and make sure .env is in .gitignore.
- ALLOWED_ORIGINS = ["*"] should be locked down before production.
- No push notifications yet for caretaker dispatch requests (WebSocket only
  works while the app is open).
