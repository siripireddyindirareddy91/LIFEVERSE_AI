# Foundation API

Interactive OpenAPI: `http://localhost:8000/docs` during local development.

| Method | Path | Authentication | Behavior |
|---|---|---|---|
| GET | `/health/live` | None | Process liveness |
| GET | `/health/ready` | None | 503 until auth is configured and migrated DB reachable |
| GET | `/api/v1/me` | Supabase bearer JWT | Verified UUID identity |
| GET | `/api/v1/profile` | Supabase bearer JWT | Owner profile; 404 until first profile save |

401 means missing/invalid/expired authentication. 503 means missing configuration
or unavailable infrastructure. The mobile app obtains sessions directly through Supabase Auth;
passwords never pass through this API.

## Phase 3 authenticated resources

All routes below are under `/api/v1`, require a verified user bearer JWT, and
enforce owner RLS. Lists use `{items,total,limit,offset}` with `limit` 1–100 and
literal title search `q`. Caller-supplied ownership fields are rejected.

| Resource | Routes |
|---|---|
| Profile | GET, PUT `/profile` (404 before first save) |
| Goals | GET, POST `/goals`; GET, PUT, DELETE `/goals/{id}` |
| Tasks | GET, POST `/tasks`; PUT, DELETE `/tasks/{id}`; PATCH `/tasks/{id}/status` |
| Calendar | GET, POST `/events`; PUT, DELETE `/events/{id}` |
| Habits | GET, POST `/habits`; PUT, DELETE `/habits/{id}` |
| Check-ins | POST `/habits/{id}/checkins` (optional day); DELETE same path undoes today |
| Memories | GET, POST `/memories`; PUT, DELETE `/memories/{id}` |
| Memory export | GET `/memories/export` |
| Erase memories | DELETE `/memories`, body `confirmation: "DELETE ALL MEMORIES"` |
| Intelligence | GET `/dashboard` |
| AI availability | GET `/assistant/status` |
| Conversations | GET `/assistant/conversations`; GET `/assistant/conversations/{id}/messages`; DELETE `/assistant/conversations/{id}` |
| Assistant | POST `/assistant/chat` |

Task filters: `status=todo|done`, `goal_id`. Event filters: `starts_after` and
`ends_before` with UTC offsets. Event writes require title/start/end; overlaps
return 409 until explicit `allow_overlap: true`. PUT replaces editable fields.

Chat requires UUID `request_id`, `message`, optional `conversation_id`, and explicit
`include_memory` / `include_plans` flags (false by default). Responses identify the
conversation, persisted reply, context counts and cached-retry state. 403 means
missing consent; 409 is a conflict/in-progress request; 422 is invalid input; 429
is a successful-request limit; 503 is configuration/provider/infrastructure failure.
OpenAPI provides complete typed contracts. No action execution endpoint exists.
