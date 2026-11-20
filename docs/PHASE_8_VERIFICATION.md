# Phase 8 preview verification — 20 November 2026

The user clarified that they have no hosting/store accounts, want no paid
services, and want an APK to install and inspect on their phone. This milestone
therefore delivers a free Android interface preview, not a production online
deployment or store submission.

## Phase 7 prerequisite

Commit `cb2f7a54685698ca32866370ba740056825baa78` is pushed on
`codex/phase-7-testing-security`. The full workflow and all three exact-commit
checks completed successfully in [run 44689710162](https://github.com/siripireddyindirareddy91/LIFEVERSE_AI/actions/runs/44689710162):
backend, mobile (including Android build), and dependency-security. This was
verified before Phase 8 began. Earlier phase results remain in their verification
documents; milestone branches have not been merged into main.

## Published Android preview

- [Public GitHub prerelease](https://github.com/siripireddyindirareddy91/LIFEVERSE_AI/releases/tag/android-preview-phase7).
- [Direct APK](https://github.com/siripireddyindirareddy91/LIFEVERSE_AI/releases/download/android-preview-phase7/LIFEVERSE_AI-preview.apk).
- Source: `cb2f7a54685698ca32866370ba740056825baa78`.
- APK: **185,106,899 bytes**, package `com.lifeverse.lifeverse_ai`, version 0.1.0,
  versionCode 1, minSdk 24 (Android 7.0), targetSdk 36.
- Universal native ABIs: ARM64, ARMv7, x86_64.
- `apksigner verify --print-certs` succeeded; this is a debug-signed test APK.
- SHA-256: `05600dbb00189610701cc5eced38659c6cfbb295fd82615acb0b59f95e099fd2`.
- GitHub's uploaded asset digest and size matched the local file before publishing.
- Public anonymous ranged download returned HTTP 206 and the expected APK/ZIP
  header. The release includes checksum and installation guide assets.
- APK package inspection found no packaged environment/configuration files or
  signing keystores. The actual private upload key was not published.

A smaller ARM64 profile APK was also built successfully with the same source and
debug signing certificate: **34,507,824 bytes** (about 33 MB). Its ARM64 AOT code
and Flutter runtime are present. It is offered as an alternative for modern
phones; the universal build remains available for older/32-bit devices. Its
server-side digest matched the local file and an anonymous ranged download was
verified. SHA-256:
`eed195f984b240d0c5e4b8dc8ca414efb991160ac1b2515fc9b145bf86dcddbd`.

The publication was staged as a draft, uploaded and verified, then made a public
prerelease. It uses the existing GitHub repository, with no new paid/cloud/store
account or service created. [Phone installation instructions](PHONE_INSTALL.md)
describe what can be inspected without backend services.

## Repository preparation

Phase 8 documentation records the narrowed scope and pending production work.
The CI workflow now retains its debug APK as an artifact for 14 days after a
successful Android build; this workflow edit is local and has not run remotely.
YAML parsing, repository secret-pattern and whitespace checks passed. No runtime
application code changed in this documentation/artifact step, so the existing
Phase 7 regression/native build evidence applies to the published binary.

## Not yet verified or deployed

No phone was connected to this workspace; installation and interaction on the
user's actual device remain for the user to try. Home Universe, orb/navigation,
Interface Studio and theme controls are available without an account. Sign-in,
saved records, integrations and AI are unconfigured and are not simulated.

Backend hosting, production database/Auth, production Android signing, iOS build,
Google Play/App Store submissions and production monitoring/analytics remain
pending. The [Phase 7 review](PHASE_7_SECURITY_REVIEW.md) still records release
gaps, including full-account lifecycle and live-service/device validation.

Store distribution has separate enrollment requirements; see the official
[Google Play registration](https://support.google.com/googleplay/android-developer/answer/6112435)
and [Apple developer membership](https://developer.apple.com/programs/whats-included/)
pages. None is needed for this GitHub-hosted Android test download. An APK cannot
be installed on iOS.
