# Phase 4 — agentic AI

Prerequisite complete: Phase 3 is pushed at `100a7a1` and its exact-commit
[Actions run](https://github.com/siripireddyindirareddy91/LIFEVERSE_AI/actions/runs/44518890895)
passed both jobs. Earlier Phase 1/2 milestone runs are also green.

## Authorized implementation

- Bounded LangGraph supervisor and specialist agents for the existing core domains.
- Strict, allowlisted tool calling. Read scopes are selected per run. Business
  writes become proposals; no arbitrary SQL/code, external messages or purchases.
- Durable PostgreSQL queue, limited dispatcher credentials, worker heartbeat,
  cancellation, leases/recovery and model/tool/time budgets.
- Memory/knowledge RAG: local chunking, explicit source sharing, keyword retrieval,
  optional real embeddings, bounded cosine/hybrid ranking and attributed sources.
- Exact-preview approval with digest/nonce, target/source freshness, dependency
  checks, transactional execution, idempotent decisions and rejected/expired states.
- Owner-isolated execution history, retention, deletion and export.
- Flutter Agent Center, run creation/detail/review/history, knowledge source
  management, privacy controls and connection to existing life modules.

## Architecture boundaries

Run creation queues work only after AI consent and provider configuration. A
separate worker plans through scoped tools. It never applies proposals. An
authenticated user decision triggers deterministic transactional execution.
Worker dispatch can access queue metadata only, not life-record content. Runtime
sessions set owner context from immutable, authenticated queue ownership.

RAG uses PostgreSQL float arrays and bounded exact cosine scoring for portability;
it is not an ANN/pgvector index. Without an embedding model, retrieval is clearly
labeled keyword mode. No pretend vectors or model responses run in production.
Knowledge sources are user-entered text; URL crawling/file ingestion is outside
this phase. Future finance/learning/travel agents are not presented as operational.

## Verification

Test real PostgreSQL RLS/dispatcher permissions, queue leases and cancellation,
tool/schema/scope denial, absence of writes before approval, selected-action
dependencies, duplicate decisions, stale previews, atomic rollback, consent/source
revocation, RAG indexing/retrieval/expiry, provider failures and budget exhaustion.
Run generated-model, Flutter interaction/accessibility tests, real-font visual
review and Android debug compilation. Live providers still need credentials;
iOS signing/native builds require macOS/Xcode.
