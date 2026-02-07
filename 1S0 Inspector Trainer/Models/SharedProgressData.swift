import Foundation

struct SharedProgressData: Codable {
    let xp: Int
    let level: Int
    let dailyXp: Int
    let dailyGoal: Int
    let dailyStreak: Int
    let hearts: Int
    let maxHearts: Int
    let completedModuleCount: Int
    let totalModuleCount: Int
    let overdueReviewCount: Int
    let lastUpdated: Date

    static let suiteName = "group.com.yourteam.inspectortrainer"
    static let key = "widget_progress_snapshot"
}
