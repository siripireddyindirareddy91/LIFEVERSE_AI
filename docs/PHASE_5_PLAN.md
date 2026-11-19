# Phase 5 - Advanced modules

Phase 4 `716233f` is pushed and both jobs passed in
[Actions run 44528208732](https://github.com/siripireddyindirareddy91/LIFEVERSE_AI/actions/runs/44528208732).
The user's eight-module phase takes precedence over the reference document's
different milestone numbering. Phase 5 remains local until a push is requested.

Implement connected, owner-isolated modules with typed validated records:

- Finance: manual income/expenses, currency-separated monthly totals/category
  budgets, savings goals, bills/subscriptions and user-entered conversion rates.
- Learning: course/unit progress, study notes, flashcards, authored quizzes with
  actual scoring, study scheduling and a scoped AI tutor.
- Career: application pipeline/follow-ups, factual resume/profile builder/export,
  job-description keyword feedback and a scoped career assistant.
- Wellness: sleep/water/activity/mood logs, journaling, routines and existing habits.
- Life Vault: authenticated encrypted document upload/download, categories,
  expiry, integrity checks, quotas and explicit metadata-only AI sharing.
- Travel: trip budgets, itinerary/booking notes, packing checks and planner links.
- Knowledge Universe: existing source management/RAG, owner-safe concept links,
  searchable connected graph and attributed AI questions.
- Future Studio: saved assumption-based savings/learning/time/career scenarios,
  deterministic projections and side-by-side comparisons.

Shared persistence uses strictly validated domain payloads, optimistic revisions,
owner RLS, verified parent links and content-free retry identifiers. All forms
are structured controls, never raw JSON editors. Existing planner/habits/goals,
knowledge sources and agent infrastructure are reused. AI sees only individually
shared records within scopes chosen per run. Advanced specialists read explicitly shared records and prepare typed private
records through the existing exact-preview approval engine.

No live banking, health sync, job scraping, booking, OCR or exchange-rate feed is
pretended. User-authored facts, manual conversions and scenario assumptions are
labeled. Vault encryption is server-side authenticated encryption, not end-to-end.
Real provider/auth configuration and native iOS checks remain external prerequisites.

Verify CRUD/validation, RLS/parent links, concurrency/idempotency, decimal arithmetic,
quiz scoring, projections, encrypted bytes/tampering/expiry/quotas, knowledge links,
AI sharing filters, Flutter flows/accessibility, real-font previews and Android build.
