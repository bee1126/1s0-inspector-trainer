# Screenshot status

The five existing iPhone and five existing iPad PNGs are replaced with actual simulator screenshots of the implemented redesign. Filenames retain their historical names; “HomeHQ” now shows Today and “Live_ePubs” now shows the Library destination. Additional iPhone images show Practice and the exam debrief.

Captured on iPhone 17 Pro (1206 × 2622) and iPad Pro 13-inch M5 (2064 × 2752), iOS/iPadOS 26.5, October 9, 2026. Test scores/progress were created through the app. No generated UI, device-frame artwork, or fabricated feature labels are included.

See `docs/release/StudyUpdateValidation.md` for the validation record and remaining release checks. The release delivery record is maintained separately from this capture record.

For version 1.7, seven `Screenshot_69_*.png` files were resized from the iPhone captures with `sips` to exactly 1320 × 2868. Their aspect ratio differs by less than 0.05%; no content was cropped. Alpha was removed losslessly from these and the five 2064 × 2752 iPad files using Core Graphics. Upload targets are `APP_IPHONE_67` and `APP_IPAD_PRO_3GEN_129`, respectively. The upload helper verifies Apple’s `COMPLETE` processing state before reporting success.

On October 10, 2026 (KST), version 1.7 en-US screenshot delivery was verified through App Store Connect: seven `APP_IPHONE_67` and five `APP_IPAD_PRO_3GEN_129` assets, all `COMPLETE`. The old `APP_IPHONE_65` and `APP_IPHONE_61` sets each contain zero screenshots so smaller iPhones inherit the large-display set.
