import SwiftUI

struct ModuleListView: View {
    @EnvironmentObject private var progress: ProgressStore
    private let modules = TrainingContent.modules

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.stack) {
                    Text("Training Modules")
                        .font(AppFont.title(26))
                        .foregroundColor(.white)

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
                            .foregroundColor(AppTheme.charcoal)
                        Text(module.subtitle)
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.charcoal.opacity(0.7))
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
