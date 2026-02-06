import SwiftUI

struct ModuleListView: View {
    @EnvironmentObject private var progress: ProgressStore
    private var modules: [TrainingModule] {
        TrainingContent.modules(for: progress.selectedRole)
    }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.stack) {
                    Text("Training Modules")
                        .font(AppFont.title(26))
                        .foregroundColor(AppTheme.text)

                    ForEach(modules, id: \.id) { module in
                        NavigationLink {
                            ModuleDetailView(module: module)
                        } label: {
                            ModuleCardView(module: module, score: progress.bestScore(for: module.id))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Modules")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ModuleCardView: View {
    let module: TrainingModule
    let score: Int

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(module.title)
                            .font(AppFont.subtitle(18))
                            .foregroundColor(AppTheme.text)
                        Text(module.subtitle)
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.muted)
                    }
                    Spacer()
                    if score > 0 {
                        ScoreBadge(score: score)
                    }
                }

                HStack(spacing: 12) {
                    TagPill(text: "\(module.estimatedMinutes) min")
                    TagPill(text: module.difficulty)
                    if let tag = module.tags.first {
                        TagPill(text: tag)
                    }
                }
            }
        }
    }
}
