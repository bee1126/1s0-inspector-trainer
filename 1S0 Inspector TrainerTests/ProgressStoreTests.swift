import XCTest
@testable import _S0_Inspector_Trainer

final class ProgressStoreTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!
    private var calendar: Calendar!

    override func setUp() {
        super.setUp()
        suiteName = "ProgressStoreTests.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            fatalError("Unable to create UserDefaults suite")
        }
        defaults.removePersistentDomain(forName: suiteName)
        self.defaults = defaults
        calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    }

    override func tearDown() {
        if let suiteName {
            defaults.removePersistentDomain(forName: suiteName)
        }
        defaults = nil
        suiteName = nil
        calendar = nil
        super.tearDown()
    }

    func testCompleteModuleXPAndProgress() {
        var now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        let reward = store.completeModule(
            moduleId: "m1",
            score: 100,
            scenarioResult: AssessmentResult(score: 5, total: 5),
            quizResult: AssessmentResult(score: 5, total: 5)
        )

        XCTAssertEqual(reward.xpGained, 112)
        XCTAssertEqual(store.xp, 112)
        XCTAssertEqual(store.level, 1)
        XCTAssertEqual(store.xpToNextLevel, 8)
        XCTAssertEqual(store.levelProgress, 112.0 / 120.0, accuracy: 0.0001)
    }

    func testPracticeLevelsUp() {
        var now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        _ = store.completeModule(
            moduleId: "m1",
            score: 100,
            scenarioResult: AssessmentResult(score: 5, total: 5),
            quizResult: AssessmentResult(score: 5, total: 5)
        )

        let reward = store.completePractice(score: 10, total: 10)

        XCTAssertTrue(reward.leveledUp)
        XCTAssertEqual(store.level, 2)
        XCTAssertEqual(store.xpToNextLevel, 93)
    }

    func testFailedModuleAttemptDoesNotMarkModuleComplete() {
        let now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        let reward = store.completeModule(
            moduleId: "m1",
            score: 70,
            scenarioResult: AssessmentResult(score: 3, total: 5),
            quizResult: AssessmentResult(score: 4, total: 5)
        )

        XCTAssertFalse(store.isCompleted("m1"))
        XCTAssertEqual(store.bestScore(for: "m1"), 0)
        XCTAssertNil(store.lastCompletionDate(for: "m1"))
        XCTAssertEqual(store.xp, reward.xpGained)
        XCTAssertGreaterThan(reward.xpGained, 0)
    }

    func testDailyStreakProgression() {
        var now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        _ = store.completePractice(score: 10, total: 10)
        XCTAssertEqual(store.dailyStreak, 1)

        now = calendar.date(byAdding: .day, value: 1, to: now)!
        _ = store.completePractice(score: 10, total: 10)
        XCTAssertEqual(store.dailyStreak, 2)

        now = calendar.date(byAdding: .day, value: 2, to: now)!
        _ = store.completePractice(score: 10, total: 10)
        XCTAssertEqual(store.dailyStreak, 1)
    }

    func testDefaultRoleIsOneS0() {
        let now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        XCTAssertEqual(store.selectedRole, .oneS0)
    }

    func testLegacyUSRSelectionFallsBackToOneS0() {
        defaults.set("USR", forKey: "selectedRole")

        let now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        XCTAssertEqual(store.selectedRole, .oneS0)
    }

    func testRecordDailyFiveOnlyAdvancesStreakOncePerDay() {
        var now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        store.recordDailyFive(score: 4, total: 5)
        XCTAssertEqual(store.dailyFiveStreak, 1)
        XCTAssertEqual(store.lastDailyFiveScore, 80)
        XCTAssertEqual(store.bestDailyFiveScore, 80)

        store.recordDailyFive(score: 5, total: 5)
        XCTAssertEqual(store.dailyFiveStreak, 1)
        XCTAssertEqual(store.lastDailyFiveScore, 100)
        XCTAssertEqual(store.bestDailyFiveScore, 100)

        now = calendar.date(byAdding: .day, value: 1, to: now)!
        store.recordDailyFive(score: 3, total: 5)
        XCTAssertEqual(store.dailyFiveStreak, 2)
        XCTAssertEqual(store.lastDailyFiveScore, 60)
        XCTAssertEqual(store.bestDailyFiveScore, 100)
    }

    func testPendingCompletionPersistsAcrossStoreInstances() {
        let now = Date(timeIntervalSince1970: 0)
        let scenario = AssessmentResult(score: 4, total: 5)
        let quiz = AssessmentResult(score: 5, total: 5)
        let streak = QuizStreakSummary(maxStreak: 4, multiplier: 1.2)

        let firstStore = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        firstStore.savePendingCompletion(
            moduleId: "m1",
            scenarioResult: scenario,
            quizResult: quiz,
            quizStreakSummary: streak
        )

        let secondStore = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        XCTAssertEqual(secondStore.pendingCompletion(for: "m1")?.scenarioResult, scenario)
        XCTAssertEqual(secondStore.pendingCompletion(for: "m1")?.quizResult, quiz)
        XCTAssertEqual(secondStore.pendingCompletion(for: "m1")?.quizStreakSummary, streak)

        secondStore.clearPendingCompletion(for: "m1")

        let thirdStore = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        XCTAssertNil(thirdStore.pendingCompletion(for: "m1"))
    }

    func testResumeStatePersistsAnsweredQuestionMetadata() {
        let now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        let quizState = QuizResumeState(
            questionIds: ["loto-q1", "loto-q2"],
            choiceOrder: [
                "loto-q1": ["loto-q1-b", "loto-q1-a", "loto-q1-c", "loto-q1-d"],
                "loto-q2": ["loto-q2-a", "loto-q2-b", "loto-q2-c", "loto-q2-d"]
            ],
            index: 0,
            correctCount: 1,
            selectedChoiceId: "loto-q1-a",
            showFeedback: true,
            streakCount: 3,
            bestStreakCount: 4,
            streakTier: 1,
            bestStreakTier: 1
        )

        store.updateResume(moduleId: "loto", stage: .quiz, lessonIndex: 2, quizState: quizState)

        let reloaded = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        let restored = reloaded.resumeState(for: "loto")

        XCTAssertEqual(restored?.stage, .quiz)
        XCTAssertEqual(restored?.lessonIndex, 2)
        XCTAssertEqual(restored?.quizState?.selectedChoiceId, "loto-q1-a")
        XCTAssertEqual(restored?.quizState?.showFeedback, true)
        XCTAssertEqual(restored?.quizState?.streakCount, 3)
        XCTAssertEqual(restored?.quizState?.bestStreakCount, 4)
        XCTAssertEqual(restored?.quizState?.streakTier, 1)
        XCTAssertEqual(restored?.quizState?.bestStreakTier, 1)
    }

    func testLegacyQuizResumeStateDecodesWithDefaultsForNewFields() throws {
        let legacyJSON = """
        {
          "questionIds": ["q1", "q2"],
          "choiceOrder": {
            "q1": ["a", "b", "c", "d"]
          },
          "index": 1,
          "correctCount": 1
        }
        """

        let state = try JSONDecoder().decode(QuizResumeState.self, from: Data(legacyJSON.utf8))

        XCTAssertEqual(state.questionIds, ["q1", "q2"])
        XCTAssertEqual(state.index, 1)
        XCTAssertEqual(state.correctCount, 1)
        XCTAssertNil(state.selectedChoiceId)
        XCTAssertFalse(state.showFeedback)
        XCTAssertEqual(state.streakCount, 0)
        XCTAssertEqual(state.bestStreakCount, 0)
        XCTAssertEqual(state.streakTier, 0)
        XCTAssertEqual(state.bestStreakTier, 0)
    }

    func testAdaptiveRemediationPlanPrioritizesRecentMissesOverdueCardsAndWeakModules() {
        var now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        let questions = [
            makeQuestion(id: "hazcom-q1"),
            makeQuestion(id: "ppe-q1"),
            makeQuestion(id: "fall-q1"),
            makeQuestion(id: "loto-q1"),
            makeQuestion(id: "noise-q1"),
            makeQuestion(id: "ergo-q1")
        ]

        store.recordQuestionAttempt(questionId: "hazcom-q1", correct: false)
        now = calendar.date(byAdding: .hour, value: 1, to: now)!
        store.recordQuestionAttempt(questionId: "ppe-q1", correct: false)
        store.updateSRCard(questionId: "fall-q1", quality: 1)
        store.recordModuleAnswer(moduleId: "loto", correct: false)
        store.recordModuleAnswer(moduleId: "loto", correct: false)
        store.recordModuleAnswer(moduleId: "loto", correct: true)
        now = calendar.date(byAdding: .day, value: 2, to: now)!

        let plan = store.adaptiveRemediationPlan(from: questions, questionCount: 5)

        XCTAssertEqual(plan.questions.count, 5)
        XCTAssertEqual(plan.items.prefix(2).map(\.reason), [.recentMiss, .recentMiss])
        XCTAssertEqual(plan.items.prefix(2).map(\.question.id), ["ppe-q1", "hazcom-q1"])
        XCTAssertTrue(plan.items.contains(where: { $0.question.id == "fall-q1" && $0.reason == .overdueReview }))
        XCTAssertTrue(plan.items.contains(where: { $0.question.id == "loto-q1" && $0.reason == .weakModule }))
    }

    func testCompleteAdaptiveRemediationAwardsCleanSweepBonusAndTracksDailyFive() {
        var now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        let reward = store.completeAdaptiveRemediation(score: 5, total: 5, streakMultiplier: 1.2)

        XCTAssertEqual(reward.xpGained, 46)
        XCTAssertEqual(store.xp, 46)
        XCTAssertEqual(store.dailyFiveStreak, 1)
        XCTAssertEqual(store.lastDailyFiveScore, 100)
        XCTAssertEqual(store.bestDailyFiveScore, 100)

        now = calendar.date(byAdding: .day, value: 1, to: now)!
        store.recordQuestionAttempt(questionId: "ppe-q1", correct: false)
        _ = store.completeAdaptiveRemediation(score: 3, total: 5)

        XCTAssertEqual(store.dailyFiveStreak, 2)
        XCTAssertEqual(store.lastDailyFiveScore, 60)
        XCTAssertEqual(store.bestDailyFiveScore, 100)
    }

    private func makeQuestion(id: String) -> QuizQuestion {
        QuizQuestion(
            id: id,
            prompt: "Prompt for \(id)",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "\(id)-a", text: "Correct", isCorrect: true),
                QuizChoice(id: "\(id)-b", text: "Wrong", isCorrect: false)
            ]
        )
    }

}
