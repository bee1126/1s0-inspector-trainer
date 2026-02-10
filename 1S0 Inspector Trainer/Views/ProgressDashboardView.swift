import SwiftUI

struct ProgressDashboardView: View {
    @EnvironmentObject private var progress: ProgressStore
    @EnvironmentObject private var adaptiveManager: AdaptiveDifficultyManager
    private var modules: [TrainingModule] {
        TrainingContent.modules(for: progress.selectedRole)
    }
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
                    Text("PROGRESS")
                        .font(AppFont.mono(13))
                        .foregroundColor(AppTheme.muted)
                        .tracking(2)

                    // MARK: - Level / XP Card
                    GlassCard {
                        HStack(alignment: .center, spacing: 16) {
                            XPProgressRing(progress: progress.levelProgress, level: progress.level)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Level \(progress.level)")
                                    .font(AppFont.subtitle(18))
                                    .foregroundColor(AppTheme.text)
                                Text("\(progress.xp) XP total")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)
                                Text("\(progress.xpToNextLevel) XP to next level")
                                    .font(AppFont.mono(11))
                                    .foregroundColor(AppTheme.muted)
                            }
                            Spacer()
                        }
                    }

                    // MARK: - Daily Goal Card
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("DAILY GOAL")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                                .tracking(1.5)
                            Text("\(progress.dailyXp)/\(progress.dailyGoal) XP today")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.text)
                            ProgressView(value: progress.dailyGoalProgress)
                                .tint(AppTheme.accent)

                            HStack {
                                Text("Streak: \(progress.dailyStreak) days")
                                    .font(AppFont.mono(12))
                                    .foregroundColor(AppTheme.accent)
                                Spacer()
                                HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, onDark: true)
                            }

                            HStack(spacing: 6) {
                                Text("Adaptive Level:")
                                    .font(AppFont.body(12))
                                    .foregroundColor(AppTheme.muted)
                                Text(adaptiveManager.currentDifficulty == .hard ? "Hard" : "Standard")
                                    .font(AppFont.mono(12))
                                    .foregroundColor(adaptiveManager.currentDifficulty == .hard ? AppTheme.accent : AppTheme.muted)
                            }
                        }
                    }

                    // MARK: - Review Queue
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("REVIEW QUEUE")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                                .tracking(1.5)
                            Text("\(progress.overdueCount())")
                                .font(AppFont.title(28))
                                .foregroundColor(AppTheme.accent)
                            Text("cards due for review")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.accent)
                        }
                    }

                    // MARK: - Overall Readiness Card
                    GlassCard(glow: AppTheme.primary.opacity(0.3)) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("OVERALL READINESS")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                                .tracking(1.5)
                            ProgressView(value: completionRate)
                                .tint(AppTheme.primary)
                            Text("\(completedCount) of \(modules.count) modules completed")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.text)

                            HStack(spacing: 6) {
                                Image(systemName: "shield.checkered")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(AppTheme.accent)
                                Text("Current Rank:")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)
                                Text(rankTitle)
                                    .font(AppFont.mono(14))
                                    .foregroundColor(AppTheme.accent)
                            }

                            if completedCount < modules.count {
                                HStack(spacing: 6) {
                                    Image(systemName: "chevron.right.2")
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundColor(AppTheme.primary)
                                    Text("Projected:")
                                        .font(AppFont.body(12))
                                        .foregroundColor(AppTheme.muted)
                                    Text(projectedRankTitle)
                                        .font(AppFont.mono(12))
                                        .foregroundColor(AppTheme.primary)
                                }
                            }
                        }
                    }

                    // MARK: - Module Status Card
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("MODULE STATUS")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                                .tracking(1.5)

                            ForEach(modules.indices, id: \.self) { index in
                                let module = modules[index]
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(module.title)
                                            .font(AppFont.subtitle(15))
                                            .foregroundColor(AppTheme.text)
                                        Text(progress.isCompleted(module.id) ? "Completed" : "Not started")
                                            .font(AppFont.mono(11))
                                            .foregroundColor(
                                                progress.isCompleted(module.id)
                                                    ? AppTheme.primary
                                                    : AppTheme.muted
                                            )
                                        if let date = progress.lastCompletionDate(for: module.id) {
                                            Text("Last completed \(dateFormatter.string(from: date))")
                                                .font(AppFont.body(11))
                                                .foregroundColor(AppTheme.muted)
                                        }
                                    }
                                    Spacer()
                                    if progress.isCompleted(module.id) {
                                        ScoreBadge(score: progress.bestScore(for: module.id))
                                    }
                                }
                                if index < modules.count - 1 {
                                    Divider()
                                        .background(AppTheme.border)
                                        .opacity(0.5)
                                }
                            }
                        }
                    }

                    // MARK: - Module Proficiency
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("MODULE PROFICIENCY")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                                .tracking(1.5)

                            ForEach(moduleProficiencyRows) { row in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(row.title)
                                            .font(AppFont.body(13))
                                            .foregroundColor(AppTheme.text)
                                        Spacer()
                                        Text("\(Int(round(row.recentAccuracy * 100)))%")
                                            .font(AppFont.mono(11))
                                            .foregroundColor(proficiencyColor(for: row.recentAccuracy))
                                    }

                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                .fill(AppTheme.border)
                                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                .fill(proficiencyColor(for: row.recentAccuracy))
                                                .frame(width: geometry.size.width * min(max(row.recentAccuracy, 0), 1))
                                        }
                                    }
                                    .frame(height: 8)
                                }
                            }
                        }
                    }

                    // MARK: - Badges
                    VStack(alignment: .leading, spacing: 10) {
                        Text("BADGES")
                            .font(AppFont.mono(11))
                            .foregroundColor(AppTheme.muted)
                            .tracking(1.5)

                        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(badges, id: \.id) { badge in
                                MissionBadge(
                                    icon: badge.icon,
                                    title: badge.title,
                                    earned: badge.isEarned
                                )
                            }
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

    // MARK: - Computed Properties

    private var completedCount: Int {
        modules.filter { progress.isCompleted($0.id) }.count
    }

    private var completionRate: Double {
        guard !modules.isEmpty else { return 0 }
        return Double(completedCount) / Double(modules.count)
    }

    private var moduleProficiencyRows: [ModuleProficiencyRow] {
        modules
            .map { module in
                let prefix = modulePrefix(for: module.quiz.first?.id ?? module.id)
                let recentAccuracy = progress.moduleProficiency[prefix]?.recentAccuracy ?? 0
                return ModuleProficiencyRow(id: prefix, title: module.title, recentAccuracy: recentAccuracy)
            }
            .sorted { $0.recentAccuracy < $1.recentAccuracy }
    }

    private var badges: [BadgeState] {
        let perfectScores = modules.filter { progress.bestScore(for: $0.id) >= 90 }.count
        return [
            BadgeState(
                id: "first-completion",
                icon: "star.fill",
                title: "First Mission",
                detail: "Complete your first module",
                isEarned: completedCount >= 1
            ),
            BadgeState(
                id: "full-crew",
                icon: "person.3.fill",
                title: "Full Crew",
                detail: "Complete all modules",
                isEarned: completedCount == modules.count && !modules.isEmpty
            ),
            BadgeState(
                id: "precision",
                icon: "scope",
                title: "Precision Operator",
                detail: "Score 90% or higher on any module",
                isEarned: perfectScores >= 1
            ),
            BadgeState(
                id: "ace",
                icon: "shield.checkered",
                title: "Safety Ace",
                detail: "Score 90% or higher on all modules",
                isEarned: perfectScores == modules.count && !modules.isEmpty
            ),
            BadgeState(
                id: "scenario-master",
                icon: "theatermasks.fill",
                title: "Scenario Master",
                detail: "Perfect scenario run on any module",
                isEarned: !progress.perfectScenario.isEmpty
            ),
            BadgeState(
                id: "quiz-sharp",
                icon: "bolt.fill",
                title: "Quiz Sharp",
                detail: "Perfect quiz on any module",
                isEarned: !progress.perfectQuiz.isEmpty
            ),
            BadgeState(
                id: "streak-starter",
                icon: "flame.fill",
                title: "Streak Starter",
                detail: "Maintain a 3-day daily goal streak",
                isEarned: progress.dailyStreak >= 3
            ),
            BadgeState(
                id: "streak-veteran",
                icon: "flame.circle.fill",
                title: "Streak Veteran",
                detail: "Maintain a 7-day daily goal streak",
                isEarned: progress.dailyStreak >= 7
            ),
            BadgeState(
                id: "xp-collector",
                icon: "sparkles",
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

    private func proficiencyColor(for accuracy: Double) -> Color {
        if accuracy >= 0.7 {
            return AppTheme.primary
        }
        if accuracy >= 0.5 {
            return AppTheme.accent
        }
        return AppTheme.danger
    }

    private func modulePrefix(for questionId: String) -> String {
        let components = questionId.split(separator: "-")
        guard components.count > 1 else { return questionId }
        return components.dropLast().joined(separator: "-")
    }
}

struct BadgeState: Identifiable {
    let id: String
    let icon: String
    let title: String
    let detail: String
    let isEarned: Bool
}

struct ModuleProficiencyRow: Identifiable {
    let id: String
    let title: String
    let recentAccuracy: Double
}
