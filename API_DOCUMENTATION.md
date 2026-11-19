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


## Phase 5 advanced modules

These endpoints remain under `/api/v1`, require verified identity, and use owner
RLS. The module catalog publishes each record's strict Pydantic JSON schema; the
Flutter editor derives structured controls from these schemas. Unsupported fields,
invalid decimals/dates and wrong parent kinds are rejected.

| Operation | Endpoint |
|---|---|
| Module kinds and validated input schemas | GET `/modules/catalog` |
| Actual-record overview, optional `month=YYYY-MM-DD` | GET `/modules/{module}/overview` |
| Paginated records, filters `kind`, `parent_id`, `q` | GET `/modules/{module}/records` |
| Create a typed record | POST `/modules/records/{kind}` |
| Get / replace / delete record | GET, PUT, DELETE `/modules/record/{id}` |
| Explicitly create a linked Planner task | POST `/modules/record/{id}/planner` |
| Manual-rate conversion | POST `/finance/convert` |
| Practice question / submit quiz answer | GET, POST `/learning/practice/{id}` |
| Factual resume text and literal keyword review | GET `/career/resume/{id}` |
| Deterministic scenario calculation | GET `/future/scenarios/{id}` |
| Connected source graph, optional `q` | GET `/knowledge-universe/graph` |
| Create/update relationship / delete it | POST `/knowledge-universe/links`, DELETE `/knowledge-universe/links/{id}` |
| Attributed retrieval over shared content | POST `/knowledge-universe/search` |
| Vault configuration/quota | GET `/vault/status` |
| List / upload encrypted files | GET, POST `/vault/files` |
| File metadata / edit metadata / delete | GET, PUT, DELETE `/vault/files/{id}` |
| Authenticated, integrity-checked download | GET `/vault/files/{id}/download` |

Modules: finance, learning, career, wellness, travel and future. Knowledge Universe
reuses Phase 4 knowledge sources/retrieval. Vault has its own encrypted file API.
Record kinds are listed in `/modules/catalog` (16 types). Input envelope:
`request_id` UUID, `data` matching the kind schema, optional `parent_id`, and
`allow_ai` false by default. PUT also requires the previous `revision`; an already
applied identical replacement is retry-safe, while a different stale edit returns
409. Creates use request identifiers to prevent retry duplicates. Parent validation
and account limits are serialized; records are capped at 5000/account. A trip
owns itinerary/packing children; an optional course owns study material. Deletion
cascades children. Existing Planner tasks remain.

Planner task creation accepts a UUID `request_id` and optional aware `due_at`.
Retries return the same task; it does not activate a notification or recurrence.
Quiz POST input is `answer: A|B|C|D`; output is actual correctness/score/explanation.
Practice GET omits the answer key. Resume review compares supplied text literally;
it is not an ATS percentage or job verification. Conversion uses the user's positive
`rate` and `rate_date`, never an unstated live rate. Scenario outputs describe the
user's assumptions and calculation method, with no guaranteed outcomes.

Vault uploads use metadata plus `request_id`, `filename` and `content_base64`.
Maximum decoded file 5 MiB, total storage 100 MiB/account; request buffers are
bounded at 8 MiB for upload and 1 MiB elsewhere, including chunked requests. PDF,
PNG, JPEG and UTF-8 TXT require matching signatures/text. Files use server-side
AES-256-GCM, random nonces and owner/file-bound associated data. Downloads verify
authentication tag, size and SHA-256, return base64, and set `Cache-Control: no-store`.
File bytes never enter agent context. Metadata sharing is independently opt-in.
Expired files are unavailable immediately and removed on access/daily maintenance.

Knowledge links require two different owned, active sources. Graph returns at
most 100 matching nodes and 300 edges among them; totals/limits are explicit.
Changing a knowledge connection invalidates the affected source revisions/indexes,
so graph-based approvals cannot silently use an old relationship. The Knowledge
specialist can read up to ten shared graph nodes and fifty links among them.
Search accepts `query` and `semantic` (default false) and requires AI/knowledge
consent plus source sharing. Semantic mode calls the configured embedding provider.
