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
}
