import Foundation
import SwiftUI

final class ProgressStore: ObservableObject {
    @Published private(set) var completedModules: Set<String> = []
    @Published private(set) var bestScores: [String: Int] = [:]
    @Published private(set) var lastCompleted: [String: Date] = [:]
    @Published private(set) var perfectScenario: Set<String> = []
    @Published private(set) var perfectQuiz: Set<String> = []
    @Published private(set) var dailyStreak: Int = 0
    @Published private(set) var lastDailyDate: Date? = nil
    @Published private(set) var bestDailyScore: Int = 0

    private let completedKey = "completedModules"
    private let scoresKey = "bestScores"
    private let completedDatesKey = "completedDates"
    private let perfectScenarioKey = "perfectScenario"
    private let perfectQuizKey = "perfectQuiz"
    private let dailyStreakKey = "dailyStreak"
    private let lastDailyKey = "lastDaily"
    private let bestDailyKey = "bestDaily"

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
        dailyStreak = 0
        lastDailyDate = nil
        bestDailyScore = 0
        save()
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
        if let date = defaults.object(forKey: lastDailyKey) as? Date {
            lastDailyDate = date
        }
        dailyStreak = defaults.integer(forKey: dailyStreakKey)
        bestDailyScore = defaults.integer(forKey: bestDailyKey)
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
        defaults.set(dailyStreak, forKey: dailyStreakKey)
        defaults.set(bestDailyScore, forKey: bestDailyKey)
        defaults.set(lastDailyDate, forKey: lastDailyKey)
    }

    func recordDailyFive(score: Int, total: Int) {
        let today = Calendar.current.startOfDay(for: Date())
        if let last = lastDailyDate {
            let lastDay = Calendar.current.startOfDay(for: last)
            let diff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if diff == 1 {
                dailyStreak += 1
            } else if diff > 1 {
                dailyStreak = 1
            }
        } else {
            dailyStreak = 1
        }
        lastDailyDate = today
        let percent = total > 0 ? Int(round(Double(score) / Double(total) * 100)) : 0
        bestDailyScore = max(bestDailyScore, percent)
        save()
    }
}
