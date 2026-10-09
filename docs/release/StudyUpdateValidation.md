# Modern dark / personalized study update

## Implemented

- Today, Learn, Practice, Library, and Progress navigation. Existing URL schemes route to the relevant destination.
- Shared modern dark surfaces, larger reading text, brighter secondary text, reduced decoration, and accessible action buttons.
- Searchable module catalog with completion filters; completed starter path stays available in Learn.
- Custom topic/pool/difficulty/length selection, study and untimed exam modes, bookmarks, offline explanations, and scored debriefs.
- One independently resumable custom session; exams can navigate and change answers until submission. Invalidated content shows a restart message.
- Latest 200 completed custom sessions, module quizzes, and Daily Five runs. Read-only review earns nothing. Unrecorded answers from legacy resumes are explicitly unknown.
- Versioned `study_state_v1` UserDefaults data retains existing progress keys. The completion ledger outlives bounded history. Test suites use isolated defaults.
- 140 explanations and source references; 19 materially changed questions receive replacement IDs. See [content review](../ContentReview.md).

## Completed checks

- Swift syntax parse of all app and test sources.
- Xcode project property-list validation and source membership inspection.
- Core test bodies executed with the macOS Swift fallback in `scripts/check_core.py` (including existing ProgressStore, content-integrity, and adaptive-difficulty coverage). This adapter is not XCTest and does not validate iOS framework behavior.
- Additional SwiftUI type-check using temporary macOS-compatible copies of changed screens, adapted font/platform modifiers, and placeholders for unrelated destinations. This establishes only the checked SwiftUI expressions/types, not a complete application build.

## Native iOS validation (2026-10-09)

After Xcode first-launch setup, the prescribed simulator test command built the complete iOS app and ran all three XCTest suites successfully: **57 tests passed, zero failures, zero skipped**. Xcode 27.0, iPhone 17 Pro simulator model, iOS 26.5. The device is locally named “Codex iPhone 17 Pro iOS 26.5”.

```sh
xcodebuild -scheme "1S0 Inspector Trainer" -project "1S0 Inspector Trainer.xcodeproj" -destination "platform=iOS Simulator,name=iPhone 17 Pro" -derivedDataPath .derived/StudyUpdate test
```

The result bundle is `.derived/StudyUpdate/Logs/Test/Test-1S0 Inspector Trainer-2026.10.09_17-05-11-+0900.xcresult`. `xcresulttool get test-results summary` confirmed the totals. This supersedes the initial Command Line Tools-only build blocker and the earlier fallback checks.

## Visual and interaction checks completed

- Fresh iPhone/iPad Today, all five iPhone destinations, iPad catalog/Progress/Library, and iPad Daily Five deep-link routing.
- Custom exam: five questions, answer changes, selected state without correctness feedback, disabled submit until all answered, explicit submission, 4/5 debrief, topic breakdown, 30 XP, and remediation entry point.
- Force-quit/relaunch retained the custom exam, question/answer order, and selected answer. Today prioritized its resume action.
- Bookmarked question persisted through exam completion; review showed the saved indicator.
- Study remediation used the single unresolved miss, locked the chosen answer, revealed its explanation/reference, and completed separately from Daily Five.
- Largest Dynamic Type on iPhone revealed cramped controls. Revised headers/question headings/actions stack at accessibility sizes; the finish action remains legible and reachable. Screenshot in `screenshots/iPhone-largest-text.png`.
- Accessibility tree inspection confirmed meaningful question, answer, bookmark, selected/correct/incorrect, and unanswered/answered navigation labels. This is not a complete spoken VoiceOver pass.
- All ten original iPhone/iPad promotional PNGs were replaced with genuine simulator captures. Additional iPhone exam-debrief and Practice images are included. Images show actual fresh/test progress, not invented scores.
- Removed old decorative question-image references after the rendered quiz exposed placeholder artwork containing developer notes. Question meaning and IDs are unchanged by removing those images.

## Remaining release checks

Public mirrors are accepted as document-retrieval sources. The 24 February 2026 DAFMAN 91-203 mirror and matching local text resolved paragraph alignment for the hot-work question. The subsequent Buck review of the remaining 35 DAF-referenced questions is applied for release 1.7; see ContentReview.md. No App Store submission was made during the earlier study-update validation.

A complete physical-device/spoken VoiceOver pass, device networking-disabled check, all-completed-training visual fixture, and exhaustive legacy-screen accessibility walkthrough remain unverified. Unit tests cover legacy-data loading and progress retention; they do not substitute for those manual acceptance checks.

## Test rerun destination note

The literal prescribed command succeeded during initial validation. After installation of the iOS 27 runtime, a later attempt could no longer resolve the name-only `iPhone 17 Pro` destination. The final rerun pins the same verified iPhone 17 Pro model by simulator ID:

```sh
xcodebuild -scheme "1S0 Inspector Trainer" -project "1S0 Inspector Trainer.xcodeproj" -destination "platform=iOS Simulator,id=1786DBC2-806E-488B-AEC2-511BB8BF3010" -derivedDataPath .derived/StudyUpdate test
```

Final result: **57 XCTest tests passed; zero failed or skipped**. Result bundle: `.derived/StudyUpdate/Logs/Test/Test-1S0 Inspector Trainer-2026.10.09_17-33-55-+0900.xcresult`. This final run includes the accessibility layout adjustments and removal of placeholder quiz images.

## Release 1.7 final validation — 9 October 2026

Full native XCTest rerun after Buck's content fixes, primary reference updates, retirement registry, and final disclaimer: **58 tests passed, zero failed, zero skipped**, on iPhone 17 Pro (iOS 26.5), pinned simulator ID above. The new currency test checks replacement IDs, DAFI 90-802 references, hearing PDF URL, and the materially changed contract-work/Class A rules. The retirement integrity check now covers the entire registry.

Release helper checks passed for all five metadata limits, missing-field rejection, and mutation-free listing dry-run. Exact review-to-source comparison verified every specified prompt/choice/explanation replacement. All six new Swift files are present in the target; full native builds compiled them. Website local links, metadata tags, and publication naming passed static checks. Screenshots remain the earlier simulator captures; the release script has no screenshot-upload support, so existing App Store screenshots are retained.
