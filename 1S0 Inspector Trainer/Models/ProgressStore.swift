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

private struct RecentQuestionMiss: Codable, Hashable {
    let questionId: String
    let missedAt: Date
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
    @Published private(set) var selectedRole: TrainingRole? = .oneS0
    @Published private(set) var onboardingStartDate: Date? = nil
    @Published private(set) var onboardingCheckIns: Set<Int> = []
    @Published private(set) var srCards: [String: SRCard] = [:]
    @Published private(set) var moduleProficiency: [String: ModuleProficiency] = [:]
    @Published private(set) var completedPPEScenarios: Set<String> = []
    @Published private(set) var completedHazardReports: Set<String> = []
    @Published private(set) var completedORMScenarios: Set<String> = []
    @Published private(set) var bestCodeLookupScore: Int = 0
    @Published private(set) var codeLookupGamesPlayed: Int = 0
    @Published private(set) var codeLookupBestStreak: Int = 0
    @Published private(set) var pendingCompletion: PendingModuleCompletion? = nil
    @Published private(set) var favoriteEpubPublicationIds: Set<String> = []
    @Published private(set) var epubPublicationSnapshots: [String: EpubsPublicationSnapshot] = [:]
    private var recentQuestionMisses: [RecentQuestionMiss] = []
    private let defaults: UserDefaults
    private let calendar: Calendar
    private let dateProvider: () -> Date
    private var mutationTransactionDepth = 0
    private var saveRequestedInTransaction = false

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
    private let selectedRoleKey = "selectedRole"
    private let onboardingStartKey = "onboardingStartDate"
    private let onboardingCheckInsKey = "onboardingCheckIns"
    private let onboardingByRoleKey = "onboardingByRole"
    private let srCardsKey = "sr_cards_v1"
    private let proficiencyKey = "module_proficiency_v1"
    private let completedPPEKey = "completedPPEScenarios"
    private let completedHazardReportsKey = "completedHazardReports"
    private let completedORMScenariosKey = "completedORMScenarios"
    private let bestCodeLookupKey = "bestCodeLookup"
    private let codeLookupPlayedKey = "codeLookupPlayed"
    private let codeLookupStreakKey = "codeLookupStreak"
    private let pendingCompletionKey = "pendingModuleCompletion"
    private let recentQuestionMissesKey = "recentQuestionMisses_v1"
    private let favoriteEpubPublicationsKey = "favoriteEpubPublications_v1"
    private let epubPublicationSnapshotsKey = "epubPublicationSnapshots_v1"
    private var onboardingStateByRole: [String: RoleOnboardingState] = [:]

    init(defaults: UserDefaults = .standard, calendar: Calendar = .current, dateProvider: @escaping () -> Date = Date.init) {
        self.defaults = defaults
        self.calendar = calendar
        self.dateProvider = dateProvider
        load()
    }

    @discardableResult
    private func performMutationTransaction<T>(_ updates: () -> T) -> T {
        mutationTransactionDepth += 1
        defer {
            mutationTransactionDepth -= 1
            if mutationTransactionDepth == 0 && saveRequestedInTransaction {
                saveRequestedInTransaction = false
                persistToDefaults()
            }
        }
        return updates()
    }

    private func requestSave() {
        if mutationTransactionDepth > 0 {
            saveRequestedInTransaction = true
            return
        }
        persistToDefaults()
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
        completedPPEScenarios = []
        completedHazardReports = []
        completedORMScenarios = []
        bestCodeLookupScore = 0
        codeLookupGamesPlayed = 0
        codeLookupBestStreak = 0
        pendingCompletion = nil
        favoriteEpubPublicationIds = []
        epubPublicationSnapshots = [:]
        recentQuestionMisses = []
        onboardingStartDate = nil
        onboardingCheckIns = []
        srCards = [:]
        moduleProficiency = [:]
        onboardingStateByRole = [:]
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
        card.nextReviewDate = calendar.date(byAdding: .day, value: card.interval, to: dateProvider()) ?? dateProvider()
        card.lastQuality = quality
        srCards[questionId] = card
        save()
    }

