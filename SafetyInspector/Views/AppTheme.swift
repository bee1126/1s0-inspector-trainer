import SwiftUI

enum AppTheme {
    static let navy = Color(red: 0.05, green: 0.11, blue: 0.22)
    static let blue = Color(red: 0.12, green: 0.37, blue: 0.72)
    static let sky = Color(red: 0.52, green: 0.78, blue: 0.96)
    static let safetyGreen = Color(red: 0.21, green: 0.72, blue: 0.48)
    static let mint = Color(red: 0.74, green: 0.94, blue: 0.84)
    static let sand = Color(red: 0.96, green: 0.96, blue: 0.94)
    static let charcoal = Color(red: 0.14, green: 0.16, blue: 0.20)

    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [navy, blue, sky, mint]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

enum AppFont {
    static func title(_ size: CGFloat) -> Font {
        .custom("AvenirNext-Heavy", size: size)
    }

    static func subtitle(_ size: CGFloat) -> Font {
        .custom("AvenirNext-DemiBold", size: size)
    }

    static func body(_ size: CGFloat) -> Font {
        .custom("AvenirNext-Regular", size: size)
    }

    static func mono(_ size: CGFloat) -> Font {
        .custom("Menlo", size: size)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.subtitle(16))
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppTheme.blue)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFont.subtitle(15))
            .foregroundColor(AppTheme.blue)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(AppTheme.blue, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
