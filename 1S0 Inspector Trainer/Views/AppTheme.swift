import SwiftUI

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// TACTICAL DARK — Design System
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

enum AppTheme {
    // Core palette
    static let bg       = Color(red: 0.04, green: 0.055, blue: 0.08)
    static let surface  = Color(red: 0.08, green: 0.10, blue: 0.13)
    static let border   = Color(red: 0.12, green: 0.16, blue: 0.22)
    static let primary  = Color(red: 0.0, green: 0.90, blue: 0.63)
    static let accent   = Color(red: 1.0, green: 0.72, blue: 0.0)
    static let danger   = Color(red: 1.0, green: 0.23, blue: 0.36)
    static let text     = Color(red: 0.91, green: 0.93, blue: 0.95)
    static let muted    = Color(red: 0.35, green: 0.40, blue: 0.47)
    static let info     = Color(red: 0.4, green: 0.6, blue: 1.0)

    // Semantic aliases (backward-compatible names)
    static let navy        = bg
    static let blue        = info
    static let sky         = info.opacity(0.4)
    static let safetyGreen = primary
    static let mint        = primary.opacity(0.3)
    static let sand        = text
    static let charcoal    = text
    static let xpGold      = accent
    static let heartRed    = danger

    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [bg, surface]),
        startPoint: .top,
        endPoint: .bottom
    )
}

enum AppSpacing {
    static let screenPadding: CGFloat = 20
    static let section: CGFloat = 16
    static let stack: CGFloat = 14
    static let item: CGFloat = 10
    static let compact: CGFloat = 6
    static let cardPadding: CGFloat = 16
}

enum AppFont {
    static func title(_ size: CGFloat) -> Font {
        .system(size: size, weight: .black, design: .default)
    }

    static func subtitle(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }

    static func body(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    static func mono(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .monospaced)
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.subtitle(14))
            .foregroundColor(AppTheme.bg)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(AppTheme.primary)
            )
            .shadow(color: AppTheme.primary.opacity(0.3), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.subtitle(14))
            .foregroundColor(AppTheme.primary)
            .padding(.vertical, 10)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(AppTheme.primary.opacity(0.5), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
