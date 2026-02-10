import Foundation
import Combine
import SwiftUI

struct SRCard: Codable, Identifiable {
    var id: String { questionId }
    let questionId: String
    var easeFactor: Double
    var interval: Int
    var repetitions: Int
    var nextReviewDate: Date
    var lastQuality: Int
}

struct ModuleProficiency: Codable {
    let moduleId: String
    var totalAttempts: Int
    var correctAttempts: Int
    var lastAttemptDate: Date
    var accuracyHistory: [Double]

    var accuracy: Double {
        totalAttempts > 0 ? Double(correctAttempts) / Double(totalAttempts) : 0
    }

    var recentAccuracy: Double {
        guard !accuracyHistory.isEmpty else { return 0 }
        let recent = accuracyHistory.suffix(10)
        return recent.reduce(0, +) / Double(recent.count)
    }

    var needsWork: Bool {
        recentAccuracy < 0.7
    }

    init(
        moduleId: String,
        totalAttempts: Int = 0,
        correctAttempts: Int = 0,
        lastAttemptDate: Date = .distantPast,
        accuracyHistory: [Double] = []
    ) {
        self.moduleId = moduleId
        self.totalAttempts = totalAttempts
        self.correctAttempts = correctAttempts
        self.lastAttemptDate = lastAttemptDate
        self.accuracyHistory = accuracyHistory
    }
}

final class ProgressStore: ObservableObject {
    private struct RoleOnboardingState: Codable {
        let startDate: Date?
        let checkIns: [Int]
    }

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
    @Published private(set) var selectedRole: TrainingRole? = nil
    @Published private(set) var onboardingStartDate: Date? = nil
    @Published private(set) var onboardingCheckIns: Set<Int> = []
    @Published private(set) var srCards: [String: SRCard] = [:]
    @Published private(set) var moduleProficiency: [String: ModuleProficiency] = [:]
    let maxHearts: Int = 5

    private let defaults: UserDefaults
    private let calendar: Calendar
    private let dateProvider: () -> Date
    private var autoSaveCancellable: AnyCancellable?

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
    private let selectedRoleKey = "selectedRole"
    private let onboardingStartKey = "onboardingStartDate"
    private let onboardingCheckInsKey = "onboardingCheckIns"
    private let onboardingByRoleKey = "onboardingByRole"
    private let srCardsKey = "sr_cards_v1"
    private let proficiencyKey = "module_proficiency_v1"
    private let procedureDrillRunsByRoleKey = "procedure_drill_runs_by_role_v1"
    private var onboardingStateByRole: [String: RoleOnboardingState] = [:]
    private var procedureDrillRunByRole: [String: ProcedureDrillRunState] = [:]

    init(defaults: UserDefaults = .standard, calendar: Calendar = .current, dateProvider: @escaping () -> Date = Date.init) {
        self.defaults = defaults
        self.calendar = calendar
        self.dateProvider = dateProvider
        load()
        configureAutomaticSaving()
    }

