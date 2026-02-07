import SwiftUI

enum PracticeMode {
    case practice
    case dailyFive
}

struct PracticeSessionView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    let mode: PracticeMode

    @State private var result: AssessmentResult? = nil
    @State private var rewardSummary: RewardSummary? = nil
    @State private var sessionId = UUID()
    @State private var priorDailyScore: Int = 0
    @State private var initializedSR: Bool = false

    private var questionPool: [QuizQuestion] {
        let allQuestions = TrainingContent.allQuizQuestions(for: progress.selectedRole)

        let questionMap = Dictionary(uniqueKeysWithValues: allQuestions.map { ($0.id, $0) })
        let overdueCards = progress.overdueCards()
        let overdueQuestions = overdueCards.compactMap { questionMap[$0.questionId] }
        let targetCount = mode == .dailyFive ? 5 : 6

        var selected = weightedOverdueSelection(from: overdueQuestions, targetCount: targetCount)

        if selected.count < targetCount {
            let selectedIds = Set(selected.map { $0.id })
            let overdueIds = Set(overdueQuestions.map { $0.id })
            let filler = allQuestions
                .filter { !overdueIds.contains($0.id) && !selectedIds.contains($0.id) }
                .shuffled()
            selected.append(contentsOf: filler.prefix(targetCount - selected.count))
        }

        return Array(selected.prefix(targetCount))
    }

    init(mode: PracticeMode = .practice) {
        self.mode = mode
    }

    var body: some View {
        ZStack {
            BackgroundView()

            if let result {
                ScrollView {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(mode == .dailyFive ? "Daily 5 Complete" : "Practice Complete")
                                .font(AppFont.title(22))
                                .foregroundColor(AppTheme.text)
                            Text("Score: \(result.score)/\(result.total)")
                                .font(AppFont.subtitle(16))
                                .foregroundColor(AppTheme.text)

                            if mode == .dailyFive {
                                Text("Daily 5 Streak: \(progress.dailyFiveStreak) days")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Challenges")
                                        .font(AppFont.subtitle(14))
                                        .foregroundColor(AppTheme.text)
                                    ChallengeRow(
                                        title: "Beat your last score",
                                        isComplete: priorDailyScore > 0 && progress.lastDailyFiveScore > priorDailyScore
                                    )
                                    ChallengeRow(
                                        title: "3-day streak",
                                        isComplete: progress.dailyFiveStreak >= 3
                                    )
                                    if progress.bestDailyFiveScore > 0 {
                                        Text("Best Daily 5: \(progress.bestDailyFiveScore)%")
                                            .font(AppFont.body(12))
                                            .foregroundColor(AppTheme.muted)
                                    }
                                }
                            }

                            if let rewardSummary {
                                RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                            }

                            Button(mode == .dailyFive ? "Run Another Daily 5" : "Practice Again") {
                                resetSession()
                            }
                            .buttonStyle(PrimaryButtonStyle())

                            Button("Back to Home") {
                                dismiss()
                            }
                            .buttonStyle(OutlineButtonStyle())
                        }
                    }
                    .padding(AppSpacing.screenPadding)
                }
                .scrollIndicators(.hidden)
            } else {
                QuizFlowView(
                    questions: questionPool,
                    onComplete: { result, streak in
                        rewardSummary = progress.completePractice(score: result.score, total: result.total, streakMultiplier: streak.multiplier)
                        if mode == .dailyFive {
                            priorDailyScore = progress.lastDailyFiveScore
                            progress.recordDailyFive(score: result.score, total: result.total)
                        }
                        self.result = result
                    },
                    shuffleQuestions: true,
                    maxQuestions: mode == .dailyFive ? 5 : 6
                )
                .id(sessionId)
            }
        }
        .navigationTitle(mode == .dailyFive ? "Daily 5" : "Practice")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !initializedSR {
                let allQuestions = TrainingContent.allQuizQuestions(for: progress.selectedRole)
                progress.initializeSRCardsIfNeeded(allQuestions: allQuestions)
                initializedSR = true
            }
            progress.refreshForNewDayIfNeeded()
        }
    }

    private func resetSession() {
        result = nil
        rewardSummary = nil
        sessionId = UUID()
    }

    private func weightedOverdueSelection(from overdueQuestions: [QuizQuestion], targetCount: Int) -> [QuizQuestion] {
        guard !overdueQuestions.isEmpty else { return [] }

        var groupedQuestions = Dictionary(grouping: overdueQuestions) { modulePrefix(for: $0.id) }
            .mapValues { $0.shuffled() }
        var selected: [QuizQuestion] = []

        while selected.count < targetCount {
            let availableModules = groupedQuestions
                .filter { !$0.value.isEmpty }
                .map { (moduleId: $0.key, weight: progress.selectionWeight(for: $0.key)) }
            guard let chosenModule = chooseWeightedModule(from: availableModules) else { break }
            guard var questions = groupedQuestions[chosenModule], !questions.isEmpty else { continue }
            selected.append(questions.removeFirst())
            groupedQuestions[chosenModule] = questions
        }

        return selected
    }

    private func chooseWeightedModule(from modules: [(moduleId: String, weight: Double)]) -> String? {
        guard !modules.isEmpty else { return nil }
        let totalWeight = modules.reduce(0.0) { $0 + max(0.1, $1.weight) }
        guard totalWeight > 0 else { return modules.randomElement()?.moduleId }

        var threshold = Double.random(in: 0..<totalWeight)
        for module in modules {
            threshold -= max(0.1, module.weight)
            if threshold <= 0 {
                return module.moduleId
            }
        }
        return modules.last?.moduleId
    }

    private func modulePrefix(for questionId: String) -> String {
        let parts = questionId.split(separator: "-")
        guard parts.count > 1 else { return questionId }
        return parts.dropLast().joined(separator: "-")
    }
}
