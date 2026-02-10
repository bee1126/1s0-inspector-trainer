import Foundation
import Combine

final class AdaptiveDifficultyManager: ObservableObject {
    @Published private(set) var currentDifficulty: QuizDifficulty = .medium
    @Published private(set) var consecutiveCorrect: Int = 0

    private let defaults: UserDefaults
    private let difficultyKey = "adaptiveDifficulty"
    private let consecutiveCorrectKey = "adaptiveConsecutiveCorrect"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    func recordCorrect() {
        consecutiveCorrect += 1
        if consecutiveCorrect >= 3 {
            currentDifficulty = .hard
        }
        save()
    }

    func recordWrong() {
        currentDifficulty = .medium
        consecutiveCorrect = 0
        save()
    }

    func reset() {
        currentDifficulty = .medium
        consecutiveCorrect = 0
        save()
    }

    private func load() {
        let storedDifficulty = defaults.string(forKey: difficultyKey)
        if let storedDifficulty,
           let parsedDifficulty = QuizDifficulty(rawValue: storedDifficulty),
           parsedDifficulty == .medium || parsedDifficulty == .hard {
            currentDifficulty = parsedDifficulty
        } else {
            currentDifficulty = .medium
        }

        consecutiveCorrect = max(0, defaults.integer(forKey: consecutiveCorrectKey))
        if currentDifficulty == .hard {
            consecutiveCorrect = max(3, consecutiveCorrect)
        } else {
            consecutiveCorrect = min(2, consecutiveCorrect)
        }
    }

    private func save() {
        defaults.set(currentDifficulty.rawValue, forKey: difficultyKey)
        defaults.set(consecutiveCorrect, forKey: consecutiveCorrectKey)
    }
}
