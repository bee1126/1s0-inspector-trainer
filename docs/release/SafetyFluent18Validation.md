# SafetyFluent 1.8 (build 7) — implementation and validation

Base: `main` at `6379d33f96be5df3cb5abe08bf13ff6bdf26a9d3`. Work is on `safetyxp-1.8`; the 1.7 App Store record/submission and main branch are unchanged. No App Store metadata, build upload, version creation, submission, or website deployment is part of this task.

## Implemented

- Explicit fresh-install track choice; existing 1.7 data defaults to Air Force with a dismissible announcement. Raw study bytes are backed up once before migration; corrupt legacy bytes are retained while recovery progress uses a separate key.
- A single catalog filters lessons, scenarios, questions, study/exam building, adaptive review, daily lessons, onboarding, glossary, lookup, library references, tools, bookmarks and module breakdowns. XP/streaks and old achievements are global; completion milestones can also be earned from the civilian catalog, and civilian stage labels are neutral; hidden progress is retained. AF module names keep ORM as directed.
- Five new shared modules and a separate civilian hot-work question: 15 modules/150 questions on OSHA, 19/190 on AF, 191 unique question IDs. Existing 26 retired IDs stay retired. [Paragraph review and hidden-content inventory](../ContentReview.md).
- Local Hazard Report & Risk Matrix, 16-cell example matrix, separate atomic JSON storage, user-initiated text and paginated PDF sharing, individual deletion and confirmed delete-all.
- Native tabs/toolbars, semantic system typography, light/dark colors, iOS 26 glass controls and iOS 17 fallbacks. Legacy glow and repeating sparkle decorations removed.
- Shared SafetyFluent name/disclaimer, source SVG, full Any/Dark/Tinted app-icon catalog and validated Icon Composer file, prepared website and finalized listing.

## Initial feature-build evidence

This section records run 1, before the final rebrand. See [the rebrand validation](SafetyFluent18Rebrand.md) for run 2 and the current screenshots.

The full iPhone suite passes 87 tests (81 unit, six UI), with zero failures or skips. The iPad screenshot and XXL/dark accessibility methods also pass. [Machine-readable results](../review/1.8/validation-summary.json) record the initial feature-build run. The committed `v17-install.plist` fixture was captured after running an actual build of unmodified 1.7 build 6; see [fixture provenance](../../Tests/Fixtures/README.md). It includes bookmarks, review data, module progress and history.

Release configuration compilation uses the generic iOS Simulator destination, including arm64 and x86_64. Debug-only UI-test and screenshot launch environments are excluded from that Release configuration. No new application dependency or permission string was added.

The content review uses official eCFR Title 29 current through 2026-10-07, retrieved 2026-10-10. All 51 new questions have exact paragraph anchors; reviewed text and source hashes are committed under `docs/review/1.8/`.

Accessibility verification includes a full Dynamic Type and element-description audit of the track picker, element-description audit of the native hazard form, direct verification that the form's label grows at XXL, and screenshots of the picker/risk form at XXL in dark mode. XCTest's full-range font audit reported partial support for two native Form labels at its largest accessibility sizes; those native controls are checked at the requested XXL size rather than treating that broader audit as passed. This is not a manual VoiceOver spoken-navigation test.

Network source review: the only application URLSession calls are in `EpubsCatalog.swift`, reached through the AF-only Live e-Pubs view. OSHA reference buttons create SFSafariViewController only on tap; quiz reference links likewise require a tap. No analytics, advertising, SDK endpoint, background link fetch or account service was added. A process network sample was inconclusive and is not presented as a proxy verification.

A representative live eCFR anchor (`1910.22(d)(2)`) was opened in iPad Simulator Safari and the correct paragraph was highlighted. [Device capture](../review/1.8/ecfr-paragraph-device.png). All new anchors also pass exact URL-fragment tests; this is not a claim of 51 separate browser checks.

## Separate release checks

- Abdoul's content/icon approval, ethics review where applicable, and a real-data 1.7-to-1.8 upgrade smoke test.
- Manual VoiceOver navigation on picker and risk matrix; external proxy verification of zero OSHA network requests before opening a reference.
- Xcode Cloud archive/TestFlight and metadata upload/submission only in the separate authorized release step after 1.7 is live. Recheck pending respiratory/fixed-ladder rulemaking and current official publications then.
