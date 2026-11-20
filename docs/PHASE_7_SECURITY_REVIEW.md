# Phase 7 privacy and security review — 20 November 2026

This is a source review and automated test pass, not an independent penetration
test, compliance certification or production release approval. Scope includes the
Flutter client, FastAPI, database roles/RLS, AI approval engine, vault, calendars,
notifications, fixed external adapters and build/test configuration.

## Findings addressed

| Finding | Change and verification |
|---|---|
| Locked packages had known published advisories | Upgraded FastAPI/Starlette, PyJWT, LangGraph/checkpoint/SDK and pytest; regenerated the dependency closure; reran all workflows and advisory checks without exclusions |
| Framework validation could echo private submitted data | Generic 422 response excludes raw input, validator context and nested payloads; private marker regression test |
| Ordinary private responses lacked consistent cache policy | API responses, errors and early 413 responses receive no-store; browser responses receive nosniff/no-referrer and API framing restrictions; repeated headers preserved |
| Invalid tokens could reach signing-key discovery before basic rejection | Bound token/key identifier lengths and reject algorithms outside the static EC/RSA allowlist before JWKS; signature/claim verification remains mandatory |
| Malformed weather response shapes could become unexpected exceptions | Require object responses and a structured current-weather object; invalid values, redirects, timeouts, oversize and provider errors become sanitized 503 responses |
| Mobile configuration accepted inappropriate credential origins/keys | Reject URL credentials/non-origin paths and known server-only Supabase key formats; transport refuses external URL paths and does not follow redirects |
| Repeated dashboard scans increased per-request work | Aggregate counts and weekly activity; 26 statements reduced to 9, with timezone-boundary and query-budget tests |

The original dependency audit reported 45 advisory entries across six packages;
entries included duplicate advisory aliases. This is not a count of 45 distinct
exploitable application vulnerabilities. The patched lockfile reports no known
vulnerabilities at verification time. Dart's 149 hosted package versions also
reported no known advisories. Results can change as databases gain new advisories.

## Reviewed trust boundaries

- **Identity:** server validates EC/RSA signature, issuer, audience, expiry, issue
  time, user UUID and authenticated role. Missing/future/forged/unsupported tokens
  fail closed. Signing-key provider outages are service errors, not login bypasses.
  All private method/path combinations are tested without credentials.
- **Ownership:** verified subject establishes transaction-local owner context.
  All tables with user_id are checked for forced RLS and zero unscoped reads;
  runtime cannot inherit the migration role. Existing cross-owner write/read,
  composite references, pool reset and dispatcher privilege tests remain active.
- **AI:** private-by-default data, current consent and selected scopes restrict
  retrieval. Structured proposals cannot grant their own permissions. Existing
  approval digest/nonce, evidence revision, atomic writes, rejection, replay,
  cancellation and stale worker tests run with the patched LangGraph versions.
- **Vault/OAuth:** file bytes and integration credentials use authenticated
  encryption with owner/domain binding. Metadata remains plaintext in owner-only
  database storage. OAuth state is single-use; tokens never enter API responses.
  Callback queries must also be redacted at the deployment proxy.
- **External effects:** adapters have fixed HTTPS origins and bounded responses;
  pagination host guards prevent token forwarding. Calendar writes require exact
  approval and recheck connection/event state. Unknown outcomes require explicit
  reconciliation. No payments, purchases, attendees or external message tools.
- **Mobile:** secure session/PKCE storage uses the platform secure channel.
  Preferences hold settings/delivery identifiers, not tokens. Native notification
  text is generic; routing is allowlisted and account changes cancel local queues.
  HTTP redirects cannot forward credentials to an arbitrary destination.

## Remaining release gaps

| Priority | Gap and required release evidence |
|---|---|
| High | Configure production TLS/ingress request throttling, trusted proxy/log policy, non-default database secrets, secret/key rotation, monitoring and tested backup/restore. Application quotas/body bounds do not replace distributed ingress protection against authentication/JWKS or slow-body abuse. |
| High | Full-account data export/deletion and identity-provider account removal are not implemented. Memory export/deletion and individual record/history controls do not satisfy complete account lifecycle requirements. Define retention/backup deletion policy before accepting real user data. |
| High | Validate real Supabase sign-up/confirmation/login/refresh/revocation and Google/Microsoft consent/sync/export using registered clients; current cryptographic and wire-contract tests use controlled keys/transports. Existing access tokens remain valid until expiry unless the identity provider rejects them; the API does not perform a remote session-revocation lookup on each request. |
| Medium | Verify secure storage, sign-out/account-switch cleanup, local notifications/reboot behavior and release networking on physical Android/iOS devices. iOS build and device tests require macOS/hardware; remote push is unconfigured. |
| Medium | Obtain an independent penetration test and production-like sustained-load/soak tests. Current in-process benchmark does not measure model latency, internet/TLS, availability, native SDK vulnerabilities or fleet capacity. |
| Medium | Add operational key custody/rotation drills and vault malware scanning if uploads will be consumed externally. Server-side encryption is not end-to-end encryption; DB administrators can access metadata and configured server keys. |

No live service configuration, deployment, user-data deletion or external calendar
write was performed during this review. Source limitations above remain explicit
release work; passing tests does not remove them.

References: [OWASP REST guidance](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html),
[PyJWT API](https://pyjwt.readthedocs.io/en/stable/api.html),
[pip-audit](https://github.com/pypa/pip-audit), and [OSV API](https://google.github.io/osv.dev/api/).
