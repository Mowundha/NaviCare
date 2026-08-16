# NaviCare ML API Contract

Generated directly from the real Python modules (`recommendation_engine.py`
and `identity_verification.py`) — every field name and status value below
matches what those functions actually take and return. This supersedes any
earlier version that used invented field names like `accessibility_need`,
`document_type: "aadhaar"`, or a `"healthcare"` category.

Three endpoints, one per backend function:

1. `POST /api/v1/recommendations` → `recommend_places()`
2. `POST /api/v1/match-caretaker` → `match_caretakers()`
3. `POST /api/v1/verify-identity` → `verify_identity()`

NOTE: the NGO/community feature (and its `fetch_nearby_ngos()` endpoint)
has been cancelled and removed from this contract.

---

## 1. `POST /api/v1/recommendations`

Ranks accessible places (restaurants, hotels, tourist spots, restrooms)
near the user, filtered by distance and scored by accessibility-feature
coverage. Backed by `recommend_places(user, places, max_distance_km)`.

### Request

```json
{
  "user_id": "usr_101",
  "latitude": 13.0827,
  "longitude": 80.2707,
  "disability_types": ["mobility", "visual"],
  "max_distance_km": 10.0,
  "category": "Restaurant"
}
```

| Field | Type | Notes |
|---|---|---|
| `disability_types` | `list[string]` | **Not** a single string. Valid values: `"visual"`, `"auditory"`, `"mobility"`, `"cognitive"` |
| `category` | `string`, optional | Must be one of `"Restaurant"`, `"Hotel"`, `"Tourist Spot"`, `"Restroom"` — omit to search all categories |
| `max_distance_km` | `float`, optional | Defaults to `10.0` if omitted |

### Response

```json
{
  "status": "success",
  "count": 1,
  "recommendations": [
    {
      "place_id": "osm_way_222",
      "name": "City Care Cafe",
      "category": "Restaurant",
      "distance_km": 1.2,
      "accessibility_score": 0.92,
      "has_wheelchair_ramp": true,
      "has_accessible_restrooms": true,
      "has_braille_menu": false,
      "has_audio_guides": false,
      "latitude": 13.0850,
      "longitude": 80.2720
    }
  ]
}
```

`accessibility_score` is `0.0`–`1.0`, results are sorted by score
(descending) then distance (ascending) — this matches `recommend_places()`'s
actual ranking logic. There is no `"healthcare"` category — the four
listed above are the only valid ones today.

---

## 2. `POST /api/v1/match-caretaker`

**This is the one your teammate's screenshot asked for.** Matches an
available caretaker to a user, with the gender-preference fallback logic.
Backed by `match_caretakers(user, caretakers, max_distance_km)`.

### Request

```json
{
  "user_id": "usr_101",
  "gender": "Female",
  "disability_types": ["visual"],
  "latitude": 13.0827,
  "longitude": 80.2707,
  "max_distance_km": 15.0
}
```

### Response — three possible shapes, not one fixed format

This endpoint's `status` field changes the response shape — your Flutter
teammate needs to branch on it, not assume `caretakers` is always present.

**Case A — same-gender match found (`MATCH_FOUND`):**
```json
{
  "status": "MATCH_FOUND",
  "message": null,
  "matches": [
    { "caretaker_id": "c1", "full_name": "Priya", "gender": "Female", "distance_km": 1.4 }
  ],
  "fallback_recommendations": []
}
```

**Case B — no same-gender caretaker nearby (`GENDER_UNAVAILABLE_FALLBACK`):**
```json
{
  "status": "GENDER_UNAVAILABLE_FALLBACK",
  "message": "No female caretaker available nearby.",
  "matches": [],
  "fallback_recommendations": [
    { "caretaker_id": "c2", "full_name": "Suresh", "gender": "Male", "distance_km": 2.1 }
  ]
}
```

**Case C — nobody eligible at all (`NO_CARETAKER_AVAILABLE`):**
```json
{
  "status": "NO_CARETAKER_AVAILABLE",
  "message": "No available caretakers matching the required capabilities were found nearby.",
  "matches": [],
  "fallback_recommendations": []
}
```

Note: there's no `"score": 0.95` field like the screenshot's simplified
example showed — the real function ranks strictly by distance, not a
composite score. If she specifically wants a 0–1 match score in the
response, that's a small addition we can make to `match_caretakers()` —
just flag it back to me rather than having the API layer invent one that
the underlying function doesn't actually compute.

---

## 3. `POST /api/v1/verify-identity`

Verifies a **caretaker's** ID document (not a regular user's) via the
Sandbox KYC API. Backed by `verify_identity(caretaker_id, id_type,
id_number, caretaker_name, caretaker_dob)`.

### Request

```json
{
  "caretaker_id": "CT001",
  "id_type": "PAN",
  "id_number": "ABCDE1234A",
  "caretaker_name": "John Doe",
  "caretaker_dob": "11/11/2001"
}
```

| Field | Notes |
|---|---|
| `caretaker_id`, not `user_id` | This endpoint is caretaker-only — regular disabled/elderly users never go through this flow |
| `id_type` | One of `"PAN"`, `"DRIVING_LICENSE"`, `"POLICE_CLEARANCE"` — **not** `"aadhaar"`, which isn't implemented |
| `caretaker_name`, `caretaker_dob` | Required for `PAN`/`DRIVING_LICENSE` — the provider checks these match the ID record. Omit only for `POLICE_CLEARANCE` |

### Response

```json
{
  "caretaker_id": "CT001",
  "id_type": "PAN",
  "status": "VERIFIED",
  "verification_id": "3b862714-d27d-4907-9027-e6399f8a8d46",
  "issuer": "Sandbox (sandbox.co.in)",
  "timestamp": "2026-08-14T10:00:00+00:00",
  "detail": null,
  "simulated": false
}
```

`status` is one of: `VERIFIED`, `NOT_FOUND`, `INVALID`, `INVALID_FORMAT`,
`PENDING_MANUAL_REVIEW`, `VERIFICATION_UNAVAILABLE`, `ERROR`. There is no
`"confidence_score"` field anywhere in this module — only `POLICE_CLEARANCE`
returns `PENDING_MANUAL_REVIEW` (queued for manual/BGV-vendor review, not an
automated pass). Your Flutter teammate's UI needs to handle all seven
statuses, not just a true/false `"verified"` flag — collapsing this down to
a boolean loses exactly the fail-closed safety behavior this module was
built around.

---

## What to actually tell her

> "Here's the real API contract, pulled straight from the ML code so the
> field names and statuses match exactly — including the caretaker
> gender-fallback response and the identity-verification statuses, since
> those have more than just success/fail states."
