import Foundation
import SwiftUI

// MARK: - GlassCard → Tactical Card

struct GlassCard<Content: View>: View {
    let content: Content
    var glowColor: Color = AppTheme.border

    init(glow: Color = AppTheme.border, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.glowColor = glow
    }

    var body: some View {
        content
            .padding(AppSpacing.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(AppTheme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(glowColor.opacity(0.5), lineWidth: 1)
            )
    }
}

// MARK: - Tag Pill

struct TagPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(AppFont.mono(10))
            .foregroundColor(AppTheme.muted)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(AppTheme.border.opacity(0.6))
            )
    }
}

// MARK: - Stat Pill

struct StatPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(AppFont.mono(9))
                .foregroundColor(AppTheme.muted)
            Text(value)
                .font(AppFont.mono(15))
                .foregroundColor(AppTheme.accent)
        }
    }
}

// MARK: - Score Badge

struct ScoreBadge: View {
    let score: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(badgeColor.opacity(0.15))
                .frame(width: 44, height: 44)
            Text("\(score)%")
                .font(AppFont.mono(13))
                .foregroundColor(badgeColor)
        }
    }

    private var badgeColor: Color {
        score >= 90 ? AppTheme.primary : AppTheme.accent
    }
}

// MARK: - Hearts

struct HeartsView: View {
    let hearts: Int
    let maxHearts: Int
    var compact: Bool = false
    var onDark: Bool = true

    var body: some View {
        HStack(spacing: compact ? 2 : 3) {
            ForEach(0..<maxHearts, id: \.self) { i in
                Image(systemName: i < hearts ? "heart.fill" : "heart")
                    .font(.system(size: compact ? 10 : 12, weight: .bold))
                    .foregroundColor(i < hearts ? AppTheme.danger : AppTheme.muted)
            }
        }
    }
}

// MARK: - HeartsEmptyOverlay

struct HeartsEmptyOverlay: View {
    let onPractice: () -> Void
    let onExit: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()

            GlassCard {
                VStack(spacing: 14) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(AppTheme.danger)
                    Text("OUT OF HEARTS")
                        .font(AppFont.mono(14))
                        .foregroundColor(AppTheme.danger)
                    Text("Practice to restore hearts and continue.")
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.muted)
                        .multilineTextAlignment(.center)
                    Button("Practice Now") {
                        onPractice()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    Button("Exit") {
                        onExit()
                    }
                    .buttonStyle(OutlineButtonStyle())
                }
                .frame(maxWidth: .infinity)
            }
            .padding(40)
        }
    }
}

// MARK: - XP Progress Ring

struct XPProgressRing: View {
    let progress: Double
    let level: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.border, lineWidth: 6)
            Circle()
                .trim(from: 0, to: min(progress, 1))
                .stroke(AppTheme.accent, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(color: AppTheme.accent.opacity(0.4), radius: 6)
            VStack(spacing: 1) {
                Text("LVL")
                    .font(AppFont.mono(8))
                    .foregroundColor(AppTheme.muted)
                Text("\(level)")
                    .font(AppFont.title(18))
                    .foregroundColor(AppTheme.text)
            }
        }
        .frame(width: 60, height: 60)
    }
}

// MARK: - Mission Badge

struct MissionBadge: View {
    let icon: String
    let title: String
    let earned: Bool
    @State private var animateIn = false

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(earned ? AppTheme.primary.opacity(0.15) : AppTheme.border.opacity(0.4))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(earned ? AppTheme.primary : AppTheme.muted)
            }
            .scaleEffect(animateIn && earned ? 1.0 : 0.85)
            .onAppear {
                if earned {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.2)) {
                        animateIn = true
                    }
                }
            }
            Text(title)
                .font(AppFont.mono(9))
                .foregroundColor(earned ? AppTheme.text : AppTheme.muted)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Reward Summary Card

struct RewardSummaryCard: View {
    let summary: RewardSummary
    let xpToNextLevel: Int

    var body: some View {
        GlassCard(glow: AppTheme.accent.opacity(0.4)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(AppTheme.accent)
                    Text("+\(summary.xpGained) XP")
                        .font(AppFont.mono(16))
                        .foregroundColor(AppTheme.accent)
                    if summary.streakMultiplier > 1.0 {
                        Text("x\(String(format: "%.1f", summary.streakMultiplier))")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.primary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppTheme.primary.opacity(0.15))
                            )
                    }
                }

                if summary.heartsRestored > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(AppTheme.danger)
                        Text("+\(summary.heartsRestored) hearts restored")
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.text)
                    }
                }

                if summary.leveledUp {
                    HStack(spacing: 6) {
                        SparkleBurstView()
                            .frame(width: 18, height: 18)
                        Text("LEVEL UP!")
                            .font(AppFont.mono(13))
                            .foregroundColor(AppTheme.accent)
                    }
                }

                if summary.streakIncreased {
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(AppTheme.accent)
                        Text("Streak increased!")
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.text)
                    }
                }

                Text("\(xpToNextLevel) XP to next level")
                    .font(AppFont.mono(11))
                    .foregroundColor(AppTheme.muted)
            }
        }
    }
}

