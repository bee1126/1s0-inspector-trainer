# App Store Submission Checklist

## 1) Project settings (Xcode)
- Bundle ID: `com.abdoulbah.1s0-inspector-trainer` (already configured).
- Versioning: bump `MARKETING_VERSION` (e.g., `1.0.1`) and `CURRENT_PROJECT_VERSION` (build number).
- Deployment target: confirm the minimum iOS version you want to support.
- Devices: the project is configured as **universal** (`TARGETED_DEVICE_FAMILY = 1,2`). App Store submission requires both iPhone and iPad screenshots.

## 2) Required web links (App Store Connect)
App Store Connect requires HTTPS links for:
- **Support URL**
- **Privacy Policy URL** (recommended even if you collect no data; required in some cases)
- **Marketing URL** (optional)

This repo includes a ready-to-host set of pages in `docs/`:
- `docs/index.html` (marketing)
- `docs/support.html` (support)
- `docs/privacy.html` (privacy policy)

Host them (GitHub Pages or any static host) and paste the resulting URLs into App Store Connect and `AppStoreMetadata.md`.

## 3) Privacy / export compliance
- The app stores progress, e-Pubs favorites, and revision metadata **on-device** (UserDefaults) and does not include analytics/ads.
- Live e-Pubs makes user-visible HTTPS requests to official DAF e-Publishing hosts. Keep the hosted privacy policy and App Store privacy answers aligned with this behavior.
- `ITSAppUsesNonExemptEncryption` is set to `false` in `1S0 Inspector Trainer/Resources/Info.plist`.
- A privacy manifest is included at `1S0 Inspector Trainer/Resources/PrivacyInfo.xcprivacy` (no tracking / no collected data declared).

## 4) App Store assets
- App icon: verify it’s final (1024×1024 included in the asset catalog).
- Screenshots: capture required sizes (if universal: iPhone + iPad).
- Optional: add an App Preview video.

## 5) Archive, upload, and submit
1. Select **Any iOS Device (arm64)** (not a simulator).
2. Product → **Archive**.
3. Distribute App → **App Store Connect** → Upload.

API automation is also available:
- One-time setup: `docs/release/AppStoreConnectAPI.md`
- Env template: `scripts/appstore_release.env.example`
- Export options: `scripts/appstore-export-options.plist`
- App Store Connect helper: `scripts/asc_release.py`

## 6) App Review notes (recommended)
Include:
- No account / login required.
- On-device only; no analytics/ads by default.
- “Not an official Air Force product” disclaimer.
- Live e-Pubs path: `Refs → Live DAF e-Pubs`; no login required and all training remains available if the government site is unreachable.
