import SwiftUI

struct LessonPagerView: View {
    let pages: [LessonPage]
    var onSkip: (() -> Void)? = nil
    let onComplete: () -> Void
    var initialIndex: Int = 0
    var onIndexChange: ((Int) -> Void)? = nil

    @State private var index: Int
    private let swipeThreshold: CGFloat = 70

    init(pages: [LessonPage], onSkip: (() -> Void)? = nil, onComplete: @escaping () -> Void, initialIndex: Int = 0, onIndexChange: ((Int) -> Void)? = nil) {
        self.pages = pages
        self.onSkip = onSkip
        self.onComplete = onComplete
        self.initialIndex = initialIndex
        self.onIndexChange = onIndexChange
        _index = State(initialValue: max(0, min(initialIndex, max(0, pages.count - 1))))
    }

    var body: some View {
        ScrollView {
            GlassCard {
                VStack(alignment: .leading, spacing: AppSpacing.stack) {
                    HStack(spacing: 12) {
                        Text("Lesson")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.charcoal.opacity(0.6))
                        Spacer()
                        if let onSkip {
                            Button("Skip Lesson") {
                                onSkip()
                            }
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.blue)
                        }
                        Text("\(index + 1)/\(pages.count)")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.charcoal.opacity(0.6))
                    }

                    Text(pages[index].title)
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.charcoal)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(pages[index].bullets, id: \.self) { bullet in
                            HStack(alignment: .top, spacing: 8) {
                                Circle()
                                    .fill(AppTheme.safetyGreen)
                                    .frame(width: 6, height: 6)
                                    .padding(.top, 6)
                                Text(bullet)
                                    .font(AppFont.body(14))
                                    .foregroundColor(AppTheme.charcoal.opacity(0.85))
                            }
                        }
                    }

                    HStack {
                        Button("Back") {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                index = max(0, index - 1)
                            }
                        }
                        .buttonStyle(OutlineButtonStyle())
                        .disabled(index == 0)

                        Spacer()

                        Button(index == pages.count - 1 ? "Continue" : "Next") {
                            if index == pages.count - 1 {
                                onComplete()
                            } else {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    index += 1
                                }
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
            }
            .padding(.horizontal, AppSpacing.screenPadding)
        }
        .scrollIndicators(.hidden)
        .simultaneousGesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    handleSwipe(value)
                }
        )
        .onChange(of: index) { newValue in
            onIndexChange?(newValue)
        }
    }

    private func handleSwipe(_ value: DragGesture.Value) {
        let horizontal = value.translation.width
        guard abs(horizontal) > swipeThreshold else { return }
        if horizontal < 0 {
            if index == pages.count - 1 {
                onComplete()
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    index += 1
                }
            }
        } else if horizontal > 0, index > 0 {
            withAnimation(.easeInOut(duration: 0.2)) {
                index -= 1
            }
        }
    }
}
