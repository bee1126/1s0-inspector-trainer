import SwiftUI
import UIKit

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Native adaptive design system
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

enum AppTheme {
    // Core palette
    static let bg       = Color(uiColor: .systemGroupedBackground)
    static let surface  = Color(uiColor: .secondarySystemGroupedBackground)
    static let border   = Color(uiColor: .separator)
    static let primary = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0, green: 230/255, blue: 161/255, alpha: 1) : UIColor(red: 0, green: 0.43, blue: 0.30, alpha: 1) })
    static let accent = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 1, green: 184/255, blue: 0, alpha: 1) : UIColor(red: 0.53, green: 0.34, blue: 0, alpha: 1) })
    static let danger   = Color(red: 1.0, green: 0.23, blue: 0.36)
    static let text     = Color.primary
    static let muted    = Color.secondary
    static let info     = Color(red: 0.4, green: 0.6, blue: 1.0)

}

enum AppSpacing {
    static let screenPadding: CGFloat = 20
    static let section: CGFloat = 24
    static let stack: CGFloat = 14
    static let item: CGFloat = 10
    static let compact: CGFloat = 6
    static let cardPadding: CGFloat = 20
    static let minTapTarget: CGFloat = 44
}

enum AppFont {
    static func title(_ size: CGFloat) -> Font {
        title(size, relativeTo: .title2)
    }

    static func title(_ size: CGFloat, relativeTo textStyle: UIFont.TextStyle) -> Font {
        scaledSystemFont(
            size: size,
            weight: .bold,
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
        // Semantic SwiftUI fonts react to runtime Dynamic Type changes. A UIFont
        // scaled only when constructed does not pass the accessibility size audit.
        let style: Font.TextStyle
        switch size {
        case ..<12: style = .caption2
        case ..<14: style = .caption
        case ..<16: style = .subheadline
        case ..<18: style = .body
        case ..<20: style = .headline
        case ..<22: style = .title3
        case ..<28: style = .title2
        case ..<34: style = .title
        default: style = .largeTitle
        }
        let fontWeight: Font.Weight = weight == .bold ? .bold : weight == .semibold ? .semibold : weight == .medium ? .medium : .regular
        return .system(style, design: design == .monospaced ? .monospaced : .default, weight: fontWeight)
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.subtitle(17))
            .foregroundColor(AppTheme.bg)
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppTheme.primary)
            )
            .contentShape(Rectangle())
            .opacity(isEnabled ? 1 : 0.4)
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.98 : 1.0)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.subtitle(17))
            .foregroundColor(AppTheme.primary)
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
            .padding(.vertical, 10)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(AppTheme.primary.opacity(0.5), lineWidth: 1)
            )
            .contentShape(Rectangle())
            .opacity(isEnabled ? 1 : 0.4)
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.98 : 1.0)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
