import XCTest
@testable import _S0_Inspector_Trainer

final class AdaptiveDifficultyManagerTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "AdaptiveDifficultyManagerTests.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            fatalError("Unable to create UserDefaults suite")
        }
        defaults.removePersistentDomain(forName: suiteName)
        self.defaults = defaults
    }

    override func tearDown() {
        if let suiteName {
            defaults.removePersistentDomain(forName: suiteName)
        }
        defaults = nil
        suiteName = nil
        super.tearDown()
    }

    func testDefaultStateIsMediumWithZeroCounter() {
        let manager = AdaptiveDifficultyManager(defaults: defaults)

        XCTAssertEqual(manager.currentDifficulty, .medium)
        XCTAssertEqual(manager.consecutiveCorrect, 0)
    }

    func testThreeConsecutiveCorrectAnswersPromotesToHard() {
        let manager = AdaptiveDifficultyManager(defaults: defaults)

        manager.recordCorrect()
        manager.recordCorrect()
        XCTAssertEqual(manager.currentDifficulty, .medium)
        XCTAssertEqual(manager.consecutiveCorrect, 2)

        manager.recordCorrect()

        XCTAssertEqual(manager.currentDifficulty, .hard)
        XCTAssertEqual(manager.consecutiveCorrect, 3)
    }

    func testWrongAnswerResetsDifficultyAndCounter() {
        let manager = AdaptiveDifficultyManager(defaults: defaults)

        manager.recordCorrect()
        manager.recordCorrect()
        manager.recordCorrect()
        XCTAssertEqual(manager.currentDifficulty, .hard)

        manager.recordWrong()

        XCTAssertEqual(manager.currentDifficulty, .medium)
        XCTAssertEqual(manager.consecutiveCorrect, 0)
    }

    func testStatePersistsAcrossManagerInstances() {
        let firstManager = AdaptiveDifficultyManager(defaults: defaults)
        firstManager.recordCorrect()
        firstManager.recordCorrect()

        let secondManager = AdaptiveDifficultyManager(defaults: defaults)
        XCTAssertEqual(secondManager.currentDifficulty, .medium)
        XCTAssertEqual(secondManager.consecutiveCorrect, 2)

        secondManager.recordCorrect()

        let thirdManager = AdaptiveDifficultyManager(defaults: defaults)
        XCTAssertEqual(thirdManager.currentDifficulty, .hard)
        XCTAssertEqual(thirdManager.consecutiveCorrect, 3)
    }

    func testInvalidPersistedDifficultyCoercesToMedium() {
        defaults.set(QuizDifficulty.easy.rawValue, forKey: "adaptiveDifficulty")
        defaults.set(1, forKey: "adaptiveConsecutiveCorrect")

        let manager = AdaptiveDifficultyManager(defaults: defaults)

        XCTAssertEqual(manager.currentDifficulty, .medium)
        XCTAssertEqual(manager.consecutiveCorrect, 1)
    }
}
