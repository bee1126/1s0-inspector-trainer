import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var progress: ProgressStore
    private var modules: [TrainingModule] {
        TrainingContent.modules(for: progress.selectedRole)
    }
    private var resumeModule: TrainingModule? {
        guard let resume = progress.resumeState else { return nil }
        return modules.first(where: { $0.id == resume.moduleId })
    }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(progress.selectedRole?.appTitle ?? "Inspector Trainer")
                                .font(AppFont.title(28))
                                .foregroundColor(.white)
                            Text(progress.selectedRole?.homeSubtitle ?? "Level up your inspection skills with daily practice.")
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
                        VStack(alignment: .leading, spacing: 10) {
                            Text("New Trainee Path")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)

                            Text("7-day starter program with daily check-ins.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.charcoal.opacity(0.7))

                            ProgressView(value: onboardingProgress)
                                .tint(AppTheme.safetyGreen)

                            Text("\(onboardingCompleted)/\(onboardingTotal) check-ins")
                                .font(AppFont.body(12))
                                .foregroundColor(AppTheme.charcoal.opacity(0.6))

                            if let dayNumber = onboardingDayNumber {
                                Text("Day \(dayNumber) of \(onboardingTotal)")
                                    .font(AppFont.body(12))
                                    .foregroundColor(AppTheme.blue)
                            }

                            NavigationLink {
                                OnboardingPathView()
                            } label: {
                                HStack {
                                    Text("Open Starter Path")
                                    Spacer()
                                    Image(systemName: "calendar")
                                }
                            }
                            .buttonStyle(OutlineButtonStyle())
                        }
                    }

                    if let resumeModule {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Continue Training")
                                    .font(AppFont.subtitle(18))
                                    .foregroundColor(AppTheme.charcoal)
                                Text(resumeModule.title)
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
                                NavigationLink {
                                    ModuleFlowView(module: resumeModule)
                                } label: {
                                    HStack {
                                        Text("Continue")
                                        Spacer()
                                        Image(systemName: "arrow.right.circle.fill")
                                    }
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Practice Zone")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)
                            Text("Earn XP, restore hearts, and keep your streak alive.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.charcoal.opacity(0.7))
                            VStack(spacing: 10) {
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

                                NavigationLink {
                                    PracticeSessionView(mode: .dailyFive)
                                } label: {
                                    HStack {
                                        Text("Daily 5")
                                        Spacer()
                                        Image(systemName: "checkmark.seal.fill")
                                    }
                                }
                                .buttonStyle(OutlineButtonStyle())

                                NavigationLink {
                                    MatchingDeckSelectionView()
                                } label: {
                                    HStack {
                                        Text("Match Sprint")
                                        Spacer()
                                        Image(systemName: "timer")
                                    }
                                }
                                .buttonStyle(OutlineButtonStyle())

                                NavigationLink {
                                    TrueFalseBlitzView()
                                } label: {
                                    HStack {
                                        Text("True/False Blitz")
                                        Spacer()
                                        Image(systemName: "bolt.circle")
                                    }
                                }
                                .buttonStyle(OutlineButtonStyle())

                                NavigationLink {
                                    SequenceBuilderSelectionView()
                                } label: {
                                    HStack {
                                        Text("Sequence Builder")
                                        Spacer()
                                        Image(systemName: "arrow.up.arrow.down.square")
                                    }
                                }
                                .buttonStyle(OutlineButtonStyle())

                                NavigationLink {
                                    RacSortView()
                                } label: {
                                    HStack {
                                        Text("RAC Sort")
                                        Spacer()
                                        Image(systemName: "square.grid.2x2")
                                    }
                                }
                                .buttonStyle(OutlineButtonStyle())

                                NavigationLink {
                                    MicroDrillSelectionView()
                                } label: {
                                    HStack {
                                        Text("Micro-Drills")
                                        Spacer()
                                        Image(systemName: "scope")
                                    }
                                }
                                .buttonStyle(OutlineButtonStyle())
                            }
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
                        .padding(.top, AppSpacing.item)
                }
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            progress.refreshForNewDayIfNeeded()
        }
    }

    private var onboardingTotal: Int {
        PracticeContent.onboardingDays.count
    }

    private var onboardingCompleted: Int {
        progress.onboardingCheckIns.count
    }

    private var onboardingProgress: Double {
        guard onboardingTotal > 0 else { return 0 }
        return Double(onboardingCompleted) / Double(onboardingTotal)
    }

    private var onboardingDayNumber: Int? {
        progress.onboardingDayNumber()
    }
}
