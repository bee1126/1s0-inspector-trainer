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
