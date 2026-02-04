import SwiftUI

struct ProgressDashboardView: View {
    @EnvironmentObject private var progress: ProgressStore
    private let modules = TrainingContent.modules
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text("Progress")
                        .font(AppFont.title(26))
                        .foregroundColor(.white)

                    GlassCard {
                        HStack(alignment: .center, spacing: 16) {
                            XPProgressRing(progress: progress.levelProgress, level: progress.level, size: 72, onDark: false)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Level \(progress.level)")
                                    .font(AppFont.subtitle(18))
                                    .foregroundColor(AppTheme.charcoal)
                                Text("\(progress.xp) XP total")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
                                Text("\(progress.xpToNextLevel) XP to next level")
                                    .font(AppFont.body(12))
                                    .foregroundColor(AppTheme.charcoal.opacity(0.6))
                            }
                            Spacer()
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Daily Goal")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)
                            Text("\(progress.dailyXp)/\(progress.dailyGoal) XP today")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.charcoal.opacity(0.7))
                            ProgressView(value: progress.dailyGoalProgress)
                                .tint(AppTheme.xpGold)

                            HStack {
                                Text("Streak: \(progress.dailyStreak) days")
                                    .font(AppFont.body(12))
                                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
                                Spacer()
                                HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, onDark: false)
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Overall Readiness")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)
                            ProgressView(value: completionRate)
                                .tint(AppTheme.safetyGreen)
                            Text("\(completedCount) of \(modules.count) modules completed")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.charcoal.opacity(0.7))
                            Text("Current Rank: \(rankTitle)")
                                .font(AppFont.subtitle(15))
                                .foregroundColor(AppTheme.blue)
                            if completedCount < modules.count {
                                Text("Projected Rank (next completion): \(projectedRankTitle)")
                                    .font(AppFont.body(12))
                                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Module Status")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)

                            ForEach(modules.indices, id: \.self) { index in
                                let module = modules[index]
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(module.title)
                                            .font(AppFont.subtitle(15))
                                            .foregroundColor(AppTheme.charcoal)
                                        Text(progress.isCompleted(module.id) ? "Completed" : "Not started")
                                            .font(AppFont.body(12))
                                            .foregroundColor(AppTheme.charcoal.opacity(0.6))
                                        if let date = progress.lastCompletionDate(for: module.id) {
                                            Text("Last completed \(dateFormatter.string(from: date))")
                                                .font(AppFont.body(11))
                                                .foregroundColor(AppTheme.charcoal.opacity(0.55))
                                        }
                                    }
                                    Spacer()
                                    if progress.isCompleted(module.id) {
                                        ScoreBadge(score: progress.bestScore(for: module.id))
                                    }
                                }
                                if index < modules.count - 1 {
                                    Divider().opacity(0.3)
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Badges")
                            .font(AppFont.subtitle(18))
                            .foregroundColor(.white)

                        ForEach(badges, id: \.id) { badge in
                            MissionBadge(title: badge.title, detail: badge.detail, isEarned: badge.isEarned)
                        }
                    }

                    Button("Reset Progress") {
                        progress.resetAll()
                    }
                    .buttonStyle(OutlineButtonStyle())
                }
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            progress.refreshForNewDayIfNeeded()
        }
    }

    private var completedCount: Int {
        modules.filter { progress.isCompleted($0.id) }.count
    }

    private var completionRate: Double {
        guard !modules.isEmpty else { return 0 }
        return Double(completedCount) / Double(modules.count)
    }

    private var badges: [BadgeState] {
        let perfectScores = modules.filter { progress.bestScore(for: $0.id) >= 90 }.count
        return [
            BadgeState(
                id: "first-completion",
                title: "First Mission",
                detail: "Complete your first module",
                isEarned: completedCount >= 1
            ),
            BadgeState(
                id: "full-crew",
                title: "Full Crew",
                detail: "Complete all modules",
                isEarned: completedCount == modules.count && !modules.isEmpty
            ),
            BadgeState(
                id: "precision",
                title: "Precision Operator",
                detail: "Score 90% or higher on any module",
                isEarned: perfectScores >= 1
            ),
            BadgeState(
                id: "ace",
                title: "Safety Ace",
                detail: "Score 90% or higher on all modules",
                isEarned: perfectScores == modules.count && !modules.isEmpty
            ),
            BadgeState(
                id: "scenario-master",
                title: "Scenario Master",
                detail: "Perfect scenario run on any module",
                isEarned: !progress.perfectScenario.isEmpty
            ),
            BadgeState(
                id: "quiz-sharp",
                title: "Quiz Sharp",
                detail: "Perfect quiz on any module",
                isEarned: !progress.perfectQuiz.isEmpty
            ),
            BadgeState(
                id: "streak-starter",
                title: "Streak Starter",
                detail: "Maintain a 3-day daily goal streak",
                isEarned: progress.dailyStreak >= 3
            ),
            BadgeState(
                id: "streak-veteran",
                title: "Streak Veteran",
                detail: "Maintain a 7-day daily goal streak",
                isEarned: progress.dailyStreak >= 7
            ),
            BadgeState(
                id: "xp-collector",
                title: "XP Collector",
                detail: "Earn 500 total XP",
                isEarned: progress.xp >= 500
            )
        ]
    }

    private var projectedRankTitle: String {
        let projected = min(completedCount + 1, modules.count)
        return rankTitle(for: projected)
    }

    private var rankTitle: String {
        rankTitle(for: completedCount)
    }

    private func rankTitle(for completed: Int) -> String {
        switch completed {
        case 0:
            return "Trainee"
        case 1...2:
            return "Airman"
        case 3...5:
            return "Inspector"
        case 6...8:
            return "Lead Inspector"
        default:
            return "Safety Advisor"
        }
    }
}

struct BadgeState: Identifiable {
    let id: String
    let title: String
    let detail: String
    let isEarned: Bool
}
