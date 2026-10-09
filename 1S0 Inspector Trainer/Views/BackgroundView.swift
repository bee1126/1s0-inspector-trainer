import SwiftUI

struct BackgroundView: View {
    var body: some View {
        AppTheme.bg
            .overlay(alignment: .top) {
                LinearGradient(colors: [AppTheme.primary.opacity(0.035), .clear], startPoint: .top, endPoint: .bottom)
                    .frame(height: 320)
            }
            .ignoresSafeArea()
            .accessibilityHidden(true)
    }
}