    func overdueCards() -> [SRCard] {
        overdueCards(at: dateProvider())
    }

    private func overdueCards(at now: Date) -> [SRCard] {
        return srCards.values
            .filter { $0.nextReviewDate <= now }
            .sorted { $0.nextReviewDate < $1.nextReviewDate }
    }

    func overdueCountsByModule() -> [String: Int] {
        overdueCountsByModule(at: dateProvider())
    }

    private func overdueCountsByModule(at now: Date) -> [String: Int] {
        srCards.values.reduce(into: [:]) { counts, card in
            guard card.nextReviewDate <= now else { return }
            counts[ModuleHelper.modulePrefix(for: card.questionId), default: 0] += 1
        }
    }

    func overdueCount() -> Int {
        let now = dateProvider()
        return srCards.values.reduce(0) { count, card in
            card.nextReviewDate <= now ? count + 1 : count
        }
    }

    func overdueCount(for moduleId: String) -> Int {
        let now = dateProvider()
        return srCards.values.reduce(0) { count, card in
            ModuleHelper.modulePrefix(for: card.questionId) == moduleId && card.nextReviewDate <= now
                ? count + 1
                : count
        }
    }

    func recordModuleAnswer(moduleId: String, correct: Bool) {
        var prof = moduleProficiency[moduleId] ?? ModuleProficiency(moduleId: moduleId)
        prof.totalAttempts += 1
        if correct {
            prof.correctAttempts += 1
        }
        prof.lastAttemptDate = dateProvider()
        prof.accuracyHistory.append(correct ? 1.0 : 0.0)
        if prof.accuracyHistory.count > 20 {
            prof.accuracyHistory.removeFirst()
        }
        moduleProficiency[moduleId] = prof
        save()
    }

    func recordQuestionAttempt(questionId: String, correct: Bool) {
        let previousMisses = recentQuestionMisses
        recentQuestionMisses.removeAll { $0.questionId == questionId }
        if !correct {
            recentQuestionMisses.insert(
                RecentQuestionMiss(questionId: questionId, missedAt: dateProvider()),
                at: 0
            )
            if recentQuestionMisses.count > 24 {
                recentQuestionMisses.removeLast(recentQuestionMisses.count - 24)
            }
        }
        if recentQuestionMisses != previousMisses {
            save()
        }
    }

