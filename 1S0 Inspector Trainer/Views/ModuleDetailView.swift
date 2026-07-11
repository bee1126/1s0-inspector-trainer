import SwiftUI

struct ModuleDetailView: View {
    @EnvironmentObject private var progress: ProgressStore
    let module: TrainingModule
    private var integrityIssues: [ModuleIntegrityIssue] { module.integrityIssues }
    private var canStartModule: Bool { integrityIssues.isEmpty }

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

                    if !canStartModule {
                        GlassCard(glow: AppTheme.danger.opacity(0.5)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("MODULE INCOMPLETE")
                                    .font(AppFont.mono(11))
                                    .foregroundColor(AppTheme.danger)
                                ForEach(integrityIssues) { issue in
                                    Text("• \(issue.message)")
                                        .font(AppFont.body(13))
                                        .foregroundColor(AppTheme.muted)
                                }
                            }
                        }
                    }

                    NavigationLink {
                        ModuleFlowView(module: module)
                    } label: {
                        HStack {
                            Text(progress.isCompleted(module.id) ? "Run Training Again" : "Start Training Mission")
                            Spacer()
                            Image(systemName: "play.fill")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!canStartModule)

                    if progress.resumeState(for: module.id) != nil {
                        NavigationLink {
                            ModuleFlowView(module: module)
                        } label: {
                            HStack {
                                Text("Resume Current Run")
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                            }
                        }
                        .buttonStyle(OutlineButtonStyle())
                        .disabled(!canStartModule)
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("REWARDS")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                            Text("Up to \(maxXp) XP")
                                .font(AppFont.title(22))
                                .foregroundColor(AppTheme.accent)
                            Text("Test your knowledge with scenarios and quizzes.")
                                .font(AppFont.body(12))
                                .foregroundColor(AppTheme.muted)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Rewards")
                        .accessibilityValue("Up to \(maxXp) experience points")
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
