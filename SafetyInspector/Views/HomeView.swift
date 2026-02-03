import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var progress: ProgressStore
    private let modules = TrainingContent.modules

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Safety Inspector Trainer")
                                .font(AppFont.title(28))
                                .foregroundColor(.white)
                            Text("Level up your inspection skills with daily practice.")
                                .font(AppFont.body(15))
                                .foregroundColor(Color.white.opacity(0.85))
                        }
                        Spacer()
                        XPProgressRing(progress: progress.levelProgress, level: progress.level, size: 64)
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Daily Goal")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)

                            Text("\(progress.dailyXp)/\(progress.dailyGoal) XP today")
                                .font(AppFont.body(14))
                                .foregroundColor(AppTheme.charcoal.opacity(0.8))

                            ProgressView(value: progress.dailyGoalProgress)
                                .tint(AppTheme.xpGold)

                            HStack(spacing: 8) {
                                StatPill(title: "Streak", value: "\(progress.dailyStreak) days", tint: AppTheme.xpGold)
                                StatPill(title: "Hearts", value: "\(progress.hearts)/\(progress.maxHearts)", tint: AppTheme.heartRed)
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

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Practice Zone")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)
                            Text("Earn XP, restore hearts, and keep your streak alive.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.charcoal.opacity(0.7))

                            NavigationLink {
                                PracticeSessionView()
                            } label: {
                                HStack {
                                    Text("Start Practice")
                                    Spacer()
                                    Image(systemName: "bolt.fill")
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
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
        .onAppear {
            progress.refreshForNewDayIfNeeded()
        }
    }
}
