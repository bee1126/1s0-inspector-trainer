# SafetyFluent 1.8 rebrand validation — October 10, 2026

Scope: branch `safetyxp-1.8`, following the final SafetyFluent board decision and rebrand addendum. Bundle `com.abdoulbah.1s0-inspector-trainer`, App Store app `6758813561`, version 1.8/build 7, repository and app scheme are unchanged. No merge, App Store version creation, metadata upload, submission, or website deployment was performed.

## Brand and icon

Shared `AppBrand.shortName` is SafetyFluent. Display name, track onboarding, About, disclaimer, feedback subjects, sharing, QA labels and website use the final brand. The tagline is “Safety training put into practice.” The system-generated launch screen contains no inspection/enforcement copy. Inspection subject matter remains unchanged.

`AppStoreAssets/safetyfluent/AppIcon.icon` contains three vector layers: shield, checkmark, and small accent. Xcode compiles light, dark and tintable IconGroup renditions with lighting effects; the compiled Release asset inventory is committed under `docs/review/1.8-rebrand/compiled-assets.json`. The package was authored directly and compiler-validated; Icon Composer's GUI was not used and its first-run license was not accepted. Home-screen visual inspection caught and corrected layer ordering. All artwork is deterministic vector/CoreGraphics work, with no lettering. Flat exports use exact sRGB #00E6A1, #FFB800 and #FF3B5C.

Opaque fallback icons remain in the asset catalog. The standalone 1024×1024 RGB export is `AppStoreAssets/safetyfluent/AppIcon-1024.png`.

## Tests and builds

| Check | Result | Evidence |
|---|---|---|
| Full iPhone 17 Pro Max XCTest suite, iOS 26.5 | 88 passed; zero failed/skipped | `docs/review/1.8-rebrand/iphone-full-suite.json` |
| Full iPad Pro 13-inch (M5) XCTest suite, iOS 26.5, final code `6076022` | 88 passed; zero failed/skipped | `docs/review/1.8-rebrand/ipad-full-suite.json` |
| iPhone 17e home-screen helper, final code | 1 passed | `docs/review/1.8-rebrand/iphone17e-pages.json` |
| Pro Max largest-text home-screen helper | 1 passed | `docs/review/1.8-rebrand/promax-largest.json` |
| Release generic Simulator build, arm64/x86_64 | Passed | `docs/review/1.8-rebrand/release-build.json` |
| Brand/listing/website consistency and limits | Passed | `python3 scripts/sync_brand.py --check` |
| Store image dimensions, opacity, hashes and caption order | Passed | `docs/review/1.8-rebrand/assets-validation.json` |

Full suites include 81 unit tests and seven UI tests. The iPhone full-suite run predates only the revised home-screen capture helper and exact-sRGB flat-export correction; the full iPad suite covers both. Test command: `xcodebuild -scheme "1S0 Inspector Trainer" -project "1S0 Inspector Trainer.xcodeproj" -destination "platform=iOS Simulator,id=<device UUID>" -derivedDataPath <validation2/DerivedData> -resultBundlePath <result.xcresult> -parallel-testing-enabled NO test`.

The initial iPhone 17 Pro run stalled during concurrent simulator startup and was interrupted. A subsequent risk-summary UI assertion overshot its target; bounded short scrolling fixed it. An exact SpringBoard icon query also failed on 17e despite the icon being present; the helper now captures both home pages and labels are judged visually. These failures are retained in local `validation2/` evidence and are not counted as passing runs. The final full suite is green. XXL/dark picker and hazard captures are committed; this does not claim a new manual VoiceOver audit.

## Home-screen labels

Actual screenshots show **SafetyFluent in full**, with no ellipsis, on both iPhone 17e (smallest available iPhone) and iPhone 17 Pro Max at standard and largest accessibility text. Settings were read back and restored. See `AppStoreAssets/safetyfluent/home-screen/README.md`, its manifest and six screenshots. Display Zoom is unavailable in both simulator Settings; physical-device Display Zoom is unverified. The display name was not shortened.

## Store and website handoff

Seven iPhone frames at 1320×2868 and five iPad frames at 2064×2752 are saved under `AppStoreAssets/safetyfluent/screenshots/`. All are RGB/no alpha. iPhone uses Grace's captions 1–7; iPad uses 1, 3, 4, 5, 7. Original XCTest captures and source manifests are retained. Screens show real app UI with isolated demonstration data through Debug-only QA paths. No screenshots were uploaded.

Both FINAL copy files exist in `/Users/bah/Projects/safetyxp-1.8/` and are mirrored in `AppStoreAssets/safetyfluent/`. Counts: OSHA 15 modules/150 questions; Air Force 19/190; 191 unique question IDs, including 50 new module questions plus one civilian alternate. No bracket placeholders remain. Name 30/30 characters; subtitle 29/30; promo 163/170; keywords 95/100 UTF-8 bytes; description 2441/4000; What's New 311/4000.

Branch website copy and icon are updated. Support and Privacy retain their existing paths and include the former app name. Local page/icon/badge requests returned HTTP 200, and the rendered homepage was inspected. Public website deployment and social changes are outside this run.

## Open questions and separate release checks

No blocking rebrand question. Physical-device Display Zoom remains untested because the simulators do not expose it. Earlier release gates—including 1.7 live status, real-data upgrade, applicable content/ethics approval, manual VoiceOver and network-proxy checks—are not cleared by this rebrand pass. See the prior implementation validation. This report does not authorize or perform submission.
