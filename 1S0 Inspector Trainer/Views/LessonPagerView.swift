import SwiftUI

struct LessonPagerView: View {
    let pages: [LessonPage]
    var onSkip: (() -> Void)? = nil
    let onComplete: () -> Void
    var initialIndex: Int = 0
    var onIndexChange: ((Int) -> Void)? = nil
    @State private var index: Int

    init(pages: [LessonPage], onSkip: (() -> Void)? = nil, onComplete: @escaping () -> Void, initialIndex: Int = 0, onIndexChange: ((Int) -> Void)? = nil) {
        self.pages = pages
        self.onSkip = onSkip
        self.onComplete = onComplete
        self.initialIndex = initialIndex
        self.onIndexChange = onIndexChange
        _index = State(initialValue: max(0, min(initialIndex, max(0, pages.count - 1))))
    }
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                GlassCard {
                    VStack(alignment: .leading, spacing: 24) {
                        if pages.isEmpty {
                            Text("Lesson unavailable").font(AppFont.title(24))
                        } else {
                            HStack {
                                Text("Lesson \(index + 1) of \(pages.count)").font(AppFont.mono(13))
                                Spacer()
                                if let onSkip { Button("Skip", action: onSkip).frame(minHeight: 44).tint(AppTheme.primary) }
                            }
                            Text(pages[index].title).font(AppFont.title(26))
                            ForEach(pages[index].bullets, id: \.self) { bullet in
                                HStack(alignment: .top, spacing: 14) {
                                    RoundedRectangle(cornerRadius: 2).fill(AppTheme.primary).frame(width: 3, height: 24)
                                    Text(bullet).font(AppFont.body(18)).lineSpacing(5).fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }
                }.id("lessonTop").tacticalReadableWidth().padding(.horizontal, AppSpacing.screenPadding)
            }.scrollIndicators(.hidden)
                .onChange(of: index) { _, value in onIndexChange?(value); proxy.scrollTo("lessonTop", anchor: .top) }
        }
        .foregroundStyle(AppTheme.text)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button("Back") { index = max(0, index - 1) }.buttonStyle(OutlineButtonStyle()).disabled(index == 0)
                Button(index >= pages.count - 1 ? "Continue" : "Next") {
                    if index >= pages.count - 1 { onComplete() } else { index += 1 }
                }.buttonStyle(PrimaryButtonStyle())
            }.studyActionBar()
        }
    }
}