    func adaptiveRemediationPlan(from allQuestions: [QuizQuestion], questionCount: Int = 5) -> AdaptiveMissionPlan {
        guard !allQuestions.isEmpty, questionCount > 0 else {
            return AdaptiveMissionPlan(items: [])
        }

        let questionMap = Dictionary(uniqueKeysWithValues: allQuestions.map { ($0.id, $0) })
        let questionsByModule = Dictionary(grouping: allQuestions, by: { ModuleHelper.modulePrefix(for: $0.id) })
        let missedById = Dictionary(uniqueKeysWithValues: recentQuestionMisses.map { ($0.questionId, $0) })
        let now = dateProvider()
        let overdue = overdueCards(at: now)
        let overdueIds = Set(overdue.filter { $0.lastQuality > 0 }.map(\.questionId))
        let overdueCounts = overdueCountsByModule(at: now)

        // Pre-compute module weights so sort comparators are O(1)
        let moduleWeights = Dictionary(
            uniqueKeysWithValues: questionsByModule.keys.map {
                ($0, adaptiveMissionWeight(for: $0, overdueCountsByModule: overdueCounts))
            }
        )

        var selectedItems: [AdaptiveMissionItem] = []
        var selectedIds: Set<String> = []

        func append(question: QuizQuestion?, reason: AdaptiveMissionReason) {
            guard let question, selectedItems.count < questionCount else { return }
            guard selectedIds.insert(question.id).inserted else { return }
            selectedItems.append(AdaptiveMissionItem(question: question, reason: reason))
        }

        for miss in recentQuestionMisses.sorted(by: { $0.missedAt > $1.missedAt }).prefix(2) {
            append(question: questionMap[miss.questionId], reason: .recentMiss)
        }

        var overdueAdded = 0
        for card in overdue where card.lastQuality > 0 {
            let previousCount = selectedItems.count
            append(question: questionMap[card.questionId], reason: .overdueReview)
            if selectedItems.count > previousCount {
                overdueAdded += 1
            }
            if overdueAdded >= 2 || selectedItems.count >= questionCount {
                break
            }
        }

        let rankedModuleIds = questionsByModule.keys.sorted { left, right in
            let leftWeight = moduleWeights[left, default: 0]
            let rightWeight = moduleWeights[right, default: 0]
            if leftWeight == rightWeight { return left < right }
            return leftWeight > rightWeight
        }

        var questionPools = rankedModuleIds.map { moduleId in
            (
                moduleId: moduleId,
                questions: sortedByFallbackWeight(
                    questionsByModule[moduleId] ?? [],
                    missedById: missedById,
                    overdueIds: overdueIds,
                    moduleWeights: moduleWeights,
                    now: now
                )
            )
        }

        var appendedWeakQuestion = true
        while selectedItems.count < questionCount && appendedWeakQuestion {
            appendedWeakQuestion = false
            for index in questionPools.indices {
                while !questionPools[index].questions.isEmpty {
                    let question = questionPools[index].questions.removeFirst()
                    guard !selectedIds.contains(question.id) else { continue }
                    append(question: question, reason: .weakModule)
                    appendedWeakQuestion = true
                    break
                }
                if selectedItems.count >= questionCount {
                    break
                }
            }
        }

        if selectedItems.count < questionCount {
            let fallbackQuestions = sortedByFallbackWeight(
                allQuestions,
                missedById: missedById,
                overdueIds: overdueIds,
                moduleWeights: moduleWeights,
                now: now
            )
            for question in fallbackQuestions where selectedItems.count < questionCount {
                append(question: question, reason: .fallback)
            }
        }

        return AdaptiveMissionPlan(items: selectedItems)
    }

    private func adaptiveMissionWeight(for moduleId: String, overdueCountsByModule: [String: Int]) -> Double {
        let proficiency = moduleProficiency[moduleId] ?? ModuleProficiency(moduleId: moduleId)
        let accuracyPenalty = proficiency.totalAttempts > 0 ? 1.0 - proficiency.recentAccuracy : 0
        let overduePressure = min(Double(overdueCountsByModule[moduleId, default: 0]) * 0.15, 0.45)
        let missedPressure = recentQuestionMisses.contains {
            ModuleHelper.modulePrefix(for: $0.questionId) == moduleId
        } ? 0.25 : 0
        let newModuleBonus = proficiency.totalAttempts == 0 ? 0.1 : 0
        return accuracyPenalty + overduePressure + missedPressure + newModuleBonus
    }

    private func sortedByFallbackWeight(
        _ questions: [QuizQuestion],
        missedById: [String: RecentQuestionMiss],
        overdueIds: Set<String>,
        moduleWeights: [String: Double],
        now: Date
    ) -> [QuizQuestion] {
        questions.sorted { left, right in
            let leftWeight = fallbackQuestionWeight(question: left, missedById: missedById, overdueIds: overdueIds, moduleWeights: moduleWeights, now: now)
            let rightWeight = fallbackQuestionWeight(question: right, missedById: missedById, overdueIds: overdueIds, moduleWeights: moduleWeights, now: now)
            if leftWeight == rightWeight { return left.id < right.id }
            return leftWeight > rightWeight
        }
    }

