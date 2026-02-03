import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var progress: ProgressStore
    private let modules = TrainingContent.modules

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1S0 Inspector Trainer")
                            .font(AppFont.title(28))
                            .foregroundColor(.white)
                        Text("Interactive safety training for Air Force 1S0 inspectors")
                            .font(AppFont.body(15))
                            .foregroundColor(Color.white.opacity(0.85))
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mission Brief")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)

                            Text("Build habits that prevent accidents and keep teams mission-ready. Work through scenarios, quick checks, and score-based progression.")
                                .font(AppFont.body(14))
                                .foregroundColor(AppTheme.charcoal.opacity(0.8))

                            HStack(spacing: 8) {
                                TagPill(text: "On-device")
                                TagPill(text: "Scenario-driven")
                                TagPill(text: "Standards aligned")
                            }
                        }
                    }

                    GlassCard {
                        Image("SafetyHero")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 160)
                            .clipped()
                            .cornerRadius(16)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Training Modules")
                            .font(AppFont.subtitle(18))
                            .foregroundColor(.white)

                        Text("\(modules.count) modules available")
                            .font(AppFont.body(12))
                            .foregroundColor(Color.white.opacity(0.7))

                        ForEach(modules, id: \.id) { module in
                            NavigationLink {
                                ModuleDetailView(module: module)
                            } label: {
                                ModuleCardView(module: module, score: progress.bestScore(for: module.id))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Text("Not an official Air Force product. Training aids only.")
                        .font(AppFont.body(12))
                        .foregroundColor(Color.white.opacity(0.75))
                        .padding(.top, 10)
                }
                .padding(20)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}
