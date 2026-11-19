# Phase 6 - Automation and integrations

Phase 5 `e2a19b3` is pushed. Backend/mobile checks passed in
[run 44534281026, attempt 2](https://github.com/siripireddyindirareddy91/LIFEVERSE_AI/actions/runs/44534281026).
The first Android attempt failed downloading a Kotlin dependency; it passed on
retry after repository availability recovered. Phase 6 remains local until pushed.

- Visual ordered workflow builder: trigger, condition, report, external read,
  read-only AI, staged task/event actions, mandatory approval, notification, output.
- Validated bounded graphs, explicit activation preview, manual/scheduled/app-event
  triggers, timezone-aware recurrence, pause/cancel/retry, durable queue and leases.
- Reuse existing exact-preview Agent approvals for internal record writes. No
  arbitrary code, expressions, URLs or model-controlled permissions.
- Google/Microsoft calendar OAuth with state/PKCE, encrypted tokens, read-default
  permissions, bounded synchronization, explicit import and approved event export.
- Durable owner-only notification inbox/reminders, opt-in native local delivery,
  account-switch cleanup and clear distinction from unconfigured remote push.
- Fixed-origin weather/reference-rate adapters, user-selected inputs, attribution,
  bounded responses/timeouts and actual failure states.
- Workflow run/step history, outcomes, worker heartbeat and failure notifications.

Read-only external calls and inbox writes require workflow activation consent;
internal record writes require per-run approval. Calendar exports have their own
exact preview and durable idempotent operation. No external messaging/purchases.
Initial workflows are directed sequences with condition gates, not unrestricted
branching/loops. There is no arbitrary HTTP connector. Live OAuth needs registered
clients/server keys; native device/iOS and push deployment remain separate checks.