    private func fallbackQuestionWeight(
        question: QuizQuestion,
        missedById: [String: RecentQuestionMiss],
        overdueIds: Set<String>,
        moduleWeights: [String: Double],
        now: Date
    ) -> Double {
        let moduleWeight = moduleWeights[ModuleHelper.modulePrefix(for: question.id), default: 0]
        let missWeight: Double
        if let miss = missedById[question.id] {
            let hoursSinceMiss = max(0, now.timeIntervalSince(miss.missedAt) / 3600)
            missWeight = max(0.2, 1.4 - min(hoursSinceMiss / 24, 1.0))
        } else {
            missWeight = 0
        }
        let overdueWeight = overdueIds.contains(question.id) ? 0.7 : 0
        let reviewPenalty = Double(max(0, 5 - (srCards[question.id]?.lastQuality ?? 4))) * 0.08
        return moduleWeight + missWeight + overdueWeight + reviewPenalty
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
        if let rawRole = defaults.string(forKey: selectedRoleKey) {
            selectedRole = TrainingRole(rawValue: rawRole) ?? .oneS0
        }
        if let data = defaults.data(forKey: srCardsKey),
           let decoded = try? JSONDecoder().decode([String: SRCard].self, from: data) {
            srCards = decoded
        }
        if let data = defaults.data(forKey: proficiencyKey),
           let decoded = try? JSONDecoder().decode([String: ModuleProficiency].self, from: data) {
            moduleProficiency = decoded
        }
        if let data = defaults.data(forKey: completedPPEKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            completedPPEScenarios = Set(decoded)
        }
        if let data = defaults.data(forKey: completedHazardReportsKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            completedHazardReports = Set(decoded)
        }
        if let data = defaults.data(forKey: completedORMScenariosKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            completedORMScenarios = Set(decoded)
        }
        bestCodeLookupScore = defaults.integer(forKey: bestCodeLookupKey)
        codeLookupGamesPlayed = defaults.integer(forKey: codeLookupPlayedKey)
        codeLookupBestStreak = defaults.integer(forKey: codeLookupStreakKey)
        if let data = defaults.data(forKey: pendingCompletionKey),
           let decoded = try? JSONDecoder().decode(PendingModuleCompletion.self, from: data) {
            pendingCompletion = decoded
        }
        if let data = defaults.data(forKey: recentQuestionMissesKey),
           let decoded = try? JSONDecoder().decode([RecentQuestionMiss].self, from: data) {
            recentQuestionMisses = decoded
        }
        if let data = defaults.data(forKey: favoriteEpubPublicationsKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            favoriteEpubPublicationIds = Set(decoded)
        }
        if let data = defaults.data(forKey: epubPublicationSnapshotsKey),
           let decoded = try? JSONDecoder().decode([String: EpubsPublicationSnapshot].self, from: data) {
            epubPublicationSnapshots = decoded
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
    }

    private func save() {
        requestSave()
    }

    private func persistToDefaults() {
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
        defaults.set(selectedRole?.rawValue, forKey: selectedRoleKey)
        if let data = try? JSONEncoder().encode(srCards) {
            defaults.set(data, forKey: srCardsKey)
        }
        if let data = try? JSONEncoder().encode(moduleProficiency) {
            defaults.set(data, forKey: proficiencyKey)
        }
        if let data = try? JSONEncoder().encode(Array(completedPPEScenarios)) {
            defaults.set(data, forKey: completedPPEKey)
        }
        if let data = try? JSONEncoder().encode(Array(completedHazardReports)) {
            defaults.set(data, forKey: completedHazardReportsKey)
        }
        if let data = try? JSONEncoder().encode(Array(completedORMScenarios)) {
            defaults.set(data, forKey: completedORMScenariosKey)
        }
        defaults.set(bestCodeLookupScore, forKey: bestCodeLookupKey)
        defaults.set(codeLookupGamesPlayed, forKey: codeLookupPlayedKey)
        defaults.set(codeLookupBestStreak, forKey: codeLookupStreakKey)
        if let pendingCompletion,
           let data = try? JSONEncoder().encode(pendingCompletion) {
            defaults.set(data, forKey: pendingCompletionKey)
        } else {
            defaults.removeObject(forKey: pendingCompletionKey)
        }
        if let data = try? JSONEncoder().encode(recentQuestionMisses) {
            defaults.set(data, forKey: recentQuestionMissesKey)
        }
        if let data = try? JSONEncoder().encode(Array(favoriteEpubPublicationIds).sorted()) {
            defaults.set(data, forKey: favoriteEpubPublicationsKey)
        }
        if let data = try? JSONEncoder().encode(epubPublicationSnapshots) {
            defaults.set(data, forKey: epubPublicationSnapshotsKey)
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

    func isFavoriteEpubPublication(_ publicationId: String) -> Bool {
        favoriteEpubPublicationIds.contains(publicationId)
    }

    func toggleFavoriteEpubPublication(_ publicationId: String) {
        if favoriteEpubPublicationIds.contains(publicationId) {
            favoriteEpubPublicationIds.remove(publicationId)
        } else {
            favoriteEpubPublicationIds.insert(publicationId)
        }
        save()
    }

    func recordEpubsChecks(_ metadataByPublication: [String: EpubsRemoteMetadata]) {
        guard !metadataByPublication.isEmpty else { return }

        performMutationTransaction {
            let checkedAt = dateProvider()
            for (publicationId, metadata) in metadataByPublication {
                let previous = epubPublicationSnapshots[publicationId]
                let detectedRevision = previous.map {
                    metadata.indicatesRevisionChange(from: $0.metadata)
                } ?? false
                epubPublicationSnapshots[publicationId] = EpubsPublicationSnapshot(
                    metadata: metadata,
                    lastChecked: checkedAt,
                    hasUnreadRevision: (previous?.hasUnreadRevision ?? false) || detectedRevision
                )
            }
            save()
        }
    }

    func markEpubsPublicationViewed(_ publicationId: String) {
        guard var snapshot = epubPublicationSnapshots[publicationId], snapshot.hasUnreadRevision else { return }
        snapshot.hasUnreadRevision = false
        epubPublicationSnapshots[publicationId] = snapshot
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

    func refreshForNewDayIfNeeded() {
        let today = calendar.startOfDay(for: dateProvider())
        guard let lastReset = lastDailyReset else {
            lastDailyReset = today
            save()
            return
        }
        if !calendar.isDate(lastReset, inSameDayAs: today) {
            dailyXp = 0
            lastDailyReset = today
            if let lastGoal = lastDailyGoalDate {
                let lastGoalDay = calendar.startOfDay(for: lastGoal)
                let diff = calendar.dateComponents([.day], from: lastGoalDay, to: today).day ?? 0
                if diff > 1 {
                    dailyStreak = 0
                }
            }
            save()
        }
    }

    func completeModule(moduleId: String, score: Int, scenarioResult: AssessmentResult, quizResult: AssessmentResult, quizMultiplier: Double = 1.0) -> RewardSummary {
        performMutationTransaction {
            if score >= 80 {
                markCompleted(
                    moduleId: moduleId,
                    score: score,
                    scenarioPerfect: scenarioResult.score == scenarioResult.total && scenarioResult.total > 0,
                    quizPerfect: quizResult.score == quizResult.total && quizResult.total > 0
                )
            }

            let lessonXp = 12
            let scenarioXp = scenarioResult.score * 8
            let quizXp = Int(round(Double(quizResult.score * 6) * quizMultiplier))
            let passBonus = score >= 80 ? 20 : 0
            let perfectBonus = score == 100 ? 10 : 0
            let totalXp = lessonXp + scenarioXp + quizXp + passBonus + perfectBonus
            return earnXp(totalXp, streakMultiplier: quizMultiplier)
        }
    }

    func markPPEScenarioCompleted(_ scenarioId: String) {
        completedPPEScenarios.insert(scenarioId)
        save()
    }

    var playedDailyFiveToday: Bool {
        guard let lastRun = lastDailyFiveDate else { return false }
        return calendar.isDateInToday(lastRun)
    }

    var allPPEScenariosCompleted: Bool {
        let allIds = Set(PPELoadoutBank.allScenarios.map(\.id))
        return allIds.isSubset(of: completedPPEScenarios)
    }

    func markHazardReportCompleted(_ scenarioId: String) {
        completedHazardReports.insert(scenarioId)
        save()
    }

    var allHazardReportsCompleted: Bool {
        let allIds = Set(HazardReportBank.allScenarios.map(\.id))
        return allIds.isSubset(of: completedHazardReports)
    }

    func markORMScenarioCompleted(_ scenarioId: String) {
        completedORMScenarios.insert(scenarioId)
        save()
    }

    var allORMScenariosCompleted: Bool {
        let allIds = Set(DeployedORMBank.allScenarios.map(\.id))
        return allIds.isSubset(of: completedORMScenarios)
    }

    func completePractice(score: Int, total: Int, streakMultiplier: Double = 1.0) -> RewardSummary {
        performMutationTransaction {
            refreshForNewDayIfNeeded()
            let accuracy = total > 0 ? Double(score) / Double(total) : 0
            let baseXp = 10
            let bonusXp = Int(round(accuracy * 25))
            let earned = Int(round(Double(baseXp + bonusXp) * streakMultiplier))

            return earnXp(earned, streakMultiplier: streakMultiplier)
        }
    }

    func completeAdaptiveRemediation(score: Int, total: Int, streakMultiplier: Double = 1.0) -> RewardSummary {
        performMutationTransaction {
            recordDailyFive(score: score, total: total)
            refreshForNewDayIfNeeded()
            let accuracy = total > 0 ? Double(score) / Double(total) : 0
            let baseXp = 12
            let accuracyBonus = Int(round(accuracy * 18))
            let cleanSweepBonus = score == total && total > 0 ? 8 : 0
            let earned = Int(round(Double(baseXp + accuracyBonus + cleanSweepBonus) * streakMultiplier))
            return earnXp(earned, streakMultiplier: streakMultiplier)
        }
    }

    func completeCodeLookup(score: Int, total: Int, accuracy: Double, bestStreak: Int) -> RewardSummary {
        performMutationTransaction {
            refreshForNewDayIfNeeded()
            codeLookupGamesPlayed += 1
            if score > bestCodeLookupScore {
                bestCodeLookupScore = score
            }
            if bestStreak > codeLookupBestStreak {
                codeLookupBestStreak = bestStreak
            }
            let baseXp = 15
            let bonusXp = Int(round(accuracy * 30))
            let streakBonus = bestStreak >= 5 ? 10 : 0
            let earned = baseXp + bonusXp + streakBonus
            save()
            return earnXp(earned)
        }
    }

    private func earnXp(_ amount: Int, streakMultiplier: Double = 1.0) -> RewardSummary {
        refreshForNewDayIfNeeded()
        guard amount > 0 else {
            return RewardSummary(xpGained: 0, leveledUp: false, streakIncreased: false, streakMultiplier: streakMultiplier)
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
        return RewardSummary(xpGained: amount, leveledUp: leveledUp, streakIncreased: streakIncreased, streakMultiplier: streakMultiplier)
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

    func savePendingCompletion(
        moduleId: String,
        scenarioResult: AssessmentResult,
        quizResult: AssessmentResult,
        quizStreakSummary: QuizStreakSummary
    ) {
        pendingCompletion = PendingModuleCompletion(
            moduleId: moduleId,
            scenarioResult: scenarioResult,
            quizResult: quizResult,
            quizStreakSummary: quizStreakSummary,
            savedAt: dateProvider()
        )
        save()
    }

    func pendingCompletion(for moduleId: String) -> PendingModuleCompletion? {
        guard let pendingCompletion, pendingCompletion.moduleId == moduleId else { return nil }
        return pendingCompletion
    }

    func clearPendingCompletion(for moduleId: String) {
        guard pendingCompletion?.moduleId == moduleId else { return }
        pendingCompletion = nil
        save()
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
        performMutationTransaction {
            guard let dayNumber = onboardingDayNumber() else { return nil }
            guard !onboardingCheckIns.contains(dayNumber) else { return nil }
            onboardingCheckIns.insert(dayNumber)
            save()
            return earnXp(8, streakMultiplier: 1.0)
        }
    }

}

struct RewardSummary {
    let xpGained: Int
    let leveledUp: Bool
    let streakIncreased: Bool
    let streakMultiplier: Double
}
