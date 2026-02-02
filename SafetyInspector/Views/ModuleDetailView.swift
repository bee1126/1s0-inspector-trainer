import SwiftUI

struct ModuleDetailView: View {
    @EnvironmentObject private var progress: ProgressStore
    let module: TrainingModule

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(module.title)
                                .font(AppFont.title(24))
                                .foregroundColor(AppTheme.charcoal)
                            Text(module.subtitle)
                                .font(AppFont.body(14))
                                .foregroundColor(AppTheme.charcoal.opacity(0.7))

                            HStack(spacing: 10) {
                                TagPill(text: "\(module.estimatedMinutes) min")
                                TagPill(text: module.difficulty)
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Objectives")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)
                            ForEach(module.objectives, id: \.self) { objective in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("-")
                                        .font(AppFont.subtitle(14))
                                        .foregroundColor(AppTheme.safetyGreen)
                                    Text(objective)
                                        .font(AppFont.body(14))
                                        .foregroundColor(AppTheme.charcoal.opacity(0.8))
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

                    if progress.isCompleted(module.id) {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Best Score")
                                    .font(AppFont.subtitle(16))
                                    .foregroundColor(AppTheme.charcoal)
                                Text("\(progress.bestScore(for: module.id))%")
                                    .font(AppFont.title(30))
                                    .foregroundColor(AppTheme.blue)
                            }
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle(module.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
