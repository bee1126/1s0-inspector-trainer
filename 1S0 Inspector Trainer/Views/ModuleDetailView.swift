import SwiftUI

struct ModuleDetailView: View {
    @EnvironmentObject private var progress: ProgressStore
    let module: TrainingModule

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(module.title)
                                .font(AppFont.title(24))
                                .foregroundColor(AppTheme.text)
                            Text(module.subtitle)
                                .font(AppFont.body(14))
                                .foregroundColor(AppTheme.muted)

                            HStack(spacing: 10) {
                                TagPill(text: "\(module.estimatedMinutes) min")
                                TagPill(text: module.difficulty)
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("OBJECTIVES")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                            ForEach(module.objectives, id: \.self) { objective in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("-")
                                        .font(AppFont.subtitle(14))
                                        .foregroundColor(AppTheme.primary)
                                    Text(objective)
                                        .font(AppFont.body(14))
                                        .foregroundColor(AppTheme.text.opacity(0.8))
                                }
                            }
                        }
                    }

                    NavigationLink {
                        ModuleFlowView(module: module)
                    } label: {
                        HStack {
                            Text(progress.isCompleted(module.id) ? "Run Again" : "Start Module")
                            Spacer()
                            Image(systemName: "play.fill")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    if progress.resumeState(for: module.id) != nil {
                        NavigationLink {
                            ModuleFlowView(module: module)
                        } label: {
                            HStack {
                                Text("Continue")
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                            }
                        }
                        .buttonStyle(OutlineButtonStyle())
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("REWARDS")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                            Text("Up to \(maxXp) XP")
                                .font(AppFont.title(22))
                                .foregroundColor(AppTheme.xpGold)
                            Text("Mistakes cost a heart. Practice restores hearts.")
                                .font(AppFont.body(12))
                                .foregroundColor(AppTheme.muted)
                        }
                    }

                    if progress.isCompleted(module.id) {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("BEST SCORE")
                                    .font(AppFont.mono(11))
                                    .foregroundColor(AppTheme.muted)
                                Text("\(progress.bestScore(for: module.id))%")
                                    .font(AppFont.title(30))
                                    .foregroundColor(AppTheme.info)
                            }
                        }
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle(module.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var maxXp: Int {
        let scenarioMax = module.scenario.steps.count
        let quizMax = min(module.quiz.count, 10)
        return 12 + scenarioMax * 8 + quizMax * 6 + 30
    }
}
