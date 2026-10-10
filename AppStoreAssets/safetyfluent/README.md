# SafetyFluent 1.8 assets

- `AppIcon.icon/`: three SVG layers (shield, checkmark, small accent), registered in the app target as `AppIcon`. Xcode compiles light, dark and tintable Liquid Glass compositions and opaque legacy renditions. The standard `AppIcon.appiconset` remains available as a fallback.
- `icon.svg`: flat source artwork, no words or letters. `AppIcon-1024.png`: 1024×1024 RGB, no alpha.
- `screenshots/iphone-6.9/`: seven 1320×2868 store frames in Grace's caption order.
- `screenshots/ipad-13/`: five 2064×2752 store frames using captions 1, 3, 4, 5, 7.
- Each screenshot set retains unframed, real simulator captures in `raw/` and a manifest linking captions, device identity, capture timestamps, source attachments, and output hashes.
- `home-screen/`: device label checks, separate from store screenshots.
- Final listing and brand copy are local release handoffs, not uploaded metadata.

The icon is deterministic vector artwork. `swift scripts/render_brand_icon.swift` regenerates flat PNGs. `python3 scripts/prepare_store_screenshots.py <xcresult-attachments-directory> <iphone-6.9|ipad-13>` produces the store frames from captured app screens. Pillow is a local asset-production tool, not an application dependency.

Apple integration reference: https://developer.apple.com/documentation/xcode/creating-your-app-icon-using-icon-composer

Store captures use isolated demonstration progress through debug-only QA entry points. They show real SwiftUI screens, not the user's training records. Release builds exclude those entry points.
