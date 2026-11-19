# SafetyFluent (repo and Xcode project: 1S0 Inspector Trainer) — Agent Instructions

## Project
Native SwiftUI iOS app for workplace safety training. The public name is **SafetyFluent** (App Store name: "SafetyFluent: Workplace Safety"). It was called 1S0 Inspector Trainer through version 1.7 and was renamed in version 1.8.

Two training tracks, chosen by the user and switchable without losing progress:
- OSHA / Civilian: 15 modules, 150 questions (29 CFR 1910 and 1904).
- Air Force (1S0): 19 modules, 190 questions (OSHA topics plus DAF programs and tools).
- 191 unique question IDs in total.

Features: lessons, decision scenarios, quizzes, adaptive Daily Five, custom study and exams, bookmarks, spaced review, daily lessons, field tools, glossary/references, and local hazard reports. Duolingo-style XP, levels, and streaks. No account, ads, analytics, or third-party SDKs.

## Current version
- Repo: version 1.8, build 7 (`MARKETING_VERSION` / `CURRENT_PROJECT_VERSION`). `main` and `safetyxp-1.8` both point at commit `1ef9490`.
- App Store: 1.8 released 2026-10-12 as "SafetyFluent: Workplace Safety" (checked against Apple's public listing on 2026-11-20). The shipped build number is not recorded in this repo.
- Files in this repo are not proof of App Store state. Check the live listing or App Store Connect before reporting release status.
- Update this section when the version changes.

## Names that did not change
The rebrand changed what users see, not the project plumbing. Do not rename these:
- Folder, Xcode project, scheme, app target, unit-test target: `1S0 Inspector Trainer` / `1S0 Inspector TrainerTests`.
- Bundle ID `com.abdoulbah.1s0-inspector-trainer`, App Store app ID `6758813561`, signing team `MM76BGJBJR`.
- GitHub repo `bee1126/1s0-inspector-trainer`, and the existing Support and Privacy URLs.

"SafetyXP" was an interim name. It survives only in the branch name `safetyxp-1.8` and the UI-test bundle ID. Do not use it in user-facing text.

## Tech Stack
- Swift, SwiftUI, iOS 17.0+. iOS 26 Liquid Glass controls are availability-gated.
- State: `ProgressStore.swift` (ObservableObject → UserDefaults). Hazard reports: separate JSON file in Application Support.
- No packages, no CocoaPods, no SPM deps. Apple frameworks only.

## Key Files
- `ContentCatalog.swift` — `AppBrand` (name, store name, tagline, disclaimer), `Track` (`osha`, `airForce`), and `ContentCatalog`, the only place that decides what a track can see. Source banks and stored progress are never pruned.
- `OSHAExpansion.swift` — The five shared modules added in 1.8 (`wws`, `ppeha`, `rk`, `eap`, `resp`) and the civilian hot-work question.
- `QuestionExplanations.swift` — Per-question explanations and `retiredQuestionIDs`. Retired IDs stay retired.
- `StudyModels.swift` / `StudyViews.swift` — Custom study and exam sessions, question pools, bookmarks, session history.
- `TrackViews.swift` — Track picker, track settings, OSHA standards list, in-app Safari reference view.
- `TrainingHubViews.swift` — `LearnView` and `PracticeHubView` (Learn and Practice tabs).
- `LocalHazardReport.swift` / `LocalHazardReportView.swift` — User-written Hazard Report & Risk Matrix, stored in Application Support, not UserDefaults.
- `EpubsCatalog.swift` / `EpubsLibraryView.swift` — Air Force-only Live e-Pubs. The only place the app makes its own network requests.
- `ScreenshotScene.swift` — Debug-only screens for store screenshots and QA. Excluded from Release builds.
- `AccessibilityCopy.swift` — Shared accessibility label text.
- `ProgressStore.swift` — All state: XP, level, streak, scores, Daily Five, and practice tracking. The backbone. `save()` persists everything.
- `AppTheme.swift` — Colors, spacing, fonts. All UI references these.
- `TrainingModels.swift` — Structs: TrainingModule, QuizQuestion, Scenario, QuizChoice, etc.
- `TrainingContent.swift` — Source module definitions; each module carries the `tracks` it belongs to. Views should read modules/questions through `ContentCatalog`, not directly from here.
- `QuizBank.swift` — Core question bank. IDs like "loto-q1", "fall-q3". `QuizBank.oshaTextOverrides` holds civilian wording for shared questions.
- `TrainingRole.swift` — Legacy role model (only `oneS0`). The user-facing choice is now `Track` in `ContentCatalog.swift`.
- `AdaptiveDifficultyManager.swift` — Tracks quiz difficulty promotion and reset behavior.
- `PracticeContent.swift` — 7-day onboarding path and Daily Five entry points.
- `DailyLessonBank.swift` / `DailyLessonView.swift` — Daily lesson content and UI.
- `QuizFlowView.swift` — Quiz engine. Takes `[QuizQuestion]`, handles selection, scoring, streaks.
- `PracticeSessionView.swift` — Adaptive Mission / Daily Five flow. Builds a targeted 5-question remediation run from missed questions, review-due cards, and weak modules.
- `HomeView.swift` — Today tab.
- `ProgressDashboardView.swift` — Stats: XP, level, streaks, module completion.
- `RootView.swift` — Tab shell (Today, Learn, Practice, Library, Progress), navigation stacks, deep-link routing.
- `SourcesView.swift` — References entry point.
- `GlossaryContent.swift` / `GlossaryView.swift` — Verified field terms, module links, source citations.
- `PPELoadoutData.swift` / `PPELoadoutView.swift` — PPE decision tool and scenario completion.
- `HazardReportData.swift` / `HazardReportView.swift` — DAF Form 457 and RAC processing tool.
- `DeployedORMData.swift` / `DeployedORMView.swift` — Deployed ORM workflow scenarios.
- `CodeLookupContent.swift` / `CodeLookupView.swift` — Regulation/code lookup practice tool.
- `ToolsView.swift` — Feedback forms and inspector profile.
- `Components.swift` — Reusable: GlassCard, OptionRow, PrimaryButtonStyle, etc.
- `BackgroundView.swift` — ZStack background for all views.
- `InspectorTrainerApp.swift` — @main entry point.

## Release and brand files
- `README.md` — Current version summary and build commands.
- `docs/release/SafetyFluent18Validation.md` and `docs/release/SafetyFluent18Rebrand.md` — 1.8 validation records and open release checks.
- `docs/ContentReview.md` — Paragraph-level content review for the 1.8 questions.
- `AppStoreAssets/safetyfluent/` — Current icon, screenshots, and listing copy (`listing_1.8_safetyfluent_FINAL.md`).
- `docs/` — Website source (index, support, privacy).
- `scripts/sync_brand.py`, `scripts/asc_release.py`, `scripts/prepare_store_screenshots.py`, `scripts/render_brand_icon.swift`, `scripts/check_core.py`.
- Superseded, keep for history only: `AppStoreMetadata.md` and `AppStoreSubmissionChecklist.md` (version 1.6 era, old name, 14 modules), the loose `AppStoreAssets/Screenshot_*.png` files (1.7), `1S0_Inspector_Trainer_Roadmap.xlsx`, and `1S0 Inspector Trainer Showcase.pptx`. Do not copy listing text or counts from them.

## Design System
The 1.8 redesign replaced the fixed dark "tactical" theme with an adaptive one. Use the tokens, not raw colors:
- `AppTheme.bg` / `AppTheme.surface` / `AppTheme.border` — system grouped background, card surface, separator. They follow light and dark appearance.
- `AppTheme.primary` — green. `AppTheme.accent` — gold/XP. Both have separate light and dark values.
- `AppTheme.danger`, `AppTheme.info`, `AppTheme.text` (primary label), `AppTheme.muted` (secondary label).
- Spacing: `AppSpacing` (`screenPadding`, `section`, `stack`, `item`, `compact`, `cardPadding`, `minTapTarget`).
- Fonts: `AppFont.title()`, `.subtitle()`, `.body()`, `.mono()`. They scale with Dynamic Type.
- Containers: wrap in `GlassCard { }`. Background: `BackgroundView()`.

## Constants
- levelStep = 120 XP per level
- dailyGoal default = 20 XP
- OSHA / Civilian: 15 modules, 150 questions. Air Force (1S0): 19 modules, 190 questions. 191 unique question IDs. If these change, update the README, listing, website, and tests together.

## Safety Content Rules
- Safety answers must be situational, not automatically maximum-risk. Distinguish routine, elevated, and emergency conditions.
- Avoid one-size-fits-all PPE or hazard conclusions. Make the decision logic explicit when context changes the right answer.
- Keep content paraphrased and aligned with official OSHA, DAFI, DAFMAN, and Air Force safety references. Do not paste long source text.
- External reference URLs must use HTTPS. If source expectations change, update the related integrity tests.
- Preserve the app's training purpose. It can guide inspection practice, but it must not imply it replaces current official publications, local procedures, supervisor direction, or qualified safety judgment.

## Rules
- Never add external dependencies.
- Training progress persists through ProgressStore → UserDefaults. User-written hazard reports persist through `LocalHazardReport.swift` → Application Support (`hazard_reports_v1.json`). Do not add other stores.
- All new views use BackgroundView + GlassCard pattern.
- Keep ProgressStore.save() private — add public methods for mutations.
- For date-sensitive state, use ProgressStore's injected `calendar` and `dateProvider` so streak and reset behavior stays testable.
- In tests, use isolated UserDefaults suites; never rely on `.standard` for persisted state assertions.
- When adding Swift files, verify they are included in the Xcode target. A file that exists on disk but is missing from the target can still break app builds.
- Run `xcodebuild -scheme "1S0 Inspector Trainer" -project "1S0 Inspector Trainer.xcodeproj" -destination "platform=iOS Simulator,name=iPhone 17 Pro" -parallel-testing-enabled NO test` to verify after changes.
- If simulator test execution is unstable, run `xcodebuild -scheme "1S0 Inspector Trainer" -project "1S0 Inspector Trainer.xcodeproj" -destination "generic/platform=iOS Simulator" build` as a fallback compile check.
- User-facing brand text comes from `AppBrand`; never hard-code the app name. After any name, tagline, disclaimer, listing, or website edit, run `python3 scripts/sync_brand.py --check`.
- Track visibility goes through `ContentCatalog.visible(for:)`. OSHA / Civilian content must not show Air Force-specific text (see `ContentCatalog.bannedPattern`); DAF tools stay Air Force-only (`showsDAFTools`).
- New UI must work in light and dark appearance and with Dynamic Type. iOS 26 glass controls must be availability-gated with an iOS 17 fallback.

## Testing Guidance
- Content/module/reference edits: run `TrainingContentIntegrityTests` and `ContentIntegrityTests` (in `TrackTests.swift`).
- Track, catalog, or migration edits: run the `TrackTests.swift` classes. Brand edits: run `BrandingTests` and `python3 scripts/sync_brand.py --check`. Hazard report edits: run `HazardReportTests`.
- UI tests live in the `SafetyFluentUITests` target (`TrackUITests`).
- Progress, XP, streak, Daily Five, onboarding, or persistence edits: run `ProgressStoreTests`.
- Adaptive quiz difficulty edits: run `AdaptiveDifficultyManagerTests`.
- New UI or navigation edits: run the full simulator test command when possible; otherwise run the generic simulator build fallback.
- Documentation-only edits do not require Xcode verification.
