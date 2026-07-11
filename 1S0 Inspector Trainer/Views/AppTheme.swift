import SwiftUI
import UIKit

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

}

enum AppSpacing {
    static let screenPadding: CGFloat = 20
    static let section: CGFloat = 16
    static let stack: CGFloat = 14
    static let item: CGFloat = 10
    static let compact: CGFloat = 6
    static let cardPadding: CGFloat = 16
    static let minTapTarget: CGFloat = 44
}

enum AppFont {
    static func title(_ size: CGFloat) -> Font {
        title(size, relativeTo: .title2)
    }

    static func title(_ size: CGFloat, relativeTo textStyle: UIFont.TextStyle) -> Font {
        scaledSystemFont(
            size: size,
            weight: .black,
            textStyle: textStyle
        )
    }

    static func subtitle(_ size: CGFloat) -> Font {
        subtitle(size, relativeTo: .headline)
    }

    static func subtitle(_ size: CGFloat, relativeTo textStyle: UIFont.TextStyle) -> Font {
        scaledSystemFont(
            size: size,
            weight: .semibold,
            textStyle: textStyle
        )
    }

    static func body(_ size: CGFloat) -> Font {
        body(size, relativeTo: .body)
    }

    static func body(_ size: CGFloat, relativeTo textStyle: UIFont.TextStyle) -> Font {
        scaledSystemFont(
            size: size,
            weight: .regular,
            textStyle: textStyle
        )
    }

    static func mono(_ size: CGFloat) -> Font {
        mono(size, relativeTo: .body)
    }

    static func mono(_ size: CGFloat, relativeTo textStyle: UIFont.TextStyle) -> Font {
        scaledSystemFont(
            size: size,
            weight: .medium,
            textStyle: textStyle,
            design: .monospaced
        )
    }

    private static func scaledSystemFont(
        size: CGFloat,
        weight: UIFont.Weight,
        textStyle: UIFont.TextStyle,
        design: UIFontDescriptor.SystemDesign? = nil
    ) -> Font {
        var descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor
        if let design,
           let designedDescriptor = descriptor.withDesign(design) {
            descriptor = designedDescriptor
        }
        let baseFont = UIFont(descriptor: descriptor, size: size)
        let scaledFont = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: baseFont)
        return Font(scaledFont)
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.subtitle(14))
            .foregroundColor(AppTheme.bg)
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(AppTheme.primary)
            )
            .contentShape(Rectangle())
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
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
            .padding(.vertical, 10)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(AppTheme.primary.opacity(0.5), lineWidth: 1)
            )
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
