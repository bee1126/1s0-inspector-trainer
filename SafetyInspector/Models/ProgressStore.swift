import Foundation
import SwiftUI

final class ProgressStore: ObservableObject {
    @Published private(set) var completedModules: Set<String> = []
    @Published private(set) var bestScores: [String: Int] = [:]
    @Published private(set) var lastCompleted: [String: Date] = [:]

    private let completedKey = "completedModules"
    private let scoresKey = "bestScores"
    private let completedDatesKey = "completedDates"

    init() {
        load()
    }

    func markCompleted(moduleId: String, score: Int) {
        completedModules.insert(moduleId)
        lastCompleted[moduleId] = Date()
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
    }
}
