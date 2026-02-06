import SwiftUI

/// A button style that makes a chip/pill/bubble fully tappable and provides pressed feedback.
/// - Expands hit area to the padded bubble, not just the text.
/// - Applies a `contentShape` so taps anywhere in the rounded rect register.
/// - Adds subtle pressed scaling and opacity.
public struct ChoiceBubbleStyle: ButtonStyle {
    private let background: Color
    private let foreground: Color
    private let cornerRadius: CGFloat
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    private let stroke: Color?

    public init(background: Color = Color.secondary.opacity(0.15),
                foreground: Color = .primary,
                cornerRadius: CGFloat = 16,
                horizontalPadding: CGFloat = 12,
                verticalPadding: CGFloat = 8,
                stroke: Color? = nil) {
        self.background = background
        self.foreground = foreground
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.stroke = stroke
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundStyle(foreground)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(background)
            )
            .overlay {
                if let stroke {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(stroke, lineWidth: 1)
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .compositingGroup()
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: configuration.isPressed)
            .accessibilityAddTraits(.isButton)
    }
}

/// A view modifier that expands the tappable area of a bubble-like view and provides a content shape.
/// Use this if you handle gestures manually (e.g., `onTapGesture`) instead of `Button`.
public struct BubbleHitArea: ViewModifier {
    private let cornerRadius: CGFloat

    public init(cornerRadius: CGFloat = 16) {
        self.cornerRadius = cornerRadius
    }

    public func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.secondary.opacity(0.001)) // invisible but keeps hit area
            )
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

public extension View {
    /// Expands the tappable area to a rounded bubble without changing appearance.
    func bubbleHitArea(cornerRadius: CGFloat = 16) -> some View {
        modifier(BubbleHitArea(cornerRadius: cornerRadius))
    }
}

// MARK: - Examples
#if DEBUG
struct ChoiceBubbleStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            // Using Button + ChoiceBubbleStyle
            Button("Option A") {}
                .buttonStyle(ChoiceBubbleStyle(background: .blue.opacity(0.15), foreground: .blue, stroke: .blue.opacity(0.3)))

            // Using custom content with Button
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
            }
            .buttonStyle(ChoiceBubbleStyle(background: .yellow.opacity(0.2), foreground: .orange))

            // Using onTapGesture + bubbleHitArea
            HStack(spacing: 8) {
                Image(systemName: "tag")
                Text("Tag")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.green.opacity(0.15)))
            .bubbleHitArea()
            .onTapGesture { /* handle tap */ }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
