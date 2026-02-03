import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.88))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}

struct TagPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(AppFont.mono(11))
            .foregroundColor(AppTheme.blue)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(AppTheme.sky.opacity(0.35))
            )
    }
}

struct StatPill: View {
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AppFont.mono(11))
                .foregroundColor(tint.opacity(0.9))
            Text(value)
                .font(AppFont.subtitle(16))
                .foregroundColor(AppTheme.charcoal)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.92))
        )
    }
}

struct ScoreBadge: View {
    let score: Int

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(score >= 90 ? AppTheme.safetyGreen : AppTheme.blue)
                .frame(width: 8, height: 8)
            Text("\(score)%")
                .font(AppFont.subtitle(12))
                .foregroundColor(AppTheme.charcoal)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            Capsule().fill(Color.white.opacity(0.9))
        )
    }
}

struct HeartsView: View {
    let hearts: Int
    let maxHearts: Int
    var compact: Bool = false
    var onDark: Bool = true

    var body: some View {
        HStack(spacing: compact ? 2 : 4) {
            ForEach(0..<maxHearts, id: \.self) { index in
                Image(systemName: index < hearts ? "heart.fill" : "heart")
                    .font(.system(size: compact ? 11 : 14, weight: .semibold))
                    .foregroundColor(index < hearts ? AppTheme.heartRed : emptyColor)
            }
        }
        .padding(.horizontal, compact ? 6 : 8)
        .padding(.vertical, compact ? 4 : 6)
        .background(
            Capsule().fill(backgroundColor)
        )
    }

    private var backgroundColor: Color {
        onDark ? Color.black.opacity(0.2) : AppTheme.charcoal.opacity(0.12)
    }

    private var emptyColor: Color {
        onDark ? Color.white.opacity(0.45) : AppTheme.charcoal.opacity(0.4)
    }
}

struct MissionBadge: View {
    let title: String
    let detail: String
    let isEarned: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(isEarned ? AppTheme.safetyGreen : Color.gray.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(isEarned ? "OK" : "OFF")
                        .font(AppFont.mono(10))
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(AppFont.subtitle(16))
                    .foregroundColor(AppTheme.charcoal)
                Text(detail)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.9))
        )
    }
}

struct XPProgressRing: View {
    let progress: Double
    let level: Int
    let size: CGFloat
    var onDark: Bool = true

    var body: some View {
        ZStack {
            Circle()
                .stroke(baseStrokeColor, lineWidth: 8)
            Circle()
                .trim(from: 0, to: min(progress, 1))
                .stroke(
                    AppTheme.xpGold,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            VStack(spacing: 2) {
                Text("Level")
                    .font(AppFont.mono(10))
                    .foregroundColor(textColor.opacity(0.8))
                Text("\(level)")
                    .font(AppFont.title(18))
                    .foregroundColor(textColor)
            }
        }
        .frame(width: size, height: size)
    }

    private var textColor: Color {
        onDark ? .white : AppTheme.charcoal
    }

    private var baseStrokeColor: Color {
        onDark ? Color.white.opacity(0.35) : AppTheme.charcoal.opacity(0.18)
    }
}

struct RewardSummaryCard: View {
    let summary: RewardSummary
    var xpToNextLevel: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Rewards")
                .font(AppFont.subtitle(16))
                .foregroundColor(AppTheme.charcoal)

            HStack(spacing: 8) {
                RewardChip(text: "+\(summary.xpGained) XP", systemImage: "sparkles")
                if summary.heartsRestored > 0 {
                    RewardChip(text: "+\(summary.heartsRestored) Hearts", systemImage: "heart.fill")
                }
            }

            if summary.leveledUp {
                Text("Level up unlocked!")
                    .font(AppFont.subtitle(14))
                    .foregroundColor(AppTheme.xpGold)
            }
            if summary.streakIncreased {
                Text("Daily goal streak extended.")
                    .font(AppFont.body(12))
                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
            }
            if let xpToNextLevel {
                Text("\(xpToNextLevel) XP to next level")
                    .font(AppFont.body(12))
                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppTheme.mint.opacity(0.6))
        )
    }
}

struct RewardChip: View {
    let text: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .font(AppFont.subtitle(12))
        }
        .foregroundColor(AppTheme.charcoal)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule().fill(Color.white.opacity(0.9))
        )
    }
}

struct HeartsEmptyOverlay: View {
    let onPractice: () -> Void
    let onExit: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Out of Hearts")
                        .font(AppFont.title(20))
                        .foregroundColor(AppTheme.charcoal)
                    Text("Practice restores hearts. Keep your streak alive and jump back in.")
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.charcoal.opacity(0.7))

                    Button("Practice to Restore Hearts") {
                        onPractice()
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    Button("Exit Module") {
                        onExit()
                    }
                    .buttonStyle(OutlineButtonStyle())
                }
            }
            .padding(24)
        }
    }
}
