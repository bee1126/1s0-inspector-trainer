import Foundation
import SwiftUI

final class ProgressStore: ObservableObject {
    @Published private(set) var completedModules: Set<String> = []
    @Published private(set) var bestScores: [String: Int] = [:]
    @Published private(set) var lastCompleted: [String: Date] = [:]
    @Published private(set) var perfectScenario: Set<String> = []
    @Published private(set) var perfectQuiz: Set<String> = []
    @Published private(set) var xp: Int = 0
    @Published private(set) var dailyXp: Int = 0
    @Published private(set) var dailyGoal: Int = 20
    @Published private(set) var dailyStreak: Int = 0
    @Published private(set) var lastDailyGoalDate: Date? = nil
    @Published private(set) var lastDailyReset: Date? = nil
    @Published private(set) var dailyFiveStreak: Int = 0
    @Published private(set) var lastDailyFiveDate: Date? = nil
    @Published private(set) var bestDailyFiveScore: Int = 0
    @Published private(set) var lastDailyFiveScore: Int = 0
    @Published private(set) var resumeState: ModuleResumeState? = nil
    @Published private(set) var hearts: Int = 5
    let maxHearts: Int = 5

    private let completedKey = "completedModules"
    private let scoresKey = "bestScores"
    private let completedDatesKey = "completedDates"
    private let perfectScenarioKey = "perfectScenario"
    private let perfectQuizKey = "perfectQuiz"
    private let xpKey = "xpTotal"
    private let dailyXpKey = "dailyXp"
    private let dailyGoalKey = "dailyGoal"
    private let dailyStreakKey = "dailyStreak"
    private let lastDailyGoalKey = "lastDailyGoal"
    private let lastDailyResetKey = "lastDailyReset"
    private let dailyFiveStreakKey = "dailyFiveStreak"
    private let lastDailyFiveKey = "lastDailyFive"
    private let bestDailyFiveKey = "bestDailyFive"
    private let lastDailyFiveScoreKey = "lastDailyFiveScore"
    private let resumeStateKey = "resumeState"
    private let heartsKey = "hearts"

    init() {
        load()
    }

    func markCompleted(moduleId: String, score: Int, scenarioPerfect: Bool, quizPerfect: Bool) {
        completedModules.insert(moduleId)
        lastCompleted[moduleId] = Date()
        if scenarioPerfect { perfectScenario.insert(moduleId) }
        if quizPerfect { perfectQuiz.insert(moduleId) }
        let current = bestScores[moduleId] ?? 0
        if score > current {
            bestScores[moduleId] = score
        }
        save()
    }

    func isCompleted(_ moduleId: String) -> Bool {
        completedModules.contains(moduleId)
    }

    func bestScore(for moduleId: String) -> Int {
        bestScores[moduleId] ?? 0
    }

    func lastCompletionDate(for moduleId: String) -> Date? {
        lastCompleted[moduleId]
    }

    func resetAll() {
        completedModules = []
        bestScores = [:]
        lastCompleted = [:]
        perfectScenario = []
        perfectQuiz = []
        xp = 0
        dailyXp = 0
        dailyGoal = 20
        dailyStreak = 0
        lastDailyGoalDate = nil
        lastDailyReset = nil
        dailyFiveStreak = 0
        lastDailyFiveDate = nil
        bestDailyFiveScore = 0
        lastDailyFiveScore = 0
        resumeState = nil
        hearts = maxHearts
        save()
    }

    var level: Int {
        max(1, xp / levelStep + 1)
    }

    var levelProgress: Double {
        guard levelStep > 0 else { return 0 }
        return Double(xp % levelStep) / Double(levelStep)
    }

    var xpToNextLevel: Int {
        let progress = xp % levelStep
        return max(0, levelStep - progress)
    }

