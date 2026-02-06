import SwiftUI

struct RoleSelectionView: View {
    let title: String
    let subtitle: String
    let onSelect: (TrainingRole) -> Void

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(alignment: .leading, spacing: AppSpacing.section) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(AppFont.title(26))
                        .foregroundColor(AppTheme.text)
                    Text(subtitle)
                        .font(AppFont.body(14))
                        .foregroundColor(AppTheme.muted)
                }

                VStack(spacing: 12) {
                    ForEach(TrainingRole.allCases) { role in
                        Button {
                            onSelect(role)
                        } label: {
                            RoleCard(role: role)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Spacer()
            }
            .padding(AppSpacing.screenPadding)
        }
    }
}

private struct RoleCard: View {
    let role: TrainingRole

    var body: some View {
        GlassCard(glow: AppTheme.primary) {
            VStack(alignment: .leading, spacing: 8) {
                Text(role.shortName)
                    .font(AppFont.subtitle(18))
                    .foregroundColor(AppTheme.text)
                Text(role.displayName)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.muted)
                Text(role.lessonContext)
                    .font(AppFont.body(12))
                    .foregroundColor(AppTheme.muted.opacity(0.8))
            }
        }
    }
}
