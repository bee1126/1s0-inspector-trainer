# SafetyXP

Native SwiftUI training for OSHA general industry and Air Force safety inspectors. iOS 17 or later, Apple frameworks only, no account, ads, analytics, or third-party SDKs.

## Version 1.8 (build 7)

- OSHA / Civilian: 15 modules, 150 questions; Air Force (1S0): 19 modules, 190 questions. The bank has 191 unique questions.
- Five new shared modules: Walking-Working Surfaces, PPE Hazard Assessment, Recordkeeping, Emergency Action & Fire Prevention, and Respiratory Protection.
- Five native tabs: Today, Learn, Practice, Library, and Progress. Light/dark appearance, Dynamic Type, and availability-gated Liquid Glass controls on iOS 26+.
- Lessons, decision scenarios, adaptive Daily Five, custom study/exams, bookmarks, spaced review, and retained session history.
- Track switches preserve global progress. Existing 1.7 installations default to Air Force and retain a raw study-state backup.
- Hazard Report & Risk Matrix stores user-authored reports separately in Application Support. Text/PDF exports start only when requested. DAF-specific tools remain AF-only.

## Build and verify

Open `1S0 Inspector Trainer.xcodeproj`; the scheme, target, bundle ID and signing team are unchanged.

```sh
xcodebuild -scheme "1S0 Inspector Trainer" -project "1S0 Inspector Trainer.xcodeproj" -destination "platform=iOS Simulator,name=iPhone 17 Pro" -parallel-testing-enabled NO test
```

Use an available simulator ID if that name is unavailable. If simulator execution is unstable, the compile-only fallback is:

```sh
xcodebuild -scheme "1S0 Inspector Trainer" -project "1S0 Inspector Trainer.xcodeproj" -destination "generic/platform=iOS Simulator" build
```

[Content review and exact paragraph evidence](docs/ContentReview.md) • [1.8 validation](docs/release/SafetyXP18Validation.md) • [Local listing and icon assets](AppStoreAssets/safetyxp)

`AppBrand.name` in `ContentCatalog.swift` is the shared name. For the InspectXP fallback, change that one line, then run `python3 scripts/sync_brand.py` to regenerate static bundle/site/listing outputs. CI can use `--check` to reject stale names.

All content is paraphrased training material. Follow current official requirements and local procedures. Reference links require internet access; the bundled training and local reports work offline. The website in `docs/` and listing in `AppStoreAssets/safetyxp/` are prepared source files, not evidence of deployment or App Store publication.
