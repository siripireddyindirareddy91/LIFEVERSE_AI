# Foundation security

Phase 7: [review and remaining release gaps](docs/PHASE_7_SECURITY_REVIEW.md),
[verification](docs/PHASE_7_VERIFICATION.md), and [repeatable tests](docs/TESTING.md).

- Never commit `.env`, mobile config overrides, tokens or signing keys.
- Mobile receives only the public Supabase publishable/anon key. Never ship a
  Supabase service-role key, database password or provider secret.
- Auth tokens are stored in platform secure storage. Configure iOS Keychain
  entitlements and test device behavior before release.
- JWT signatures and issuer/audience/expiry are verified; no development bypass.
- Database ownership uses forced RLS and a restricted role. Migration credentials
  must not be exposed to clients or used as the runtime connection.
- Docker credentials are local development defaults only; services bind localhost.
- Production requires TLS, secret management, backups, migration release jobs,
  request throttling at ingress, monitoring and a security review.
- Android cleartext networking is allowed only by the debug manifest for local
  APIs. Release configurations require HTTPS. No sensitive payload logging.

Report vulnerabilities privately to the repository owner. This foundation is not
a production security audit or a claim of compliance.

Phase 3 requires explicit AI-processing consent and independent memory-sharing
permissions. Context-enriched chat turns are not silently reused in later prompts.
Successful AI request counters survive chat deletion and contain no prompt/reply.
Retention maintenance uses a separate operations role; runtime RLS must never be
bypassed. Live Supabase/provider behavior and native iOS flows still require
real-environment verification before release.


Phase 4 specialists receive strict allowlisted tools and selected scopes. There
is no SQL/code/network-browsing tool. Read tools are permission level 1; personal
record writes are level 2 proposals requiring an authenticated exact-preview
approval. External level 3 actions are unavailable; unsupported/restricted level 4
requests have no execution tool. Model prompts and retrieved text cannot grant
permissions or execute proposals. Consent and current evidence/targets are checked
again at approval. New agent-saved memories are private by default.

Prompt injection is addressed through typed tool validation, owner-scoped sessions,
per-agent tool lists and deterministic approval, not reliance on model compliance.
Citation labels must refer to real retrieved source records; this verifies source
identity, not the truth or entailment of every model sentence. Review AI advice.
Personal prompts/excerpts remain in owner-only run history until deletion/expiry;
index removal or consent revocation does not erase earlier history copies.
Provider errors are sanitized, tracing is disabled, and execution logs omit raw
provider bodies and hidden reasoning. A production audit remains outstanding.


Phase 5 adds per-record AI sharing, disabled by default, across advanced modules.
The original per-run scopes and global consent remain required. New specialists
can prepare typed internal records; the existing level-2 preview/digest/nonce and
transactional executor apply them only after approval. Evidence revisions are
checked again. Generated records start private and cannot grant their own consent.
No financial transfer, booking, medical decision or external message tool exists.

Life Vault uses AES-256-GCM with random nonces and owner/file identity as associated
data, forced RLS, bounded uploads/quota, type validation, integrity verification and
no-store downloads. Metadata is private but not encrypted in the database; only
file bytes are encrypted. Agents can receive opted-in metadata, never file bytes.
Key management/rotation/backups belong to trusted server operations. OCR, biometric
unlock, malware scanning and end-to-end encryption are not implemented here.

Monthly finance reports, quiz scores and scenario calculations use actual stored
inputs. Scenario rates/hours are user assumptions. Resume keyword checks are
literal comparisons, not an ATS certification. No job, qualification, price or
medical conclusion is represented as verified external evidence. Production
configuration, physical-device testing and security audit remain outstanding.

## Phase 6 execution boundaries

Workflow activation approves the exact definition and declared permissions.
Deterministic rule actions do not require AI processing consent, but every write
still requires an exact-preview approval through the existing approval engine.
The server-only workflow origin is accepted only with an active linked workflow
run and unchanged definition revision. Clients cannot set this origin. AI steps
remain read-only, queued through LangGraph, and require fresh consent and scoped
source access. Private report output is not automatically supplied to an AI step.

OAuth uses hashed random state, PKCE S256, one-time expiry and encrypted verifier/
refresh credentials. Fixed HTTPS origins, no redirects, response-size/time limits
and Microsoft pagination host/path validation prevent arbitrary connector access.
Tokens and callback query strings are excluded from API responses/access logs.
Local disconnect clears credentials; provider-side grant revocation is separate.

Calendar write approval binds payload, nonce, expiry and connection revision.
Publication locks/rechecks the local event. Google uses a deterministic remote ID
and reconciliation marker; Microsoft uses transactionId. Unknown write outcomes
require explicit reconciliation. Leases and generation fencing prevent a stale
worker from committing a reclaimed job. Notification dismissal erases content,
and generic device previews avoid exposing private reports on the lock screen.

Phase 7 applies no-store to API responses/errors, removes raw validation input
from 422 responses, bounds unsupported tokens before key lookup, hardens mobile
credential destinations and upgrades dependencies with published advisories.
API, signed-token, RLS, approval, provider and concurrency regressions run in CI
with coverage/advisory artifacts. Full account lifecycle, live services, physical
devices and production operations remain release gaps documented in the review.
