# 1S0 Inspector Trainer — Codex Instructions

## Project
Native SwiftUI iOS app for Air Force safety inspector training (AFSC 1S0). Duolingo-style gamification. Dark tactical theme. 14 safety modules with lessons, scenarios, and quizzes. All data on-device via UserDefaults. Zero third-party dependencies.

## Tech Stack
- Swift, SwiftUI, iOS 17.0+
- State: `ProgressStore.swift` (ObservableObject → UserDefaults)
- No packages, no CocoaPods, no SPM deps. Apple frameworks only.

## Key Files
- `ProgressStore.swift` — All state: XP, level, streak, hearts, scores. The backbone. `save()` persists everything.
- `AppTheme.swift` — Colors, spacing, fonts. All UI references these.
- `TrainingModels.swift` — Structs: TrainingModule, QuizQuestion, Scenario, QuizChoice, etc.
- `TrainingContent.swift` — Module definitions + `allQuizQuestions(for:)` returns all 140 questions.
- `QuizBank.swift` — 140 questions (10 per module × 14 modules). IDs like "loto-q1", "fall-q3".
- `QuizFlowView.swift` — Quiz engine. Takes `[QuizQuestion]`, handles selection, scoring, streaks.
- `PracticeSessionView.swift` — Practice/Daily 5. Currently passes `TrainingContent.allQuizQuestions()` to QuizFlowView with `shuffleQuestions: true, maxQuestions: 5`.
- `HomeView.swift` — Main screen: HUD, daily goal ring, practice zone, module grid.
- `ProgressDashboardView.swift` — Stats: XP, level, streaks, module completion.
- `Components.swift` — Reusable: GlassCard, HeartsView, OptionRow, PrimaryButtonStyle, etc.
- `BackgroundView.swift` — ZStack background for all views.
- `InspectorTrainerApp.swift` — @main entry point.

## Design System
All new UI must use these exactly:
- `AppTheme.bg` — dark background (rgb 0.04, 0.055, 0.08)
- `AppTheme.surface` — card surface (rgb 0.08, 0.10, 0.13)
- `AppTheme.primary` — green (rgb 0.0, 0.90, 0.63)
- `AppTheme.accent` — gold/XP (rgb 1.0, 0.72, 0.0)
- `AppTheme.danger` — hearts/red (rgb 1.0, 0.23, 0.36)
- `AppTheme.text` — light text (rgb 0.91, 0.93, 0.95)
- `AppTheme.muted` — secondary text (rgb 0.35, 0.40, 0.47)
- Fonts: `AppFont.title()`, `.subtitle()`, `.body()`, `.mono()`
- Containers: Wrap in `GlassCard { }`. Background: `BackgroundView()`.

## Constants
- levelStep = 120 XP per level
- dailyGoal default = 20 XP
- maxHearts = 5
- 14 modules, 10 questions each = 140 total questions

## Rules
- Never add external dependencies.
- All persistence through ProgressStore → UserDefaults.
- All new views use BackgroundView + GlassCard pattern.
- Keep ProgressStore.save() private — add public methods for mutations.
- Run `swift build` to verify after changes.
