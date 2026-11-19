# PostgreSQL foundation

Alembic revision `0001` creates `profiles`: a Supabase user UUID primary key,
display name, locale, timezone and creation timestamp. The external Supabase
identity is authoritative; there is no duplicated password/user credential store.
When using standalone PostgreSQL, a cross-service FK to Supabase `auth.users`
cannot be created. Future account lifecycle work must reconcile deleted identities.

Forced row-level security requires `user_id` to equal transaction-local
`app.user_id`. FastAPI sets it only from a cryptographically verified JWT. Runtime
connections must be non-owner, non-superuser and `NOBYPASSRLS`. Never use the
migration connection for requests.

Local Docker initialization provisions `lifeverse_app`. For existing/hosted
databases, provision that role yourself and grant schema usage and table DML,
including default privileges for the migration owner. Do not grant this backend
role to clients. The table is backend-only: do not expose it through Supabase's
Data API; it intentionally does not use client-controlled JWT settings.

Run from `backend/`: `alembic upgrade head`. Downgrade is destructive:
`alembic downgrade base` removes profiles. Back up real data first.
Database tests require a disposable migrated database and `TEST_DATABASE_URL`
pointing to the restricted runtime role; they roll back their rows.

## Phase 3 — revision 0002

Adds goals, tasks, calendar events, daily habits/check-ins, memories, conversations,
messages, consent events and content-free AI usage records. Every table has UUID
ownership, an owner index and forced RLS. Composite owner FKs prevent linking to
another user's goal, habit or conversation. Deleting a goal unlinks owned tasks;
deleting a habit/conversation cascades to its child records.

Profile AI/memory consent and per-memory sharing default to false. Consent changes
create audit records. Expiry excludes data immediately; active access and a trusted
operations job physically delete it. Separate AI usage counters contain no prompt
or reply, so deleting chats does not reset successful-request limits.

Goal progress is user-reported. Task completion timestamps and daily check-ins
drive actual dashboard counts. No sample analytics are seeded. Migration rollback
checks must use disposable data because downgrade removes core life tables.


## Phase 4 — revision 0003

Adds owner-isolated agent runs/actions/steps/decisions/usage/jobs, knowledge sources
and retrieval chunks. Composite owner/run and owner/source foreign keys prevent
cross-account associations; forced RLS applies to every content table. Profile
knowledge consent defaults false and is audited. Source revisions invalidate
cached chunks and approval evidence on edits. Memory deletion cascades chunks.

The dispatcher role can select queue metadata and update only status, lease,
attempt count and update time. It cannot change queue ownership, create jobs or
read life records. A metadata-only heartbeat table is writable by dispatcher and
readable by runtime. No backend role or database is exposed directly to mobile.

Embeddings use PostgreSQL double arrays with a validated dimension/model and a
strict cosine SQL function. Retrieval ranks English full-text and bounded exact
cosine candidates (default newest 1000), combines them by reciprocal rank and
returns at most five deduplicated sources. This is not an ANN/vector-extension
index; use a purpose-built index before large-scale deployment. Unconfigured or
failed semantic retrieval is explicitly reported as keyword retrieval.

Queue leases use row locks/SKIP LOCKED. Attempt fencing discards stale-worker
results; model counters persist before external calls. Proposals have a canonical
SHA-256 digest and fresh nonce. Approval locks run, consent, evidence and targets,
checks freshness, then executes selected actions in one savepoint/transaction.
Decisions are idempotent; usage counters survive history deletion for rate limits.
Run/history retention is 30 days by default, enforced by the trusted daily job.
Migration downgrade destroys Phase 4 data; use disposable databases for testing.


## Phase 5 - revision 0004

`module_records` stores sixteen strictly validated domain payloads as JSONB, with
indexed kind/owner/parent, optimistic revision UUID and create request identifiers.
Composite owner/parent foreign keys prevent cross-account links and cascade owned
course/trip child records. API validation permits only a course or trip parent for
its known child kinds. `module_operations` keeps content-free Planner retry IDs,
input hashes and resulting task IDs; deleting records does not duplicate tasks.

`vault_files` stores encrypted bytes, key ID, owner-bound file identity and private
metadata. Ciphertext is deferred in ORM queries, so listing/AI metadata queries do
not load document bytes. `knowledge_links` uses composite owner/source FKs and
cascade deletion. Every new table has forced owner RLS and an owner index; the
queue dispatcher has no grants on any of these tables. Migration credentials own
tables; runtime remains restricted. No direct mobile database access is introduced.

Finance values are validated fixed-scale Decimals, serialized as decimal strings.
Reports use Decimal arithmetic and keep currencies separate. Monthly reports use
the user's profile date; transaction dates are explicitly user-entered dates.
AI context fetches at most eight explicitly shared records. Revision/source checks
prevent approval based on edited, deleted or unshared evidence. Approved generated
records start private. Daily retention now also removes expired encrypted files.
Rollback of `0004` destroys Phase 5 records/files/links; test only on disposable data.