// MARK: - Sparkle Burst

struct SparkleBurstView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { i in
                Circle()
                    .fill(AppTheme.accent)
                    .frame(width: 3, height: 3)
                    .offset(y: animate ? -10 : 0)
                    .opacity(animate ? 0 : 1)
                    .rotationEffect(.degrees(Double(i) * 60))
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - Streak Popup

struct StreakPopupView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(AppFont.mono(14))
            .foregroundColor(AppTheme.bg)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule().fill(AppTheme.accent)
            )
            .shadow(color: AppTheme.accent.opacity(0.4), radius: 8)
    }
}

// MARK: - Challenge Row

struct ChallengeRow: View {
    let title: String
    let isComplete: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isComplete ? "checkmark.square.fill" : "square")
                .foregroundColor(isComplete ? AppTheme.primary : AppTheme.muted)
            Text(title)
                .font(AppFont.body(13))
                .foregroundColor(AppTheme.text)
        }
    }
}

// MARK: - Form Fields

struct FormFieldLabel: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(AppFont.mono(10))
            .foregroundColor(AppTheme.muted)
    }
}

struct AppTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .font(AppFont.body(14))
            .foregroundColor(AppTheme.text)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(AppTheme.bg)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
    }
}

struct AppTextEditor: View {
    @Binding var text: String
    var height: CGFloat = 80

    var body: some View {
        TextEditor(text: $text)
            .font(AppFont.body(14))
            .foregroundColor(AppTheme.text)
            .scrollContentBackground(.hidden)
            .padding(8)
            .frame(minHeight: height)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(AppTheme.bg)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
    }
}

// MARK: - OptionRow

struct OptionRow: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isLocked: Bool
    var revealCorrect: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(.top, 6)
            Text(text)
                .font(AppFont.body(14))
                .foregroundColor(AppTheme.text)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.item)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
        .opacity(isLocked && !isSelected && !(revealCorrect && isCorrect) ? 0.5 : 1.0)
        .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var indicatorColor: Color {
        if isSelected {
            return isCorrect ? AppTheme.primary : AppTheme.danger
        }
        if revealCorrect && isLocked && isCorrect {
            return AppTheme.primary
        }
        return AppTheme.info
    }

    private var borderColor: Color {
        if isSelected {
            return isCorrect ? AppTheme.primary.opacity(0.7) : AppTheme.danger.opacity(0.7)
        }
        if revealCorrect && isLocked && isCorrect {
            return AppTheme.primary.opacity(0.7)
        }
        return AppTheme.border
    }

    private var backgroundColor: Color {
        if isSelected {
            return isCorrect ? AppTheme.primary.opacity(0.1) : AppTheme.danger.opacity(0.1)
        }
        if revealCorrect && isLocked && isCorrect {
            return AppTheme.primary.opacity(0.08)
        }
        return AppTheme.surface
    }
}

// MARK: - FeedbackView

struct FeedbackView: View {
    let text: String
    let isCorrect: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(isCorrect ? AppTheme.primary : AppTheme.danger)
                .frame(width: 10, height: 10)
                .padding(.top, 6)
            Text(text)
                .font(AppFont.body(14))
                .foregroundColor(AppTheme.text)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(AppSpacing.item)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(isCorrect ? AppTheme.primary.opacity(0.08) : AppTheme.danger.opacity(0.08))
        )
    }
}

// MARK: - Match Card

struct MatchCardView: View {
    let card: MatchCard
    let isSelected: Bool
    let isMatched: Bool
    let isMismatched: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 6) {
                Text(card.kind == .term ? "Prompt" : "Answer")
                    .font(AppFont.mono(10))
                    .foregroundColor(labelColor)

                Text(card.text)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.text)
                    .lineLimit(4)
                    .minimumScaleFactor(0.85)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 84, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
            .opacity(isMatched ? 0.55 : 1.0)

            if isMatched {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppTheme.primary)
                    .padding(10)
            }
        }
        .background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: CardFramePreferenceKey.self, value: [card.id: proxy.frame(in: .named("matchGrid"))])
            }
        )
        .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var backgroundColor: Color {
        if isMatched { return AppTheme.primary.opacity(0.1) }
        if isMismatched { return AppTheme.danger.opacity(0.1) }
        if isSelected { return AppTheme.info.opacity(0.15) }
        return AppTheme.surface
    }

    private var borderColor: Color {
        if isMatched { return AppTheme.primary.opacity(0.6) }
        if isMismatched { return AppTheme.danger.opacity(0.6) }
        if isSelected { return AppTheme.info.opacity(0.6) }
        return AppTheme.border
    }

    private var labelColor: Color {
        if isMatched { return AppTheme.primary }
        if isSelected { return AppTheme.info }
        return AppTheme.muted
    }
}

// MARK: - CardFramePreferenceKey

struct CardFramePreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGRect] = [:]
    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
}
