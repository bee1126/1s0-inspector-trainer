# SafetyXP 1.8 simulator captures

Eight native app captures per device, in upload order. `iphone-6.9/` is 1320×2868; `ipad-13/` is 2064×2752. PNGs are RGB with no alpha, with original simulator dimensions preserved. Each device's manifest records captions, capture time, simulator identity and file hashes.

| # | Scene |
|---|---|
| 01 | First-launch track picker, no default selected |
| 02 | Today, OSHA / Civilian |
| 03 | OSHA module catalog, 15 modules / 150 questions |
| 04 | Answer explanation and specific 29 CFR reference |
| 05 | Local Hazard Report & Risk Matrix |
| 06 | Exam debrief |
| 07 | Progress |
| 08 | Air Force catalog, 19 modules / 190 questions |

Captured with `TrackUITests/testScreenshots()` from the actual app views. Debug-only launch settings create isolated demonstration data through the real progress-store APIs; no personal production progress is used. No decorative overlays or official agency marks are added. These files are prepared locally and have not been uploaded to App Store Connect.

The separate XXL/dark accessibility captures are in `docs/review/1.8/accessibility/` and are not part of this store screenshot set.
