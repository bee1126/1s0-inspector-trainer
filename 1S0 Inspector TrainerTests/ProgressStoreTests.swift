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

    func testOnboardingProgressIsSeparatedByRole() {
        let now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        store.setRole(.usr)
        store.startOnboardingIfNeeded()
        _ = store.checkInOnboardingDay()
        XCTAssertEqual(store.onboardingCheckIns, [1])

        store.setRole(.oneS0)
        XCTAssertNil(store.onboardingStartDate)
        XCTAssertTrue(store.onboardingCheckIns.isEmpty)

        store.startOnboardingIfNeeded()
        _ = store.checkInOnboardingDay()
        XCTAssertEqual(store.onboardingCheckIns, [1])

        store.setRole(.usr)
        XCTAssertEqual(store.onboardingCheckIns, [1])
    }

    func testProcedureDrillRunPersistsSameDay() {
        var now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        let run = makeProcedureDrillRun(setId: "proc-loto-deenergize", updatedAt: now)

        store.saveProcedureDrillRun(run, for: .oneS0)

        let loaded = store.procedureDrillRun(for: .oneS0)
        XCTAssertEqual(loaded?.roundSetIds, run.roundSetIds)
        XCTAssertEqual(loaded?.rounds.first?.currentOrder, run.rounds.first?.currentOrder)
        XCTAssertEqual(loaded?.currentRoundIndex, 0)
    }

    func testProcedureDrillRunExpiresAfterDayChange() {
        var now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })
        let run = makeProcedureDrillRun(setId: "proc-rm-five-step", updatedAt: now)

        store.saveProcedureDrillRun(run, for: .oneS0)
        XCTAssertNotNil(store.procedureDrillRun(for: .oneS0))

        now = calendar.date(byAdding: .day, value: 1, to: now)!
        XCTAssertNil(store.procedureDrillRun(for: .oneS0))
    }

    func testProcedureDrillRunSeparatedByRole() {
        let now = Date(timeIntervalSince1970: 0)
        let store = ProgressStore(defaults: defaults, calendar: calendar, dateProvider: { now })

        store.saveProcedureDrillRun(makeProcedureDrillRun(setId: "proc-hot-work-cycle", updatedAt: now), for: .oneS0)
        store.saveProcedureDrillRun(makeProcedureDrillRun(setId: "usr-proc-spot-inspection", updatedAt: now), for: .usr)

        XCTAssertEqual(store.procedureDrillRun(for: .oneS0)?.roundSetIds.first, "proc-hot-work-cycle")
        XCTAssertEqual(store.procedureDrillRun(for: .usr)?.roundSetIds.first, "usr-proc-spot-inspection")
    }

    func testProcedureDrillRoundScoreAppliesFailedCheckPenalty() {
        let score = ProcedureDrillScoring.roundScore(correctPlacements: 5, failedChecks: 2, totalSteps: 8)
        XCTAssertEqual(score, 3)
    }

    func testProcedureDrillRoundScoreClampsAtZero() {
        let score = ProcedureDrillScoring.roundScore(correctPlacements: 1, failedChecks: 4, totalSteps: 6)
        XCTAssertEqual(score, 0)
    }

    func testProcedureDrillAggregateScoreUsesWeightedTotals() {
        let rounds = [
            ProcedureDrillRoundOutcome(correctPlacements: 5, failedChecks: 1, totalSteps: 8),
            ProcedureDrillRoundOutcome(correctPlacements: 3, failedChecks: 0, totalSteps: 5),
            ProcedureDrillRoundOutcome(correctPlacements: 4, failedChecks: 2, totalSteps: 7)
        ]

        let result = ProcedureDrillScoring.aggregateScore(rounds: rounds)

        XCTAssertEqual(result.score, 9)
        XCTAssertEqual(result.total, 20)
    }

    private func makeProcedureDrillRun(setId: String, updatedAt: Date) -> ProcedureDrillRunState {
        ProcedureDrillRunState(
            roundSetIds: [setId, setId, setId],
            rounds: [
                ProcedureDrillRoundState(
                    setId: setId,
                    currentOrder: [0, 1, 2],
                    failedChecks: 0,
                    finalCorrectPlacements: nil,
                    finalScore: nil,
                    didAutoSubmit: false,
                    isComplete: false
                )
            ],
            currentRoundIndex: 0,
            startedAt: updatedAt,
            updatedAt: updatedAt
        )
    }
}
