import SwiftUI

struct ProgressDashboardView: View {
    @EnvironmentObject private var progress: ProgressStore
    @EnvironmentObject private var adaptiveManager: AdaptiveDifficultyManager
    @State private var showResetAlert = false

    private var modules: [TrainingModule] {
        TrainingContent.modules(for: progress.selectedRole)
    }

    private var missionFocusRecommendation: MissionFocusRecommendation {
        MissionFocusRecommendation.make(modules: modules, progress: progress)
    }

    private static let dateFormatter: DateFormatter = {
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
                    Text("MISSION READINESS")
                        .font(AppFont.mono(13))
                        .foregroundColor(AppTheme.muted)
                        .tracking(2)

                    GlassCard {
                        HStack(spacing: 16) {
                            readinessMetric(title: "Modules", value: "\(completedCount)/\(modules.count)", tint: AppTheme.primary)
                            readinessMetric(title: "Review Due", value: "\(progress.overdueCount())", tint: AppTheme.accent)
                            readinessMetric(title: "Streak", value: "\(progress.dailyStreak)d", tint: AppTheme.accent)
                        }
                    }

                    GlassCard(glow: missionFocusRecommendation.priority.tint.opacity(0.45)) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: missionFocusRecommendation.priority.iconName)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(missionFocusRecommendation.priority.tint)
                                Text("MISSION FOCUS")
                                    .font(AppFont.mono(11))
                                    .foregroundColor(AppTheme.muted)
                                    .tracking(1.5)
                            }

                            Text(missionFocusRecommendation.title)
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.text)

                            Text(missionFocusRecommendation.detail)
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.muted)

                            if !missionFocusRecommendation.supportingMetrics.isEmpty {
                                HStack(spacing: 8) {
                                    ForEach(Array(missionFocusRecommendation.supportingMetrics.enumerated()), id: \.offset) { _, metric in
                                        TagPill(text: metric)
                                    }
                                }
                            }

                            missionFocusAction(for: missionFocusRecommendation)
                        }
                    }

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
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel(AccessibilityCopy.progressLabel(name: "Daily goal", current: progress.dailyXp, total: progress.dailyGoal))
                                .accessibilityValue(AccessibilityCopy.progressValue(current: progress.dailyXp, total: progress.dailyGoal))

                            HStack {
                                Text("Streak: \(progress.dailyStreak) days")
                                    .font(AppFont.mono(12))
                                    .foregroundColor(AppTheme.accent)
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
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel(AccessibilityCopy.progressLabel(name: "Overall readiness", current: completedCount, total: modules.count))
                                .accessibilityValue(AccessibilityCopy.progressValue(current: completedCount, total: modules.count))
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

                            ForEach(Array(prioritizedModules.enumerated()), id: \.element.id) { index, module in
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
                                            Text("Last completed \(Self.dateFormatter.string(from: date))")
                                                .font(AppFont.body(11))
                                                .foregroundColor(AppTheme.muted)
                                        }
                                    }
                                    Spacer()
                                    if progress.isCompleted(module.id) {
                                        ScoreBadge(score: progress.bestScore(for: module.id))
                                    }
                                }
                                if index < prioritizedModules.count - 1 {
                                    Divider()
                                        .background(AppTheme.border)
                                        .opacity(0.5)
                                }
                            }
                            if modules.count > prioritizedModules.count {
                                Text("Showing \(prioritizedModules.count) of \(modules.count) modules")
                                    .font(AppFont.body(12))
                                    .foregroundColor(AppTheme.muted)
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
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel("Module proficiency")
                                    .accessibilityValue("\(Int(round(row.recentAccuracy * 100))) percent")
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
                        showResetAlert = true
                    }
                    .buttonStyle(OutlineButtonStyle())
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            progress.refreshForNewDayIfNeeded()
        }
        .alert("Reset All Progress?", isPresented: $showResetAlert) {
            Button("Reset", role: .destructive) {
                progress.resetAll()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will erase all training data, scores, streaks, and XP. This cannot be undone.")
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
                let prefix = ModuleHelper.modulePrefix(for: module.quiz.first?.id ?? module.id)
                let recentAccuracy = progress.moduleProficiency[prefix]?.recentAccuracy ?? 0
                return ModuleProficiencyRow(id: prefix, title: module.title, recentAccuracy: recentAccuracy)
            }
            .sorted { $0.recentAccuracy < $1.recentAccuracy }
    }

    private var prioritizedModules: [TrainingModule] {
        let sorted = modules.sorted { lhs, rhs in
            let lhsCompleted = progress.isCompleted(lhs.id)
            let rhsCompleted = progress.isCompleted(rhs.id)
            if lhsCompleted == rhsCompleted { return lhs.title < rhs.title }
            return !lhsCompleted && rhsCompleted
        }
        return Array(sorted.prefix(8))
    }

    private var badges: [BadgeState] {
        let perfectScores = modules.filter { progress.bestScore(for: $0.id) >= 90 }.count
        return [
            BadgeState(
                id: "first-completion",
                icon: "star.fill",
                title: "First Mission",
                isEarned: completedCount >= 1
            ),
            BadgeState(
                id: "full-crew",
                icon: "person.3.fill",
                title: "Full Crew",
                isEarned: completedCount == modules.count && !modules.isEmpty
            ),
            BadgeState(
                id: "precision",
                icon: "scope",
                title: "Precision Operator",
                isEarned: perfectScores >= 1
            ),
            BadgeState(
                id: "ace",
                icon: "shield.checkered",
                title: "Safety Ace",
                isEarned: perfectScores == modules.count && !modules.isEmpty
            ),
            BadgeState(
                id: "scenario-master",
                icon: "theatermasks.fill",
                title: "Scenario Master",
                isEarned: !progress.perfectScenario.isEmpty
            ),
            BadgeState(
                id: "quiz-sharp",
                icon: "bolt.fill",
                title: "Quiz Sharp",
                isEarned: !progress.perfectQuiz.isEmpty
            ),
            BadgeState(
                id: "streak-starter",
                icon: "flame.fill",
                title: "Streak Starter",
                isEarned: progress.dailyStreak >= 3
            ),
            BadgeState(
                id: "streak-veteran",
                icon: "flame.circle.fill",
                title: "Streak Veteran",
                isEarned: progress.dailyStreak >= 7
            ),
            BadgeState(
                id: "xp-collector",
                icon: "sparkles",
                title: "XP Collector",
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

    private func readinessMetric(title: String, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(AppFont.mono(10))
                .foregroundColor(AppTheme.muted)
            Text(value)
                .font(AppFont.subtitle(18))
                .foregroundColor(tint)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func missionFocusAction(for recommendation: MissionFocusRecommendation) -> some View {
        switch recommendation.destination {
        case .adaptiveMission:
            NavigationLink {
                PracticeSessionView()
            } label: {
                HStack {
                    Text(recommendation.buttonLabel)
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
        case .module(let moduleId):
            if let module = modules.first(where: { $0.id == moduleId }) {
                NavigationLink {
                    ModuleDetailView(module: module)
                } label: {
                    HStack {
                        Text(recommendation.buttonLabel)
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                }
                .buttonStyle(OutlineButtonStyle())
            }
        }
    }
}

struct BadgeState: Identifiable {
    let id: String
    let icon: String
    let title: String
    let isEarned: Bool
}

struct ModuleProficiencyRow: Identifiable {
    let id: String
    let title: String
    let recentAccuracy: Double
}

struct MissionFocusRecommendation: Equatable {
    enum Priority: Equatable {
        case reviewQueue
        case weakModule
        case nextModule
        case maintainReadiness

        var iconName: String {
            switch self {
            case .reviewQueue:
                return "clock.badge.exclamationmark.fill"
            case .weakModule:
                return "scope"
            case .nextModule:
                return "arrow.forward.circle.fill"
            case .maintainReadiness:
                return "shield.checkered"
            }
        }

        var tint: Color {
            switch self {
            case .reviewQueue:
                return AppTheme.accent
            case .weakModule:
                return AppTheme.danger
            case .nextModule:
                return AppTheme.primary
            case .maintainReadiness:
                return AppTheme.info
            }
        }
    }

    enum Destination: Equatable {
        case adaptiveMission
        case module(String)
    }

    let priority: Priority
    let title: String
    let detail: String
    let supportingMetrics: [String]
    let buttonLabel: String
    let destination: Destination

    static func make(modules: [TrainingModule], progress: ProgressStore) -> MissionFocusRecommendation {
        let validModules = modules.filter(\.isIntegrityValid)
        let overdueCountsByModule = progress.overdueCountsByModule()
        let totalDue = overdueCountsByModule.values.reduce(0, +)
        let moduleSnapshots: [ModuleSnapshot] = validModules.map { module in
            let prefix = ModuleHelper.modulePrefix(for: module.quiz.first?.id ?? module.id)
            return ModuleSnapshot(
                module: module,
                proficiency: progress.moduleProficiency[prefix],
                overdueCount: overdueCountsByModule[prefix, default: 0]
            )
        }

        if totalDue > 0 {
            let topReviewModule = moduleSnapshots
                .filter { $0.overdueCount > 0 }
                .sorted { left, right in
                    if left.overdueCount == right.overdueCount {
                        return left.module.title < right.module.title
                    }
                    return left.overdueCount > right.overdueCount
                }
                .first

            let detail: String
            if let topReviewModule {
                detail = "\(totalDue) review card\(totalDue == 1 ? "" : "s") due. \(topReviewModule.module.title) is the biggest backlog, so clear the queue before pushing into new material."
            } else {
                detail = "\(totalDue) review card\(totalDue == 1 ? "" : "s") due. Clear the queue before pushing into new material."
            }

            return MissionFocusRecommendation(
                priority: .reviewQueue,
                title: "Run Adaptive Mission",
                detail: detail,
                supportingMetrics: [
                    "\(totalDue) due",
                    progress.dailyFiveStreak > 0 ? "\(progress.dailyFiveStreak)d streak" : "Review queue"
                ],
                buttonLabel: "Start Review Run",
                destination: .adaptiveMission
            )
        }

        if let weakestModule = moduleSnapshots
            .filter({ ($0.proficiency?.totalAttempts ?? 0) > 0 })
            .sorted(by: weakerModuleFirst)
            .first,
           weakestModule.proficiency?.needsWork == true {
            let recentAccuracy = Int(round((weakestModule.proficiency?.recentAccuracy ?? 0) * 100))
            return MissionFocusRecommendation(
                priority: .weakModule,
                title: "Reinforce \(weakestModule.module.title)",
                detail: "Recent accuracy is \(recentAccuracy)% in this module. A focused refresher now will tighten the gap before it becomes a pattern.",
                supportingMetrics: [
                    "\(recentAccuracy)% recent",
                    "Best \(progress.bestScore(for: weakestModule.module.id))%"
                ],
                buttonLabel: "Open Refresher Module",
                destination: .module(weakestModule.module.id)
            )
        }

        if let nextModule = validModules.first(where: { !progress.isCompleted($0.id) }) {
            return MissionFocusRecommendation(
                priority: .nextModule,
                title: "Start \(nextModule.title)",
                detail: nextModule.subtitle,
                supportingMetrics: [
                    "\(nextModule.estimatedMinutes) min",
                    nextModule.difficulty
                ],
                buttonLabel: "Open Module",
                destination: .module(nextModule.id)
            )
        }

        return MissionFocusRecommendation(
            priority: .maintainReadiness,
            title: "Maintain Readiness",
            detail: "Core training is complete. Keep recall sharp with an adaptive mission built from your review history and weak spots.",
            supportingMetrics: [
                "\(progress.dailyFiveStreak)d streak",
                "Best \(progress.bestDailyFiveScore)%"
            ],
            buttonLabel: "Run Adaptive Mission",
            destination: .adaptiveMission
        )
    }

    private static func weakerModuleFirst(_ left: ModuleSnapshot, _ right: ModuleSnapshot) -> Bool {
        let leftAccuracy = left.proficiency?.recentAccuracy ?? 0
        let rightAccuracy = right.proficiency?.recentAccuracy ?? 0
        if leftAccuracy == rightAccuracy {
            if left.overdueCount == right.overdueCount {
                return left.module.title < right.module.title
            }
            return left.overdueCount > right.overdueCount
        }
        return leftAccuracy < rightAccuracy
    }

    private struct ModuleSnapshot {
        let module: TrainingModule
        let proficiency: ModuleProficiency?
        let overdueCount: Int
    }
}
