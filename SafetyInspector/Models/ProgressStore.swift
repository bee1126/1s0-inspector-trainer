import Foundation
import SwiftUI

final class ProgressStore: ObservableObject {
    @Published private(set) var completedModules: Set<String> = []
    @Published private(set) var bestScores: [String: Int] = [:]

    private let completedKey = "completedModules"
    private let scoresKey = "bestScores"

    init() {
        load()
    }

    func markCompleted(moduleId: String, score: Int) {
        completedModules.insert(moduleId)
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

    func resetAll() {
        completedModules = []
        bestScores = [:]
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
    }

    private func save() {
        let defaults = UserDefaults.standard
        if let data = try? JSONEncoder().encode(Array(completedModules)) {
            defaults.set(data, forKey: completedKey)
        }
        if let data = try? JSONEncoder().encode(bestScores) {
            defaults.set(data, forKey: scoresKey)
        }
    }
}
