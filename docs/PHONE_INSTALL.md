# Try LIFEVERSE AI on your Android phone

[Download the smaller test APK for modern ARM64 phones (~33 MB)](https://github.com/siripireddyindirareddy91/LIFEVERSE_AI/releases/download/android-preview-phase7/LIFEVERSE_AI-preview-arm64.apk).
For older/32-bit phones, or if unsure, use the
[universal APK (~185 MB)](https://github.com/siripireddyindirareddy91/LIFEVERSE_AI/releases/download/android-preview-phase7/LIFEVERSE_AI-preview.apk).
Both are on the [preview release page](https://github.com/siripireddyindirareddy91/LIFEVERSE_AI/releases/tag/android-preview-phase7).

1. Open the appropriate download link on your Android phone.
2. Open the downloaded `.apk` from Downloads.
3. If Android asks, allow your browser/file manager to install apps, then tap
   **Install**. You can turn that permission off after installation.
4. Open **LIFEVERSE AI**. Try Home Universe, the animated orb, Explore, Interface
   Studio, Settings, and light/dark themes.

Requires **Android 7.0 or newer**. The universal APK supports ARM64, ARMv7 and
x86_64. An APK cannot be installed on an iPhone. This test build uses an Android
debug signing certificate and is not a production store release. The smaller
download uses an ARM64 profile build; the larger download is a universal debug
build. If the smaller build is incompatible with your phone, use the universal one.

No new account or paid service is needed to inspect the interface. Account
sign-in, saved life records, calendar connections and real AI need configured
backend/Supabase/provider services. They remain unavailable in this preview;
there is no fake sign-in or fake AI. Do not enter sensitive data for this test.

If Android says an installed version has an incompatible signature, it may have
been signed with another key. Uninstalling the older app erases its local data;
only do that if you intend to discard it. Keep Play Protect enabled. If Android
reports a security warning beyond the ordinary install permission, stop and
review the warning rather than bypassing it.

Source commit: `cb2f7a54685698ca32866370ba740056825baa78`.
All three [Phase 7 checks passed](https://github.com/siripireddyindirareddy91/LIFEVERSE_AI/actions/runs/44689710162).
The release includes `SHA256SUMS.txt` and an installation guide.

Universal APK SHA-256:
`05600dbb00189610701cc5eced38659c6cfbb295fd82615acb0b59f95e099fd2`.

ARM64 APK SHA-256:
`eed195f984b240d0c5e4b8dc8ca414efb991160ac1b2515fc9b145bf86dcddbd`.
