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
        let now = Date(timeIntervalSince1970: 0)
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
        let now = Date(timeIntervalSince1970: 0)
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

    func testLegacyUnknownSelectionFallsBackToOneS0() {
        defaults.set("legacy-role", forKey: "selectedRole")

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

    func testEpubsFavoritesAndRevisionStatePersist() {
        var now = Date(timeIntervalSince1970: 1_000)
        let firstStore = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        let firstMetadata = EpubsRemoteMetadata(
            etag: "revision-a",
            lastModified: "Mon, 01 Jun 2026 12:00:00 GMT",
            contentLength: 1_024
        )

        firstStore.toggleFavoriteEpubPublication("dafi91-202")
        firstStore.recordEpubsChecks(["dafi91-202": firstMetadata])

        XCTAssertTrue(firstStore.isFavoriteEpubPublication("dafi91-202"))
        XCTAssertFalse(firstStore.epubPublicationSnapshots["dafi91-202"]?.hasUnreadRevision ?? true)

        now = Date(timeIntervalSince1970: 2_000)
        let revisedMetadata = EpubsRemoteMetadata(
            etag: "revision-b",
            lastModified: "Tue, 02 Jun 2026 12:00:00 GMT",
            contentLength: 2_048
        )
        firstStore.recordEpubsChecks(["dafi91-202": revisedMetadata])

        XCTAssertTrue(firstStore.epubPublicationSnapshots["dafi91-202"]?.hasUnreadRevision ?? false)
        XCTAssertEqual(firstStore.epubPublicationSnapshots["dafi91-202"]?.lastChecked, now)

        let secondStore = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        XCTAssertTrue(secondStore.isFavoriteEpubPublication("dafi91-202"))
        XCTAssertTrue(secondStore.epubPublicationSnapshots["dafi91-202"]?.hasUnreadRevision ?? false)

        secondStore.markEpubsPublicationViewed("dafi91-202")
        let thirdStore = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        XCTAssertFalse(thirdStore.epubPublicationSnapshots["dafi91-202"]?.hasUnreadRevision ?? true)
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
        let planSummary = plan.items.map { "\($0.question.id):\($0.reason.rawValue)" }.joined(separator: ", ")
        XCTAssertTrue(
            plan.items.contains(where: { $0.question.id == "fall-q1" && $0.reason == .overdueReview }),
            planSummary
        )
        XCTAssertTrue(
            plan.items.contains(where: { $0.question.id == "loto-q1" && $0.reason == .weakModule }),
            planSummary
        )
    }

    func testOverdueCountsByModuleGroupsDueCards() {
        var now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        store.updateSRCard(questionId: "loto-q1", quality: 1)
        store.updateSRCard(questionId: "loto-q2", quality: 1)
        store.updateSRCard(questionId: "fall-q1", quality: 1)

        XCTAssertTrue(store.overdueCountsByModule().isEmpty)

        now = calendar.date(byAdding: .day, value: 2, to: now)!

        XCTAssertEqual(store.overdueCountsByModule()["loto"], 2)
        XCTAssertEqual(store.overdueCountsByModule()["fall"], 1)
        XCTAssertEqual(store.overdueCount(), 3)
        XCTAssertEqual(store.overdueCount(for: "loto"), 2)
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

    func testMissionFocusRecommendationPrioritizesReviewQueue() {
        var now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        store.updateSRCard(questionId: "loto-q1", quality: 1)
        now = calendar.date(byAdding: .day, value: 2, to: now)!

        let recommendation = MissionFocusRecommendation.make(
            modules: TrainingContent.modules(for: store.selectedRole),
            progress: store
        )

        XCTAssertEqual(recommendation.priority, .reviewQueue)
        XCTAssertEqual(recommendation.destination, .adaptiveMission)
        XCTAssertEqual(recommendation.buttonLabel, "Start Review Run")
    }

    func testMissionFocusRecommendationTargetsWeakModuleBeforeNewContent() {
        let now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        store.recordModuleAnswer(moduleId: "loto", correct: false)
        store.recordModuleAnswer(moduleId: "loto", correct: false)
        store.recordModuleAnswer(moduleId: "loto", correct: true)

        let recommendation = MissionFocusRecommendation.make(
            modules: TrainingContent.modules(for: store.selectedRole),
            progress: store
        )

        XCTAssertEqual(recommendation.priority, .weakModule)
        XCTAssertEqual(recommendation.destination, .module("loto"))
        XCTAssertEqual(recommendation.buttonLabel, "Open Refresher Module")
    }

    func testMissionFocusRecommendationDefaultsToNextIncompleteModule() {
        let now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        let recommendation = MissionFocusRecommendation.make(
            modules: TrainingContent.modules(for: store.selectedRole),
            progress: store
        )

        XCTAssertEqual(recommendation.priority, .nextModule)
        XCTAssertEqual(recommendation.destination, .module("loto"))
        XCTAssertEqual(recommendation.buttonLabel, "Open Module")
    }

    func testMissionFocusRecommendationFallsBackToMaintainReadinessWhenModulesAreComplete() {
        let now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        for module in TrainingContent.modules(for: store.selectedRole) {
            store.markCompleted(moduleId: module.id, score: 100, scenarioPerfect: true, quizPerfect: true)
        }

        let recommendation = MissionFocusRecommendation.make(
            modules: TrainingContent.modules(for: store.selectedRole),
            progress: store
        )

        XCTAssertEqual(recommendation.priority, .maintainReadiness)
        XCTAssertEqual(recommendation.destination, .adaptiveMission)
        XCTAssertEqual(recommendation.buttonLabel, "Run Adaptive Mission")
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

extension ProgressStoreTests {
    private func studyStore() -> ProgressStore {
        ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { Date(timeIntervalSince1970: 1_000_000) })
    }
    private var bank: [QuizQuestion] { TrainingContent.allQuizQuestions(for: .oneS0) }

    func testStudyMigrationPreservesLegacyProgress() {
        defaults.set(240, forKey: "xpTotal")
        defaults.set(7, forKey: "dailyStreak")
        let store = studyStore()
        XCTAssertEqual(store.xp, 240)
        XCTAssertEqual(store.dailyStreak, 7)
        XCTAssertNil(store.activeStudySession)
        XCTAssertTrue(store.studyHistory.isEmpty)
        store.toggleSavedQuestion(bank[0].id)
        let restored = studyStore()
        XCTAssertEqual(restored.xp, 240)
        XCTAssertTrue(restored.isQuestionSaved(bank[0].id))
    }

    func testStudyFiltersIntersectAndNeverSubstituteOrDuplicate() {
        let store = studyStore()
        let q = bank[0]
        store.toggleSavedQuestion(q.id)
        let matching = store.studyQuestions(for: StudyConfiguration(pool: .saved, moduleIDs: [ModuleHelper.modulePrefix(for: q.id)], difficulty: q.difficulty), from: bank + bank)
        XCTAssertEqual(matching.map(\.id), [q.id])
        XCTAssertTrue(store.studyQuestions(for: StudyConfiguration(pool: .saved, moduleIDs: ["missing"]), from: bank).isEmpty)
        XCTAssertFalse(store.startStudySession(configuration: StudyConfiguration(pool: .due), questions: bank))
        XCTAssertTrue(store.startStudySession(configuration: StudyConfiguration(pool: .saved, questionCount: 20), questions: bank))
        XCTAssertEqual(store.activeStudySession?.questions.count, 1)
    }

    func testStudyResumePreservesAnswersOrderAndIndependentModuleState() throws {
        let store = studyStore()
        store.updateResume(moduleId: "loto", stage: .lesson, lessonIndex: 1)
        XCTAssertTrue(store.startStudySession(configuration: StudyConfiguration(mode: .exam, questionCount: 5), questions: bank))
        let session = try XCTUnwrap(store.activeStudySession)
        let first = session.questions[0]
        store.selectStudyAnswer(questionID: first.id, choiceID: first.choices[0].id)
        store.moveStudyQuestion(to: 3)
        let restored = studyStore()
        XCTAssertEqual(restored.activeStudySession?.id, session.id)
        XCTAssertEqual(restored.activeStudySession?.questions, session.questions)
        XCTAssertEqual(restored.activeStudySession?.answers[first.id], first.choices[0].id)
        XCTAssertEqual(restored.activeStudySession?.index, 3)
        XCTAssertEqual(restored.resumeState?.lessonIndex, 1)
        XCTAssertFalse(restored.startStudySession(configuration: StudyConfiguration(), questions: bank))
    }

    func testStudyLocksAnswerAndUpdatesLearningOnce() throws {
        let store = studyStore()
        XCTAssertTrue(store.startStudySession(configuration: StudyConfiguration(questionCount: 5), questions: bank))
        let q = try XCTUnwrap(store.activeStudySession?.questions.first)
        let correct = try XCTUnwrap(q.choices.first(where: \.isCorrect))
        store.selectStudyAnswer(questionID: q.id, choiceID: correct.id)
        store.selectStudyAnswer(questionID: q.id, choiceID: q.choices.first(where: { !$0.isCorrect })!.id)
        XCTAssertEqual(store.activeStudySession?.answers[q.id], correct.id)
        XCTAssertEqual(store.moduleProficiency[ModuleHelper.modulePrefix(for: q.id)]?.totalAttempts, 1)
        XCTAssertEqual(store.xp, 0)
    }

    func testExamDefersLearningAllowsEditsAndCommitsExactlyOnce() throws {
        let store = studyStore()
        let adaptive = AdaptiveDifficultyManager(defaults: defaults)
        XCTAssertTrue(store.startStudySession(configuration: StudyConfiguration(mode: .exam, questionCount: 5), questions: bank))
        let session = try XCTUnwrap(store.activeStudySession)
        let q = session.questions[0]
        store.selectStudyAnswer(questionID: q.id, choiceID: q.choices.first(where: { !$0.isCorrect })!.id)
        XCTAssertNil(store.finishStudySession(id: session.id, questions: bank))
        for question in session.questions {
            store.selectStudyAnswer(questionID: question.id, choiceID: question.choices.first(where: \.isCorrect)!.id)
        }
        XCTAssertTrue(store.srCards.isEmpty)
        XCTAssertTrue(store.moduleProficiency.isEmpty)
        XCTAssertEqual(store.xp, 0)
        let result = try XCTUnwrap(store.finishStudySession(id: session.id, questions: bank))
        XCTAssertEqual(result.score, 5)
        XCTAssertEqual(store.xp, 35)
        XCTAssertEqual(store.dailyFiveStreak, 0)
        XCTAssertEqual(store.moduleProficiency.values.reduce(0) { $0 + $1.totalAttempts }, 5)
        XCTAssertEqual(adaptive.currentDifficulty, .medium)
        XCTAssertEqual(adaptive.consecutiveCorrect, 0)
        XCTAssertNil(store.activeStudySession)
        XCTAssertNotNil(store.finishStudySession(id: session.id, questions: bank))
        let restored = studyStore()
        XCTAssertNotNil(restored.finishStudySession(id: session.id, questions: bank))
        XCTAssertEqual(restored.xp, 35)
        XCTAssertEqual(restored.studyHistory.count, 1)
        XCTAssertEqual(restored.moduleProficiency.values.reduce(0) { $0 + $1.totalAttempts }, 5)
    }

    func testStudyContentChangeInvalidatesUnfinishedSession() throws {
        let store = studyStore()
        XCTAssertTrue(store.startStudySession(configuration: StudyConfiguration(), questions: bank))
        let session = try XCTUnwrap(store.activeStudySession)
        XCTAssertTrue(store.studySessionIsValid(questions: bank))
        XCTAssertFalse(store.studySessionIsValid(questions: bank.filter { $0.id != session.questions[0].id }))
        store.discardStudySession()
        XCTAssertNil(studyStore().activeStudySession)
        XCTAssertEqual(store.xp, 0)
    }

    func testUnresolvedMissesDoNotDisappearAfterTwentyFourOtherMisses() {
        let store = studyStore()
        for q in bank.prefix(30) { store.recordQuestionAttempt(questionId: q.id, correct: false) }
        XCTAssertEqual(store.studyQuestions(for: StudyConfiguration(pool: .missed), from: bank).count, 30)
        store.recordQuestionAttempt(questionId: bank[0].id, correct: true)
        XCTAssertEqual(studyStore().studyQuestions(for: StudyConfiguration(pool: .missed), from: bank).count, 29)
    }

    func testAllMatchingLengthAndInvalidSelections() throws {
        let store = studyStore()
        XCTAssertTrue(store.startStudySession(configuration: StudyConfiguration(questionCount: 0), questions: bank + bank))
        XCTAssertEqual(store.activeStudySession?.questions.count, 140)
        store.selectStudyAnswer(questionID: bank[0].id, choiceID: "not-a-choice")
        store.moveStudyQuestion(to: -1)
        store.moveStudyQuestion(to: 999)
        XCTAssertEqual(store.activeStudySession?.index, 0)
        let session = try XCTUnwrap(store.activeStudySession)
        XCTAssertTrue(session.answers.isEmpty)
    }

    func testHistoryPruningDoesNotAllowOldDailyRewardAgain() {
        let store = studyStore()
        let oldestID = UUID()
        store.recordQuizHistory(id: oldestID, kind: .dailyFive, questions: Array(bank.prefix(5)), answers: [:], result: AssessmentResult(score: 5, total: 5))
        let xp = store.xp
        for _ in 0..<201 {
            store.recordQuizHistory(id: UUID(), kind: .module, questions: [bank[0]], answers: [:], result: AssessmentResult(score: 1, total: 1))
        }
        XCTAssertEqual(store.studyHistory.count, 200)
        XCTAssertFalse(store.studyHistory.contains { $0.id == oldestID })
        let restored = studyStore()
        XCTAssertNil(restored.recordQuizHistory(id: oldestID, kind: .dailyFive, questions: Array(bank.prefix(5)), answers: [:], result: AssessmentResult(score: 5, total: 5)))
        XCTAssertEqual(restored.xp, xp)
        XCTAssertEqual(restored.dailyFiveStreak, 1)
    }

    func testResetClearsNewStateAndBookmarkReviewDoesNotAwardXP() {
        let store = studyStore()
        store.toggleSavedQuestion(bank[0].id)
        _ = store.studyQuestions(for: StudyConfiguration(pool: .saved), from: bank)
        XCTAssertEqual(store.xp, 0)
        XCTAssertTrue(store.startStudySession(configuration: StudyConfiguration(), questions: bank))
        store.resetAll()
        let restored = studyStore()
        XCTAssertFalse(restored.isQuestionSaved(bank[0].id))
        XCTAssertNil(restored.activeStudySession)
        XCTAssertTrue(restored.studyHistory.isEmpty)
    }
}

extension ProgressStoreTests {
    func testStudyTopicFiltersResolveEveryModuleID() {
        let store = studyStore()
        for module in TrainingContent.modules(for: .oneS0) {
            let questions = store.studyQuestions(for: StudyConfiguration(moduleIDs: [module.id]), from: bank)
            XCTAssertEqual(Set(questions.map(\.id)), Set(module.quiz.map(\.id)), module.id)
        }
    }

    func testStudyDifficultyAndDebriefMissesAreStrictFilters() {
        let store = studyStore()
        let selected = Set(bank.prefix(20).map(\.id))
        let questions = store.studyQuestions(for: StudyConfiguration(difficulty: .hard, questionIDs: selected), from: bank)
        XCTAssertTrue(questions.allSatisfy { $0.difficulty == .hard && selected.contains($0.id) })
        XCTAssertEqual(questions.count, bank.prefix(20).filter { $0.difficulty == .hard }.count)
    }

    func testModuleRewardRemainsIdempotentAfterPendingCompletionCleared() {
        let store = studyStore()
        let id = UUID()
        let result = AssessmentResult(score: 10, total: 10)
        store.recordQuizHistory(id: id, kind: .module, questions: Array(bank.prefix(10)), answers: [:], result: result)
        let first = store.completeModule(moduleId: "loto", score: 100, scenarioResult: result, quizResult: result, sessionID: id)
        store.clearPendingCompletion(for: "loto")
        let restored = studyStore()
        let second = restored.completeModule(moduleId: "loto", score: 100, scenarioResult: result, quizResult: result, sessionID: id)
        XCTAssertEqual(second.xpGained, 0)
        XCTAssertEqual(restored.xp, first.xpGained)
        XCTAssertEqual(restored.studyHistory.first?.xpEarned, first.xpGained)
    }

    func testRetiredQuestionReviewDoesNotRecommendUnavailableCards() {
        var now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        store.updateSRCard(questionId: "loto-q6", quality: 1)
        now.addTimeInterval(10 * 86400)
        XCTAssertEqual(store.overdueCount(), 0)
        XCTAssertNotNil(store.srCards["loto-q6"], "Historical state is preserved, but retired cards are not scheduled.")
    }

    func testStudySubmissionUsesInjectedDayAfterMidnight() throws {
        var now = Date(timeIntervalSince1970: 86_390)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        XCTAssertTrue(store.startStudySession(configuration: StudyConfiguration(mode: .exam, questionCount: 5), questions: bank))
        let session = try XCTUnwrap(store.activeStudySession)
        for q in session.questions { store.selectStudyAnswer(questionID: q.id, choiceID: q.choices.first(where: \.isCorrect)!.id) }
        now.addTimeInterval(20)
        let entry = try XCTUnwrap(store.finishStudySession(id: session.id, questions: bank))
        XCTAssertEqual(entry.completedAt, now)
        XCTAssertEqual(store.dailyXp, 35)
        XCTAssertEqual(store.dailyStreak, 1)
        XCTAssertEqual(store.lastDailyGoalDate, calendar.startOfDay(for: now))
    }

    func testUnfinishedExamDiscardDoesNotRecordAnswers() throws {
        let store = studyStore()
        XCTAssertTrue(store.startStudySession(configuration: StudyConfiguration(mode: .exam), questions: bank))
        let question = try XCTUnwrap(store.activeStudySession?.questions.first)
        store.selectStudyAnswer(questionID: question.id, choiceID: question.choices[0].id)
        store.discardStudySession()
        let restored = studyStore()
        XCTAssertEqual(restored.xp, 0)
        XCTAssertTrue(restored.srCards.isEmpty)
        XCTAssertTrue(restored.moduleProficiency.isEmpty)
        XCTAssertTrue(restored.studyHistory.isEmpty)
    }
}
