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
OpenAPI provides complete typed contracts. Phase 3 chat stays read-only; the separate Phase 4 approval API is below.


## Phase 4 agentic API

All paths below are under `/api/v1` and require verified Supabase identity.

| Operation | Endpoint |
|---|---|
| Availability, consent, heartbeat and limits | GET `/agents/status` |
| Specialist/tool and permission catalog | GET `/agents/catalog` |
| Paginated history / queue a run | GET, POST `/agents/runs` |
| Detail with proposals, sources and timeline | GET `/agents/runs/{id}` |
| Approve selected proposals or reject all | POST `/agents/runs/{id}/decision` |
| Cancel queued/running/unapproved work | POST `/agents/runs/{id}/cancel` |
| Delete terminal run history | DELETE `/agents/runs/{id}` |
| Knowledge list/create | GET, POST `/knowledge` |
| Knowledge detail/edit/delete | GET, PUT, DELETE `/knowledge/{id}` |
| Current memory source | GET `/memories/{id}` |
| Explicit embedding indexing | POST `/retrieval/{kind}/{id}/index` |

Queue input: UUID `request_id`, `prompt` (1–4000 characters), `scopes` selected
from planner/goals/habits/memory/knowledge/insights (default empty), and
`allow_proposals` (default false). Identical retries return the existing run;
conflicting reuse returns 409. The worker processes asynchronously. Poll detail
while queued/running; no business records change during planning.

Decision input: a new UUID `request_id`, `decision: approve|reject`, `action_ids`,
`digest` and `nonce` from the exact detail response. Approve requires at least one
selected action and its dependencies. Reject uses an empty selection. All selected
writes apply atomically or the run becomes stale with none applied. Identical
retries return the saved outcome. Digest/nonce mismatch or stopped runs return 409;
invalid selection returns 422. Approval cannot expand the original scopes.

Knowledge input: title, content (max 30000 characters), `allow_ai` (false by default)
and optional future `expires_at`. PUT replaces editable fields and invalidates its
index. Index kind is memory or knowledge; global AI, per-kind consent, per-source
sharing and a configured embedding provider are all required. Source deletion
cascades its chunks. Expired sources cannot be retrieved.

Detail contains field-by-field proposal previews and dependencies, actual execution
results and attributed retrieval excerpts. Run deletion removes run content,
proposals, decisions and steps, while content-free daily usage counts and applied
life records remain. The Flutter history export copies this owner-only detail.
