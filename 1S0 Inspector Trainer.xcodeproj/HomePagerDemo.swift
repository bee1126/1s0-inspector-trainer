import SwiftUI

struct HomePagerDemo: View {
    struct Screen: Identifiable { let id = UUID(); let color: Color; let title: String }

    @State private var pages: [Screen] = [
        .init(color: .orange, title: "News"),
        .init(color: .purple, title: "Today"),
        .init(color: .teal, title: "Profile"),
        .init(color: .pink, title: "Settings")
    ]
    @State private var index: Int = 0

    var body: some View {
        ZStack(alignment: .top) {
            // Pager content
            PagedContainerView(pages, index: $index, showsIndicators: false, enableHaptics: true) { page in
                ZStack {
                    page.color.ignoresSafeArea()
                    Text(page.title)
                        .font(.largeTitle).bold()
                        .foregroundStyle(.white)
                        .shadow(radius: 10)
                }
            }

            // Minimal top bar mimicking a status/title area
            HStack {
                Text(pages[safe: index]?.title ?? "")
                    .font(.headline)
                    .transition(.opacity)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(.thinMaterial)
            .overlay(alignment: .bottom) {
                PageDots(count: pages.count, index: index)
                    .padding(.bottom, 6)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal)
            .shadow(radius: 6)
        }
    }
}

private struct PageDots: View {
    let count: Int
    let index: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { i in
                Circle()
                    .fill(i == index ? Color.primary : Color.secondary.opacity(0.4))
                    .frame(width: i == index ? 8 : 6, height: i == index ? 8 : 6)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: index)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial, in: Capsule())
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

#Preview("Home-like pager") {
    HomePagerDemo()
}
