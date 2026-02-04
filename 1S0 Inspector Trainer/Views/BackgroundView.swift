import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
            GeometryReader { proxy in
                let size = proxy.size
                Canvas { context, _ in
                    let spacing: CGFloat = 40
                    let dotSize: CGFloat = 2.2

                    for y in stride(from: 0, through: size.height, by: spacing) {
                        for x in stride(from: 0, through: size.width, by: spacing) {
                            let rect = CGRect(x: x, y: y, width: dotSize, height: dotSize)
                            context.fill(
                                Path(ellipseIn: rect),
                                with: .color(Color.white.opacity(0.08))
                            )
                        }
                    }
                }
            }
            .blendMode(.screen)
        }
        .ignoresSafeArea()
    }
}
