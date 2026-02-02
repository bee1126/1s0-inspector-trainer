import SwiftUI

struct LessonPagerView: View {
    let pages: [LessonPage]
    let onComplete: () -> Void

    @State private var index: Int = 0

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Lesson")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
                    Spacer()
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
        .padding(.horizontal, 20)
    }
}
