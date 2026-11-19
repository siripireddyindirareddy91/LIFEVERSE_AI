# AI workflows

## Phase 3 Assistant

The implemented LangGraph is a bounded, read-only workflow:
`START → supervisor → assistant → END`. Typed state carries authorized messages,
a provider interface and the reply. The supervisor limits context size/message
count and the graph has a recursion limit of four.

`OpenAIProvider` uses HTTPS Chat Completions, no redirects, bounded timeouts,
at most 1,000 completion tokens, and `store: false`. `AI_MODEL` and `AI_API_KEY`
are server-only environment settings. Missing configuration and provider failures
never produce invented replies. Errors are sanitized. Implicit LangSmith tracing
is explicitly disabled for these personal-data requests.

## Consent and context

AI processing requires profile consent. Per message, the user may independently
include current plans and/or relevant memories. Memory also requires profile
memory consent and each record's `allow_ai` flag. PostgreSQL full-text matching,
owner RLS, expiry filters and a five-memory cap constrain retrieval. This is
keyword retrieval, not a claim of semantic/vector search.

Plan context contains at most ten open task titles/due dates, five active goal
titles/progress values and five active habit titles. No financial, document or
external-service data is accessed. Reference data is treated as data, not
instructions. No execution tools or record-changing actions are available.

Recent ordinary chat turns may be resent. Context-enriched turns are not resent
from history; eligible context is retrieved again for each request. Deleted or
revoked memories therefore cannot be implicitly reused through old chat responses.
Existing visible chat text can be deleted separately by the user.

## Reliability and retention

Per-user transaction locks serialize AI requests. A client UUID makes retries of
a completed request return its stored response without another provider call.
Changing the prompt under that identifier is rejected. Provider failures roll
back chat writes; the app preserves the draft and request ID for retry.

Successful requests are limited over rolling minute/day windows. Separate,
content-free usage records preserve those limits if chats are deleted. Failures
are not counted as successful requests. Configure provider-side spending controls;
an external timeout cannot guarantee the provider did not process a request.

Conversation expiry defaults to seven days (configurable from 1–30). Expired
threads/memories are immediately excluded and purged on active access. Run the
trusted retention job daily for inactive users. No checkpoint store keeps a second
copy of context. Provider retention follows the provider account's policy;
`store: false` is not a promise of zero provider retention.

Test providers exist only in tests. Live provider/Supabase end-to-end success
requires actual credentials and an executed request; neither is assumed.


## Phase 4 supervisor and specialists

The separate agent-run graph routes START -> supervisor -> specialist <-> tools ->
finalize -> END. Supervisor produces a validated ordered plan of 1-3 authorized
specialists. Core specialists are Assistant, Planner, Goals, Habits, Memory,
Knowledge and Insights. Each has a fixed tool list and strict argument schema;
the supervisor cannot extend scopes. Future finance/travel/automation/document
modules from the master reference are outside the current core implementation.

All model calls reserve a persisted counter before leaving a short database
transaction. Tool calls, context size, proposal count, elapsed time and daily
requests are bounded. A durable worker uses an immutable owner from the queue,
owner-scoped database transactions, renewable leases and attempt fencing. Recovery
re-plans only unapproved work while retaining budgets and earlier step metadata.

Read tools fetch actual life records. Memory/knowledge retrieval checks global and
per-kind consent plus each source sharing flag/expiry/revision. Shared text is
chunked locally; explicit indexing calls the real configured embedding provider.
Keyword retrieval works without embeddings. Hybrid retrieval combines full-text
and bounded cosine rankings. Results carry source labels and excerpts. The final
structured summary rejects invented citation IDs. Citation identity validation is
not semantic fact checking. There are no runtime fake vectors/model responses.

Write tools prepare typed proposals only. The user sees proposed fields and
before/after values, chooses a subset, and sends the digest/nonce from that preview.
Dependencies, current consent, evidence revisions and existing-record hashes must
still match. The executor applies all selected writes transactionally, records
actual results, and rejects unselected proposals. Rejection, cancellation, expiry,
worker failure and stale previews do not apply proposals. Repeated decisions do
not repeat writes. No external messaging, bookings, purchases or arbitrary code
is available. Read-only chat and agent history remain distinct and deletable.


## Phase 5 advanced specialists

Finance, Learning, Career, Wellness, Travel, Vault metadata and Future specialists
extend the existing supervisor, giving fourteen specialists total. Per-run scopes
and per-record sharing bound read context (at most eight shared records, trimmed
text). Finance advice is educational, wellness does not diagnose, career support
uses supplied qualifications, and scenarios clearly state assumptions. The Vault
specialist can read only opted-in metadata, never decrypt or inspect file bytes.

Typed proposal tools prepare private transactions (internal ledger entries only),
courses, study notes, flashcards, quizzes, resumes, routines, trips and scenarios.
Approval previews show all fields and private sharing. Application-level validation,
record limits and the existing atomic executor apply them; no external transaction
or booking is supported. Shared module evidence carries revisions in attributed
sources, so changed/unshared records block old approvals. Manual CRUD/reporting
works without models. Knowledge Universe reuses authorized chunked RAG and adds
user-managed graph edges; graph links alone do not authorize AI sharing.

The Knowledge specialist also reads at most ten shared graph nodes and fifty
connections among them. Connection changes invalidate affected source revisions
and retrieval indexes so pending graph-based proposals become stale. Source
registry limits fail closed instead of returning untracked evidence.

## Phase 6 workflows

The visual builder produces a validated sequence rather than executable code.
Read-only AI nodes queue real existing LangGraph runs with proposals disabled;
completion is consumed only after consent is rechecked. The automation worker
waits between steps and does not simulate model results. It does not interpolate
model output into an action payload or send previous private reports to a model.

Structured task/event nodes stage deterministic proposals with a server-controlled
workflow origin. The existing digest/nonce approval engine performs the actual
write atomically, then the workflow resumes downstream notification/output steps.
Rule-only workflows work without AI consent. Their linked workflow, active state
and definition revision are still verified before approval. Pause/edit cancels
unfinished runs and their pending proposals. Workflow history links to AI and
approval histories for inspection.