    private func configureAutomaticSaving() {
        autoSaveCancellable = objectWillChange
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.save()
            }
    }

    func markCompleted(moduleId: String, score: Int, scenarioPerfect: Bool, quizPerfect: Bool) {
        completedModules.insert(moduleId)
        lastCompleted[moduleId] = dateProvider()
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
        onboardingStartDate = nil
        onboardingCheckIns = []
        srCards = [:]
        moduleProficiency = [:]
        onboardingStateByRole = [:]
        procedureDrillRunByRole = [:]
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

    func initializeSRCardsIfNeeded(allQuestions: [QuizQuestion]) {
        guard srCards.isEmpty else { return }
        let initialCards = allQuestions.map {
            SRCard(
                questionId: $0.id,
                easeFactor: 2.5,
                interval: 0,
                repetitions: 0,
                nextReviewDate: .distantPast,
                lastQuality: 0
            )
        }
        srCards = Dictionary(uniqueKeysWithValues: initialCards.map { ($0.questionId, $0) })
        save()
    }

    func updateSRCard(questionId: String, quality: Int) {
        var card = srCards[questionId] ?? SRCard(
            questionId: questionId,
            easeFactor: 2.5,
            interval: 0,
            repetitions: 0,
            nextReviewDate: .distantPast,
            lastQuality: 0
        )
        if quality >= 3 {
            switch card.repetitions {
            case 0:
                card.interval = 1
            case 1:
                card.interval = 6
            default:
                card.interval = Int(round(Double(card.interval) * card.easeFactor))
            }
            card.repetitions += 1
        } else {
            card.repetitions = 0
            card.interval = 1
        }
        card.easeFactor = max(
            1.3,
            card.easeFactor + (
                0.1 - Double(5 - quality) * (0.08 + Double(5 - quality) * 0.02)
            )
        )
        card.nextReviewDate = Calendar.current.date(byAdding: .day, value: card.interval, to: Date()) ?? Date()
        card.lastQuality = quality
        srCards[questionId] = card
        save()
    }

    func overdueCards() -> [SRCard] {
        srCards.values
            .filter { $0.nextReviewDate <= Date() }
            .sorted { $0.nextReviewDate < $1.nextReviewDate }
    }

    func overdueCount() -> Int {
        srCards.values.filter { $0.nextReviewDate <= Date() }.count
    }

    func overdueCount(for modulePrefix: String) -> Int {
        srCards.values.filter {
            $0.questionId.hasPrefix(modulePrefix) && $0.nextReviewDate <= Date()
        }.count
    }

    func recordModuleAnswer(moduleId: String, correct: Bool) {
        var prof = moduleProficiency[moduleId] ?? ModuleProficiency(moduleId: moduleId)
        prof.totalAttempts += 1
        if correct {
            prof.correctAttempts += 1
        }
        prof.lastAttemptDate = Date()
        prof.accuracyHistory.append(correct ? 1.0 : 0.0)
        if prof.accuracyHistory.count > 20 {
            prof.accuracyHistory.removeFirst()
        }
        moduleProficiency[moduleId] = prof
        save()
    }

    func selectionWeight(for moduleId: String) -> Double {
        guard let prof = moduleProficiency[moduleId] else { return 1.0 }
        let accuracyWeight = 1.0 - prof.recentAccuracy
        let daysSince = Calendar.current.dateComponents([.day], from: prof.lastAttemptDate, to: Date()).day ?? 0
        let recencyBonus = min(Double(daysSince) * 0.05, 0.3)
        return max(0.1, accuracyWeight + recencyBonus)
    }

    private func load() {
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
        if let rawRole = defaults.string(forKey: selectedRoleKey),
           let role = TrainingRole(rawValue: rawRole) {
            selectedRole = role
        }
        if let data = defaults.data(forKey: srCardsKey),
           let decoded = try? JSONDecoder().decode([String: SRCard].self, from: data) {
            srCards = decoded
        }
        if let data = defaults.data(forKey: proficiencyKey),
           let decoded = try? JSONDecoder().decode([String: ModuleProficiency].self, from: data) {
            moduleProficiency = decoded
        }
        if let data = defaults.data(forKey: procedureDrillRunsByRoleKey),
           let decoded = try? JSONDecoder().decode([String: ProcedureDrillRunState].self, from: data) {
            procedureDrillRunByRole = decoded
        }

        if let data = defaults.data(forKey: onboardingByRoleKey),
           let decoded = try? JSONDecoder().decode([String: RoleOnboardingState].self, from: data) {
            onboardingStateByRole = decoded
        } else {
            var legacyStartDate: Date? = nil
            var legacyCheckIns: Set<Int> = []
            if let date = defaults.object(forKey: onboardingStartKey) as? Date {
                legacyStartDate = date
            }
            if let data = defaults.data(forKey: onboardingCheckInsKey),
               let decoded = try? JSONDecoder().decode([Int].self, from: data) {
                legacyCheckIns = Set(decoded)
            }
            if legacyStartDate != nil || !legacyCheckIns.isEmpty {
                onboardingStateByRole[roleKey(for: selectedRole)] = RoleOnboardingState(
                    startDate: legacyStartDate,
                    checkIns: Array(legacyCheckIns).sorted()
                )
            }
        }
        applyOnboardingState(for: selectedRole)
        _ = purgeExpiredProcedureDrillRuns(referenceDay: calendar.startOfDay(for: dateProvider()))
    }

    private func save() {
        persistCurrentOnboardingState()
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
        defaults.set(selectedRole?.rawValue, forKey: selectedRoleKey)
        if let data = try? JSONEncoder().encode(srCards) {
            defaults.set(data, forKey: srCardsKey)
        }
        if let data = try? JSONEncoder().encode(moduleProficiency) {
            defaults.set(data, forKey: proficiencyKey)
        }
        if let data = try? JSONEncoder().encode(procedureDrillRunByRole) {
            defaults.set(data, forKey: procedureDrillRunsByRoleKey)
        }
        if let data = try? JSONEncoder().encode(onboardingStateByRole) {
            defaults.set(data, forKey: onboardingByRoleKey)
        }
        // Keep legacy keys for backward compatibility with older app versions.
        defaults.set(onboardingStartDate, forKey: onboardingStartKey)
        if let data = try? JSONEncoder().encode(Array(onboardingCheckIns).sorted()) {
            defaults.set(data, forKey: onboardingCheckInsKey)
        }

    }

    func setRole(_ role: TrainingRole) {
        persistCurrentOnboardingState()
        selectedRole = role
        applyOnboardingState(for: selectedRole)
        save()
    }

    private func roleKey(for role: TrainingRole?) -> String {
        (role ?? .oneS0).rawValue
    }

    private func persistCurrentOnboardingState() {
        onboardingStateByRole[roleKey(for: selectedRole)] = RoleOnboardingState(
            startDate: onboardingStartDate,
            checkIns: Array(onboardingCheckIns).sorted()
        )
    }

    private func applyOnboardingState(for role: TrainingRole?) {
        let state = onboardingStateByRole[roleKey(for: role)] ?? RoleOnboardingState(startDate: nil, checkIns: [])
        onboardingStartDate = state.startDate
        onboardingCheckIns = Set(state.checkIns)
    }

    func procedureDrillRun(for role: TrainingRole?) -> ProcedureDrillRunState? {
        let key = roleKey(for: role)
        guard let run = procedureDrillRunByRole[key] else { return nil }
        let today = calendar.startOfDay(for: dateProvider())
        guard calendar.isDate(run.updatedAt, inSameDayAs: today) else {
            procedureDrillRunByRole.removeValue(forKey: key)
            save()
            return nil
        }
        return run
    }

    func saveProcedureDrillRun(_ run: ProcedureDrillRunState?, for role: TrainingRole?) {
        let key = roleKey(for: role)
        if var run {
            run.updatedAt = dateProvider()
            procedureDrillRunByRole[key] = run
        } else {
            procedureDrillRunByRole.removeValue(forKey: key)
        }
        save()
    }

    func clearProcedureDrillRun(for role: TrainingRole?) {
        let key = roleKey(for: role)
        guard procedureDrillRunByRole[key] != nil else { return }
        procedureDrillRunByRole.removeValue(forKey: key)
        save()
    }

    @discardableResult
    private func purgeExpiredProcedureDrillRuns(referenceDay: Date) -> Bool {
        let originalCount = procedureDrillRunByRole.count
        procedureDrillRunByRole = procedureDrillRunByRole.filter { _, run in
            calendar.isDate(run.updatedAt, inSameDayAs: referenceDay)
        }
        return procedureDrillRunByRole.count != originalCount
    }

    func refreshForNewDayIfNeeded() {
        let today = calendar.startOfDay(for: dateProvider())
        let removedExpiredRuns = purgeExpiredProcedureDrillRuns(referenceDay: today)
        guard let lastReset = lastDailyReset else {
            lastDailyReset = today
            save()
            return
        }
        if !calendar.isDate(lastReset, inSameDayAs: today) {
            dailyXp = 0
            hearts = maxHearts
            lastDailyReset = today
            if let lastGoal = lastDailyGoalDate {
                let lastGoalDay = calendar.startOfDay(for: lastGoal)
                let diff = calendar.dateComponents([.day], from: lastGoalDay, to: today).day ?? 0
                if diff > 1 {
                    dailyStreak = 0
                }
            }
            save()
        } else if removedExpiredRuns {
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

    func restoreAllHearts() {
        refreshForNewDayIfNeeded()
        hearts = maxHearts
        save()
    }

    #if DEBUG
    func debugMaxRank(modules: [TrainingModule]) {
        for module in modules {
            markCompleted(moduleId: module.id, score: 100, scenarioPerfect: true, quizPerfect: true)
        }
        xp = max(xp, levelStep * 20)
        dailyXp = max(dailyXp, dailyGoal)
        save()
    }
    #endif

    func completeModule(moduleId: String, score: Int, scenarioResult: AssessmentResult, quizResult: AssessmentResult, quizMultiplier: Double = 1.0) -> RewardSummary {
        markCompleted(
            moduleId: moduleId,
            score: score,
            scenarioPerfect: scenarioResult.score == scenarioResult.total && scenarioResult.total > 0,
            quizPerfect: quizResult.score == quizResult.total && quizResult.total > 0
        )

        let lessonXp = 12
        let scenarioXp = scenarioResult.score * 8
        let quizXp = Int(round(Double(quizResult.score * 6) * quizMultiplier))
        let passBonus = score >= 80 ? 20 : 0
        let perfectBonus = score == 100 ? 10 : 0
        let totalXp = lessonXp + scenarioXp + quizXp + passBonus + perfectBonus
        return earnXp(totalXp, heartsRestored: 0, streakMultiplier: quizMultiplier)
    }

    func completePractice(score: Int, total: Int, streakMultiplier: Double = 1.0) -> RewardSummary {
        refreshForNewDayIfNeeded()
        let accuracy = total > 0 ? Double(score) / Double(total) : 0
        let baseXp = 10
        let bonusXp = Int(round(accuracy * 25))
        let earned = Int(round(Double(baseXp + bonusXp) * streakMultiplier))
        var restored = 0

        if accuracy >= 0.9 {
            restored = restoreHearts(2)
        } else if accuracy >= 0.7 {
            restored = restoreHearts(1)
        }

        return earnXp(earned, heartsRestored: restored, streakMultiplier: streakMultiplier)
    }

    private func earnXp(_ amount: Int, heartsRestored: Int, streakMultiplier: Double = 1.0) -> RewardSummary {
        refreshForNewDayIfNeeded()
        guard amount > 0 else {
            return RewardSummary(xpGained: 0, leveledUp: false, streakIncreased: false, heartsRestored: heartsRestored, streakMultiplier: streakMultiplier)
        }

        let previousLevel = level
        xp += amount
        dailyXp += amount

        var streakIncreased = false
        let today = calendar.startOfDay(for: dateProvider())
        if dailyXp >= dailyGoal {
            if let lastGoalDate = lastDailyGoalDate {
                let lastGoalDay = calendar.startOfDay(for: lastGoalDate)
                let diff = calendar.dateComponents([.day], from: lastGoalDay, to: today).day ?? 0
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
        return RewardSummary(xpGained: amount, leveledUp: leveledUp, streakIncreased: streakIncreased, heartsRestored: heartsRestored, streakMultiplier: streakMultiplier)
    }

    private let levelStep: Int = 120

    func recordDailyFive(score: Int, total: Int) {
        let today = calendar.startOfDay(for: dateProvider())
        if let lastDate = lastDailyFiveDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            let diff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
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
            updatedAt: dateProvider()
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

    func startOnboardingIfNeeded() {
        if onboardingStartDate == nil {
            onboardingStartDate = calendar.startOfDay(for: dateProvider())
            onboardingCheckIns = []
            save()
        }
    }

    func restartOnboarding() {
        onboardingStartDate = calendar.startOfDay(for: dateProvider())
        onboardingCheckIns = []
        save()
    }

    func onboardingDayIndex(for date: Date? = nil) -> Int? {
        guard let start = onboardingStartDate else { return nil }
        let targetDate = date ?? dateProvider()
        let startDay = calendar.startOfDay(for: start)
        let targetDay = calendar.startOfDay(for: targetDate)
        let diff = calendar.dateComponents([.day], from: startDay, to: targetDay).day ?? 0
        return min(max(diff, 0), 6)
    }

    func onboardingDayNumber(for date: Date? = nil) -> Int? {
        guard let index = onboardingDayIndex(for: date) else { return nil }
        return index + 1
    }

    func isOnboardingDayComplete(_ day: Int) -> Bool {
        onboardingCheckIns.contains(day)
    }

    @discardableResult
    func checkInOnboardingDay() -> RewardSummary? {
        guard let dayNumber = onboardingDayNumber() else { return nil }
        guard !onboardingCheckIns.contains(dayNumber) else { return nil }
        onboardingCheckIns.insert(dayNumber)
        save()
        return earnXp(8, heartsRestored: 0, streakMultiplier: 1.0)
    }
}

struct RewardSummary {
    let xpGained: Int
    let leveledUp: Bool
    let streakIncreased: Bool
    let heartsRestored: Int
    let streakMultiplier: Double
}
