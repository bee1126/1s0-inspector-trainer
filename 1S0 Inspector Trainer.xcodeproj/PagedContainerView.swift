import SwiftUI
import Combine

/// A reusable, smooth, horizontally paged container similar to the iOS Home Screen.
/// - Uses `TabView` with `.page` style for UIKit-backed, performant paging.
/// - Supports binding to the current page index.
/// - Works with either a collection of items or a simple count.
public struct PagedContainerView<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {
    private let data: Data
    @Binding private var index: Int
    private let showsIndicators: Bool
    private let enableHaptics: Bool
    private let content: (Data.Element) -> Content

    /// Create a paged container from identifiable data.
    /// - Parameters:
    ///   - data: A collection of identifiable items to page through.
    ///   - index: Binding to the current page index.
    ///   - showsIndicators: Controls the built-in page indicator visibility.
    ///   - enableHaptics: If true, emits a light selection haptic when the page changes.
    ///   - content: Builder producing a page for each item.
    public init(_ data: Data,
                index: Binding<Int>,
                showsIndicators: Bool = true,
                enableHaptics: Bool = false,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self._index = index
        self.showsIndicators = showsIndicators
        self.enableHaptics = enableHaptics
        self.content = content
    }

    public var body: some View {
        InternalPager(index: $index,
                      pages: data.map { AnyView(content($0)) },
                      showsIndicators: showsIndicators,
                      enableHaptics: enableHaptics)
    }
}

/// Convenience overload for a simple count of pages.
public struct PagedCountView<Content: View>: View {
    private let count: Int
    @Binding private var index: Int
    private let showsIndicators: Bool
    private let enableHaptics: Bool
    private let content: (Int) -> Content

    public init(count: Int,
                index: Binding<Int>,
                showsIndicators: Bool = true,
                enableHaptics: Bool = false,
                @ViewBuilder content: @escaping (Int) -> Content) {
        self.count = max(0, count)
        self._index = index
        self.showsIndicators = showsIndicators
        self.enableHaptics = enableHaptics
        self.content = content
    }

    public var body: some View {
        InternalPager(index: $index,
                      pages: (0..<count).map { i in AnyView(content(i)) },
                      showsIndicators: showsIndicators,
                      enableHaptics: enableHaptics)
    }
}

/// Internal pager implementation that renders AnyView pages.
fileprivate struct InternalPager: View {
    @Binding var index: Int
    let pages: [AnyView]
    let showsIndicators: Bool
    let enableHaptics: Bool

    @State private var lastAnnouncedIndex: Int = 0

    var body: some View {
        TabView(selection: $index) {
            ForEach(Array(pages.enumerated()), id: \.offset) { (offset, page) in
                page
                    .tag(offset)
                    .contentShape(Rectangle())
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: showsIndicators ? .automatic : .never))
        .onChange(of: index) { _, newValue in
            announceChangeIfNeeded(newValue)
        }
        .onAppear {
            lastAnnouncedIndex = index
        }
    }

    private func announceChangeIfNeeded(_ newIndex: Int) {
        guard enableHaptics, newIndex != lastAnnouncedIndex else { return }
        lastAnnouncedIndex = newIndex
        #if os(iOS)
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        #endif
    }
}

#if DEBUG
struct PagedContainerView_Previews: PreviewProvider {
    struct Item: Identifiable { let id = UUID(); let color: Color; let title: String }
    static let items: [Item] = [
        .init(color: .red, title: "One"),
        .init(color: .green, title: "Two"),
        .init(color: .blue, title: "Three")
    ]

    @State static var index = 0

    static var previews: some View {
        Group {
            PagedContainerView(items, index: $index) { item in
                ZStack { item.color; Text(item.title).font(.largeTitle).bold().foregroundStyle(.white) }
            }
            .previewDisplayName("Identifiable Data")

            PagedCountView(count: 3, index: $index, showsIndicators: false, enableHaptics: true) { i in
                ZStack { Color(hue: Double(i)/3.0, saturation: 0.6, brightness: 0.8); Text("Page \(i)").font(.largeTitle).bold() }
            }
            .previewDisplayName("Count-based")
        }
    }
}
#endif
