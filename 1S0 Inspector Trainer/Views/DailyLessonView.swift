import SwiftUI

struct DailyLessonView: View {
    let lesson: DailyLesson

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.section) {
                    header
                    keyPointsSection
                    if let regulation = lesson.regulation {
                        regulationBadge(regulation)
                    }
                    proTipSection
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: lesson.icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.accent)
                Text(lesson.moduleTag.uppercased())
                    .font(AppFont.mono(10))
                    .foregroundColor(AppTheme.accent)
                    .tracking(1)
            }

            Text(lesson.title)
                .font(AppFont.title(24))
                .foregroundColor(AppTheme.text)

            Text(lesson.subtitle)
                .font(AppFont.body(14))
                .foregroundColor(AppTheme.muted)
        }
    }

    // MARK: - Key Points

    private var keyPointsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("KEY POINTS")
                .font(AppFont.mono(11))
                .foregroundColor(AppTheme.muted)
                .tracking(1.5)

            ForEach(Array(lesson.keyPoints.enumerated()), id: \.offset) { index, point in
                keyPointRow(number: index + 1, text: point)
            }
        }
    }

    private func keyPointRow(number: Int, text: String) -> some View {
        GlassCard {
            HStack(alignment: .top, spacing: 14) {
                Text("\(number)")
                    .font(AppFont.mono(14))
                    .foregroundColor(AppTheme.primary)
                    .frame(width: 24, height: 24)
                    .background(
                        Circle()
                            .fill(AppTheme.primary.opacity(0.12))
                    )

                Text(text)
                    .font(AppFont.body(14))
                    .foregroundColor(AppTheme.text)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: - Regulation Badge

    private func regulationBadge(_ regulation: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(AppTheme.info)
            Text(regulation)
                .font(AppFont.mono(12))
                .foregroundColor(AppTheme.info)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(AppTheme.info.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(AppTheme.info.opacity(0.2), lineWidth: 1)
        )
    }

    // MARK: - Pro Tip

    private var proTipSection: some View {
        GlassCard(glow: AppTheme.accent.opacity(0.3)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.accent)
                    Text("PRO TIP")
                        .font(AppFont.mono(11))
                        .foregroundColor(AppTheme.accent)
                        .tracking(1.5)
                }

                Text(lesson.proTip)
                    .font(AppFont.body(14))
                    .foregroundColor(AppTheme.text)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Home Card (compact version for HomeView)

struct DailyLessonCard: View {
    let lesson: DailyLesson

    var body: some View {
        GlassCard(glow: AppTheme.accent.opacity(0.2)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.accent)
                    Text("Daily Lesson")
                        .font(AppFont.subtitle(15))
                        .foregroundColor(AppTheme.text)
                    Spacer()
                    Text(todayFormatted)
                        .font(AppFont.mono(10))
                        .foregroundColor(AppTheme.muted)
                }

                Text(lesson.title)
                    .font(AppFont.subtitle(16))
                    .foregroundColor(AppTheme.text)

                Text(lesson.subtitle)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.muted)

                HStack(spacing: 8) {
                    TagPill(text: lesson.moduleTag)
                    if lesson.regulation != nil {
                        TagPill(text: "Reg Reference")
                    }
                }

                NavigationLink {
                    DailyLessonView(lesson: lesson)
                } label: {
                    HStack {
                        Text("Read Lesson")
                        Spacer()
                        Image(systemName: "arrow.right.circle.fill")
                    }
                }
                .buttonStyle(OutlineButtonStyle())
            }
        }
    }

    private var todayFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: Date()).uppercased()
    }
}