    var dailyGoalProgress: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(1, Double(dailyXp) / Double(dailyGoal))
    }

    private func load() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: completedKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            completedModules = Set(decoded)
        }
        if let data = defaults.data(forKey: scoresKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            bestScores = decoded
        }
        if let data = defaults.data(forKey: completedDatesKey),
           let decoded = try? JSONDecoder().decode([String: Date].self, from: data) {
            lastCompleted = decoded
        }
        if let data = defaults.data(forKey: perfectScenarioKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            perfectScenario = Set(decoded)
        }
        if let data = defaults.data(forKey: perfectQuizKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            perfectQuiz = Set(decoded)
        }
        xp = defaults.integer(forKey: xpKey)
        dailyXp = defaults.integer(forKey: dailyXpKey)
        let storedGoal = defaults.integer(forKey: dailyGoalKey)
        dailyGoal = storedGoal == 0 ? 20 : storedGoal
        dailyStreak = defaults.integer(forKey: dailyStreakKey)
        if let date = defaults.object(forKey: lastDailyGoalKey) as? Date {
            lastDailyGoalDate = date
        }
        if let date = defaults.object(forKey: lastDailyResetKey) as? Date {
            lastDailyReset = date
        }
        dailyFiveStreak = defaults.integer(forKey: dailyFiveStreakKey)
        if let date = defaults.object(forKey: lastDailyFiveKey) as? Date {
            lastDailyFiveDate = date
        }
        bestDailyFiveScore = defaults.integer(forKey: bestDailyFiveKey)
        lastDailyFiveScore = defaults.integer(forKey: lastDailyFiveScoreKey)
        if let data = defaults.data(forKey: resumeStateKey),
           let decoded = try? JSONDecoder().decode(ModuleResumeState.self, from: data) {
            resumeState = decoded
        }
        if defaults.object(forKey: heartsKey) == nil {
            hearts = maxHearts
        } else {
            hearts = defaults.integer(forKey: heartsKey)
        }
    }

    private func save() {
        let defaults = UserDefaults.standard
        if let data = try? JSONEncoder().encode(Array(completedModules)) {
            defaults.set(data, forKey: completedKey)
        }
        if let data = try? JSONEncoder().encode(bestScores) {
            defaults.set(data, forKey: scoresKey)
        }
        if let data = try? JSONEncoder().encode(lastCompleted) {
            defaults.set(data, forKey: completedDatesKey)
        }
        if let data = try? JSONEncoder().encode(Array(perfectScenario)) {
            defaults.set(data, forKey: perfectScenarioKey)
        }
        if let data = try? JSONEncoder().encode(Array(perfectQuiz)) {
            defaults.set(data, forKey: perfectQuizKey)
        }
        defaults.set(xp, forKey: xpKey)
        defaults.set(dailyXp, forKey: dailyXpKey)
        defaults.set(dailyGoal, forKey: dailyGoalKey)
        defaults.set(dailyStreak, forKey: dailyStreakKey)
        defaults.set(lastDailyGoalDate, forKey: lastDailyGoalKey)
        defaults.set(lastDailyReset, forKey: lastDailyResetKey)
        defaults.set(dailyFiveStreak, forKey: dailyFiveStreakKey)
        defaults.set(lastDailyFiveDate, forKey: lastDailyFiveKey)
        defaults.set(bestDailyFiveScore, forKey: bestDailyFiveKey)
        defaults.set(lastDailyFiveScore, forKey: lastDailyFiveScoreKey)
        if let resumeState,
           let data = try? JSONEncoder().encode(resumeState) {
            defaults.set(data, forKey: resumeStateKey)
        } else {
            defaults.removeObject(forKey: resumeStateKey)
        }
        defaults.set(hearts, forKey: heartsKey)
    }

    func refreshForNewDayIfNeeded() {
        let today = Calendar.current.startOfDay(for: Date())
        guard let lastReset = lastDailyReset else {
            lastDailyReset = today
            save()
            return
        }
        if !Calendar.current.isDate(lastReset, inSameDayAs: today) {
            dailyXp = 0
            hearts = maxHearts
            lastDailyReset = today
            if let lastGoal = lastDailyGoalDate {
                let lastGoalDay = Calendar.current.startOfDay(for: lastGoal)
                let diff = Calendar.current.dateComponents([.day], from: lastGoalDay, to: today).day ?? 0
                if diff > 1 {
                    dailyStreak = 0
                }
            }
            save()
        }
    }

    func consumeHeart() {
        refreshForNewDayIfNeeded()
        guard hearts > 0 else { return }
        hearts -= 1
        save()
    }

    @discardableResult
    func restoreHearts(_ amount: Int) -> Int {
        refreshForNewDayIfNeeded()
        guard amount > 0 else { return 0 }
        let before = hearts
        hearts = min(maxHearts, hearts + amount)
        save()
        return max(0, hearts - before)
    }

    func completeModule(moduleId: String, score: Int, scenarioResult: AssessmentResult, quizResult: AssessmentResult) -> RewardSummary {
        markCompleted(
            moduleId: moduleId,
            score: score,
            scenarioPerfect: scenarioResult.score == scenarioResult.total && scenarioResult.total > 0,
            quizPerfect: quizResult.score == quizResult.total && quizResult.total > 0
        )

        let lessonXp = 12
        let scenarioXp = scenarioResult.score * 8
        let quizXp = quizResult.score * 6
        let passBonus = score >= 80 ? 20 : 0
        let perfectBonus = score == 100 ? 10 : 0
        let totalXp = lessonXp + scenarioXp + quizXp + passBonus + perfectBonus
        return earnXp(totalXp, heartsRestored: 0)
    }

    func completePractice(score: Int, total: Int) -> RewardSummary {
        refreshForNewDayIfNeeded()
        let accuracy = total > 0 ? Double(score) / Double(total) : 0
        let baseXp = 10
        let bonusXp = Int(round(accuracy * 25))
        let earned = baseXp + bonusXp
        var restored = 0

        if accuracy >= 0.9 {
            restored = restoreHearts(2)
        } else if accuracy >= 0.7 {
            restored = restoreHearts(1)
        }

        return earnXp(earned, heartsRestored: restored)
    }

    private func earnXp(_ amount: Int, heartsRestored: Int) -> RewardSummary {
        refreshForNewDayIfNeeded()
        guard amount > 0 else {
            return RewardSummary(xpGained: 0, leveledUp: false, streakIncreased: false, heartsRestored: heartsRestored)
        }

        let previousLevel = level
        xp += amount
        dailyXp += amount

        var streakIncreased = false
        let today = Calendar.current.startOfDay(for: Date())
        if dailyXp >= dailyGoal {
            if let lastGoalDate = lastDailyGoalDate {
                let lastGoalDay = Calendar.current.startOfDay(for: lastGoalDate)
                let diff = Calendar.current.dateComponents([.day], from: lastGoalDay, to: today).day ?? 0
                if diff == 0 {
                    // Already counted today
                } else if diff == 1 {
                    dailyStreak += 1
                    streakIncreased = true
                } else {
                    dailyStreak = 1
                    streakIncreased = true
                }
            } else {
                dailyStreak = 1
                streakIncreased = true
            }
            lastDailyGoalDate = today
        }

        let leveledUp = level > previousLevel
        save()
        return RewardSummary(xpGained: amount, leveledUp: leveledUp, streakIncreased: streakIncreased, heartsRestored: heartsRestored)
    }

    private let levelStep: Int = 120

    func recordDailyFive(score: Int, total: Int) {
        let today = Calendar.current.startOfDay(for: Date())
        if let lastDate = lastDailyFiveDate {
            let lastDay = Calendar.current.startOfDay(for: lastDate)
            let diff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if diff == 1 {
                dailyFiveStreak += 1
            } else if diff > 1 {
                dailyFiveStreak = 1
            }
        } else {
            dailyFiveStreak = 1
        }
        lastDailyFiveDate = today
        let percent = total > 0 ? Int(round(Double(score) / Double(total) * 100)) : 0
        lastDailyFiveScore = percent
        bestDailyFiveScore = max(bestDailyFiveScore, percent)
        save()
    }

    func updateResume(moduleId: String, stage: ModuleStageKey, lessonIndex: Int? = nil, quizState: QuizResumeState? = nil) {
        let currentLessonIndex = lessonIndex ?? resumeState?.lessonIndex ?? 0
        let currentQuiz = stage == .quiz ? (quizState ?? resumeState?.quizState) : nil
        resumeState = ModuleResumeState(
            moduleId: moduleId,
            stage: stage,
            lessonIndex: currentLessonIndex,
            quizState: currentQuiz,
            updatedAt: Date()
        )
        save()
    }

    func clearResume(for moduleId: String) {
        guard resumeState?.moduleId == moduleId else { return }
        resumeState = nil
        save()
    }

    func resumeState(for moduleId: String) -> ModuleResumeState? {
        guard let state = resumeState, state.moduleId == moduleId else { return nil }
        return state
    }
}

struct RewardSummary {
    let xpGained: Int
    let leveledUp: Bool
    let streakIncreased: Bool
    let heartsRestored: Int
}
