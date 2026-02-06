import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppTheme.bg.ignoresSafeArea()

            // Subtle radial glow
            RadialGradient(
                colors: [AppTheme.primary.opacity(0.06), .clear],
                center: .top,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()

            // Scanline texture
            GeometryReader { proxy in
                Canvas { context, size in
                    let step: CGFloat = 3
                    for y in stride(from: 0, through: size.height, by: step) {
                        var path = Path()
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                        context.stroke(path, with: .color(.white.opacity(0.015)), lineWidth: 0.5)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}
