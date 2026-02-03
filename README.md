# Safety Inspector Trainer

This folder contains the SwiftUI source for a native iOS training app tailored to Air Force safety inspectors. It is structured so you can drop the `SafetyInspector` folder into an Xcode iOS App project.

## Quick Start (Xcode)
1. Open `SafetyInspector.xcodeproj` in Xcode.
2. Select the `SafetyInspector` target and set your team and bundle identifier.
3. Run on an iOS simulator or device.

## What is Included
- Interactive modules for Lockout/Tagout, Fall Protection, Risk Management, Roles & Responsibilities, Hazard Abatement, and RAC System
- Additional modules for Confined Space, Hot Work, Hearing Conservation, Mishap Reporting, Investigation Basics, JHA Fundamentals, Safety Briefing, and PPE Decision
- Scenario-driven decision paths and quick-check quizzes (with randomized answer order)
- Quiz difficulty selector (Easy / Medium / Hard / All)
- Pass/fail assessments with completion summaries
- XP, levels, daily goals, streaks, and hearts (Duolingo-style loop)
- Progress tracking and badges (on-device)
- References screen and disclaimer
- Draft App Store metadata in `AppStoreMetadata.md`
- App Store submission checklist in `AppStoreSubmissionChecklist.md`
- Ready-to-host Support / Privacy pages in `docs/`
- Feedback tab: shareable bug reports and feature requests

## Notes
- All content is paraphrased to align with OSHA and Air Force guidance. Always verify with the latest official publications before release.
- The UI uses built-in fonts (Avenir Next) and a custom blue/green theme.

## Next Steps
- Replace the placeholder app icon if you want a different look.
- Expand modules with base-specific procedures or additional AFSC requirements.
- Optional: add analytics or content updates via a local JSON file or remote CMS.
