# 1S0 Inspector Trainer

This repository contains the SwiftUI source and Xcode project for a native iOS training app tailored to Air Force safety inspectors.

## Quick Start (Xcode)
1. Open `1S0 Inspector Trainer.xcodeproj` in Xcode.
2. Select the `1S0 Inspector Trainer` target and set your team and bundle identifier.
3. Run on an iOS simulator or device.

## Verification
- Preferred test command:
  `xcodebuild -scheme "1S0 Inspector Trainer" -project "1S0 Inspector Trainer.xcodeproj" -destination "platform=iOS Simulator,name=iPhone 17 Pro" test`
- Fallback compile command when simulator execution is unstable:
  `xcodebuild -scheme "1S0 Inspector Trainer" -project "1S0 Inspector Trainer.xcodeproj" -destination "generic/platform=iOS Simulator" build`

## What is Included
- Interactive modules for Lockout/Tagout, Fall Protection, Risk Management, Roles & Responsibilities, Hazard Abatement, and RAC System
- Additional modules for Confined Space, Hot Work, Hearing Conservation, Mishap Reporting, Investigation Basics, JHA Fundamentals, Safety Briefing, and PPE Decision
- Scenario-driven decision paths and quick-check quizzes (with randomized answer order)
- Pass/fail assessments with completion summaries
- XP, levels, daily goals, streaks, and badges (Duolingo-style loop)
- Progress tracking and badges (on-device)
- References screen, searchable glossary, and Live DAF e-Pubs library
- Watched-publication revision indicators, Save to Files, citation links, and broken-link reporting
- Draft App Store metadata in `AppStoreMetadata.md`
- App Store submission checklist in `AppStoreSubmissionChecklist.md`
- Ready-to-host Support / Privacy pages in `docs/`
- Feedback tab: shareable bug reports and feature requests

## Notes
- All content is paraphrased to align with OSHA and Air Force guidance. Always verify with the latest official publications before release.
- The UI uses Dynamic Type-aware system fonts and a tactical dark palette defined in `AppTheme`.

## Next Steps
- Replace the placeholder app icon if you want a different look.
- Expand modules with base-specific procedures or additional AFSC requirements.
- Optional: add analytics or content updates via a local JSON file or remote CMS.
