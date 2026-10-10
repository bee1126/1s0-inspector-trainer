# Home-screen label check — October 10, 2026

Installed app: SafetyFluent 1.8 (7), bundle `com.abdoulbah.1s0-inspector-trainer`, iOS 26.5 simulator runtime.

| Simulator | Standard text | Largest accessibility text | Display Zoom |
|---|---|---|---|
| iPhone 17e (smallest available iPhone) | **SafetyFluent — full** | **SafetyFluent — full** | Not exposed in Settings; search returns no results |
| iPhone 17 Pro Max | **SafetyFluent — full** | **SafetyFluent — full** | Not exposed in Settings; search returns no results |

The actual rendered labels were inspected, not inferred from accessibility names. No `SafetyFlu...` truncation was observed. The display name was not shortened. Standard text is the system `large` category; the largest setting is `accessibility-extra-extra-extra-large`, verified with `simctl ui ... content_size`. Device settings were restored to `large` afterward.

`*-standard.png` and `*-largest-text.png` are unframed home-screen captures. `*-display-zoom-unavailable.png` records each simulator's Settings search. A blank adjacent icon in the 17e standard capture is the disposable test runner disappearing after uninstall, not SafetyFluent.

Display Zoom on a physical device remains unverified. No claim is made that a macOS simulator-window magnification setting tests iOS Display Zoom.
