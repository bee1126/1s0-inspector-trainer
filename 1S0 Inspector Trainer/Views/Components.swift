import Foundation
import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    var fullWidth: Bool = true

    init(fullWidth: Bool = true, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.fullWidth = fullWidth
    }

    var body: some View {
        content
            .padding(AppSpacing.cardPadding)
            .frame(maxWidth: fullWidth ? .infinity : nil, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.88))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)
            .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
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
    @State private var animate = false

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
        .scaleEffect(animate ? 1.0 : 0.96)
        .shadow(color: isEarned ? AppTheme.safetyGreen.opacity(0.18) : Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
        .onAppear {
            guard isEarned else { return }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                animate = true
            }
        }
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
    @State private var didTrigger = false
    @State private var pulse = false

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
            .scaleEffect(pulse ? 1.04 : 1.0)

            if summary.leveledUp {
                Text("Level up unlocked!")
                    .font(AppFont.subtitle(14))
                    .foregroundColor(AppTheme.xpGold)
            }
            if summary.streakMultiplier > 1.0 {
                Text("Streak bonus x\(String(format: "%.1f", summary.streakMultiplier))")
                    .font(AppFont.body(12))
                    .foregroundColor(AppTheme.safetyGreen)
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
        .overlay(alignment: .topTrailing) {
            if summary.leveledUp {
                SparkleBurstView(color: AppTheme.xpGold)
                    .frame(width: 70, height: 70)
                    .offset(x: 8, y: -12)
            }
        }
        .onAppear {
            guard !didTrigger else { return }
            didTrigger = true
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                pulse = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    pulse = false
                }
            }
            if summary.leveledUp {
                AppFeedback.levelUp()
            } else {
                AppFeedback.complete()
            }
        }
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

struct StreakPopupView: View {
    let text: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .font(AppFont.subtitle(12))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule().fill(AppTheme.xpGold)
        )
        .shadow(color: AppTheme.xpGold.opacity(0.35), radius: 8, x: 0, y: 4)
    }
}

struct SparkleBurstView: View {
    let color: Color
    @State private var animate = false

    private let offsets: [CGSize] = [
        CGSize(width: -22, height: -10),
        CGSize(width: 18, height: -18),
        CGSize(width: -26, height: 8),
        CGSize(width: 22, height: 10),
        CGSize(width: -8, height: 24),
        CGSize(width: 12, height: 26)
    ]

    var body: some View {
        ZStack {
            ForEach(offsets.indices, id: \.self) { index in
                Circle()
                    .fill(color.opacity(0.9))
                    .frame(width: 6, height: 6)
                    .scaleEffect(animate ? 0.4 : 0.1)
                    .opacity(animate ? 0 : 1)
                    .offset(animate ? offsets[index] : .zero)
                    .animation(.easeOut(duration: 0.9).delay(Double(index) * 0.04), value: animate)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ChallengeRow: View {
    let title: String
    let isComplete: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isComplete ? AppTheme.safetyGreen : AppTheme.charcoal.opacity(0.4))
            Text(title)
                .font(AppFont.body(12))
                .foregroundColor(AppTheme.charcoal.opacity(0.75))
            Spacer()
        }
    }
}

struct FormFieldLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .font(AppFont.subtitle(14))
            .foregroundColor(AppTheme.charcoal)
    }
}

struct AppTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .font(AppFont.body(13))
            .foregroundColor(AppTheme.charcoal)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.95))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
    }
}

struct AppTextEditor: View {
    @Binding var text: String
    var height: CGFloat = 80

    var body: some View {
        TextEditor(text: $text)
            .font(AppFont.body(13))
            .foregroundColor(AppTheme.charcoal)
            .scrollContentBackground(.hidden)
            .frame(height: height)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.95))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
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

            GlassCard(fullWidth: false) {
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
