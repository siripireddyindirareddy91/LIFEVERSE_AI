# Phase 3 AI Assistant

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
