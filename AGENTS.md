# 1S0 Inspector Trainer — Codex Instructions

## Project
Native SwiftUI iOS app for Air Force safety inspector training (AFSC 1S0). Duolingo-style gamification. Dark tactical theme. 14 safety modules with lessons, scenarios, quizzes, adaptive practice, daily lessons, field tools, glossary/references, feedback, and release assets. All data on-device via UserDefaults. Zero third-party dependencies.

## Tech Stack
- Swift, SwiftUI, iOS 17.0+
- State: `ProgressStore.swift` (ObservableObject → UserDefaults)
- No packages, no CocoaPods, no SPM deps. Apple frameworks only.

## Key Files
- `ProgressStore.swift` — All state: XP, level, streak, scores, Daily Five, and practice tracking. The backbone. `save()` persists everything.
- `AppTheme.swift` — Colors, spacing, fonts. All UI references these.
- `TrainingModels.swift` — Structs: TrainingModule, QuizQuestion, Scenario, QuizChoice, etc.
- `TrainingContent.swift` — Module definitions + `allQuizQuestions(for:)` returns all 140 questions.
- `QuizBank.swift` — 140 questions (10 per module × 14 modules). IDs like "loto-q1", "fall-q3".
- `TrainingRole.swift` — Role/profile model. Currently focused on 1S0.
- `AdaptiveDifficultyManager.swift` — Tracks quiz difficulty promotion and reset behavior.
- `PracticeContent.swift` — 7-day onboarding path and Daily Five entry points.
- `DailyLessonBank.swift` / `DailyLessonView.swift` — Daily lesson content and UI.
- `QuizFlowView.swift` — Quiz engine. Takes `[QuizQuestion]`, handles selection, scoring, streaks.
- `PracticeSessionView.swift` — Adaptive Mission / Daily Five flow. Builds a targeted 5-question remediation run from missed questions, review-due cards, and weak modules.
- `HomeView.swift` — Main screen: HUD, daily goal ring, practice zone, module grid.
- `ProgressDashboardView.swift` — Stats: XP, level, streaks, module completion.
- `RootView.swift` — Tab shell, navigation stacks, deep-link routing, tab/nav styling.
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

## Design System
All new UI must use these exactly:
- `AppTheme.bg` — dark background (rgb 0.04, 0.055, 0.08)
- `AppTheme.surface` — card surface (rgb 0.08, 0.10, 0.13)
- `AppTheme.primary` — green (rgb 0.0, 0.90, 0.63)
- `AppTheme.accent` — gold/XP (rgb 1.0, 0.72, 0.0)
- `AppTheme.danger` — danger/red (rgb 1.0, 0.23, 0.36)
- `AppTheme.text` — light text (rgb 0.91, 0.93, 0.95)
- `AppTheme.muted` — secondary text (rgb 0.35, 0.40, 0.47)
- Fonts: `AppFont.title()`, `.subtitle()`, `.body()`, `.mono()`
- Containers: Wrap in `GlassCard { }`. Background: `BackgroundView()`.

## Constants
- levelStep = 120 XP per level
- dailyGoal default = 20 XP
- 14 modules, 10 questions each = 140 total questions

## Safety Content Rules
- Safety answers must be situational, not automatically maximum-risk. Distinguish routine, elevated, and emergency conditions.
- Avoid one-size-fits-all PPE or hazard conclusions. Make the decision logic explicit when context changes the right answer.
- Keep content paraphrased and aligned with official OSHA, DAFI, DAFMAN, and Air Force safety references. Do not paste long source text.
- External reference URLs must use HTTPS. If source expectations change, update the related integrity tests.
- Preserve the app's training purpose. It can guide inspection practice, but it must not imply it replaces current official publications, local procedures, supervisor direction, or qualified safety judgment.

## Rules
- Never add external dependencies.
- All persistence through ProgressStore → UserDefaults.
- All new views use BackgroundView + GlassCard pattern.
- Keep ProgressStore.save() private — add public methods for mutations.
- For date-sensitive state, use ProgressStore's injected `calendar` and `dateProvider` so streak and reset behavior stays testable.
- In tests, use isolated UserDefaults suites; never rely on `.standard` for persisted state assertions.
- When adding Swift files, verify they are included in the Xcode target. A file that exists on disk but is missing from the target can still break app builds.
- Run `xcodebuild -scheme "1S0 Inspector Trainer" -project "1S0 Inspector Trainer.xcodeproj" -destination "platform=iOS Simulator,name=iPhone 17 Pro" test` to verify after changes.
- If simulator test execution is unstable, run `xcodebuild -scheme "1S0 Inspector Trainer" -project "1S0 Inspector Trainer.xcodeproj" -destination "generic/platform=iOS Simulator" build` as a fallback compile check.

## Testing Guidance
- Content/module/reference edits: run `TrainingContentIntegrityTests`.
- Progress, XP, streak, Daily Five, onboarding, or persistence edits: run `ProgressStoreTests`.
- Adaptive quiz difficulty edits: run `AdaptiveDifficultyManagerTests`.
- New UI or navigation edits: run the full simulator test command when possible; otherwise run the generic simulator build fallback.
- Documentation-only edits do not require Xcode verification.
