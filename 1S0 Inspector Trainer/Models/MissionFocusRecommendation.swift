import SwiftUI

struct MissionFocusRecommendation: Equatable {
    enum Priority: Equatable {
        case reviewQueue
        case weakModule
        case nextModule
        case maintainReadiness

        var iconName: String {
            switch self {
            case .reviewQueue:
                return "clock.badge.exclamationmark.fill"
            case .weakModule:
                return "scope"
            case .nextModule:
                return "arrow.forward.circle.fill"
            case .maintainReadiness:
                return "shield.checkered"
            }
        }

        var tint: Color {
            switch self {
            case .reviewQueue:
                return AppTheme.accent
            case .weakModule:
                return AppTheme.danger
            case .nextModule:
                return AppTheme.primary
            case .maintainReadiness:
                return AppTheme.info
            }
        }
    }

    enum Destination: Equatable {
        case adaptiveMission
        case module(String)
    }

    let priority: Priority
    let title: String
    let detail: String
    let supportingMetrics: [String]
    let buttonLabel: String
    let destination: Destination

    static func make(modules: [TrainingModule], progress: ProgressStore) -> MissionFocusRecommendation {
        let validModules = modules.filter(\.isIntegrityValid)
        let overdueCountsByModule = progress.overdueCountsByModule()
        let totalDue = overdueCountsByModule.values.reduce(0, +)
        let moduleSnapshots: [ModuleSnapshot] = validModules.map { module in
            let prefix = ModuleHelper.modulePrefix(for: module.quiz.first?.id ?? module.id)
            return ModuleSnapshot(
                module: module,
                proficiency: progress.moduleProficiency[prefix],
                overdueCount: overdueCountsByModule[prefix, default: 0]
            )
        }

        if totalDue > 0 {
            let topReviewModule = moduleSnapshots
                .filter { $0.overdueCount > 0 }
                .sorted { left, right in
                    if left.overdueCount == right.overdueCount {
                        return left.module.title < right.module.title
                    }
                    return left.overdueCount > right.overdueCount
                }
                .first

            let detail: String
            if let topReviewModule {
                detail = "\(totalDue) review card\(totalDue == 1 ? "" : "s") due. \(topReviewModule.module.title) is the biggest backlog, so clear the queue before pushing into new material."
            } else {
                detail = "\(totalDue) review card\(totalDue == 1 ? "" : "s") due. Clear the queue before pushing into new material."
            }

            return MissionFocusRecommendation(
                priority: .reviewQueue,
                title: "Run Adaptive Mission",
                detail: detail,
                supportingMetrics: [
                    "\(totalDue) due",
                    progress.dailyFiveStreak > 0 ? "\(progress.dailyFiveStreak)d streak" : "Review queue"
                ],
                buttonLabel: "Start Review Run",
                destination: .adaptiveMission
            )
        }

        if let weakestModule = moduleSnapshots
            .filter({ ($0.proficiency?.totalAttempts ?? 0) > 0 })
            .sorted(by: weakerModuleFirst)
            .first,
           weakestModule.proficiency?.needsWork == true {
            let recentAccuracy = Int(round((weakestModule.proficiency?.recentAccuracy ?? 0) * 100))
            return MissionFocusRecommendation(
                priority: .weakModule,
                title: "Reinforce \(weakestModule.module.title)",
                detail: "Recent accuracy is \(recentAccuracy)% in this module. A focused refresher now will tighten the gap before it becomes a pattern.",
                supportingMetrics: [
                    "\(recentAccuracy)% recent",
                    "Best \(progress.bestScore(for: weakestModule.module.id))%"
                ],
                buttonLabel: "Open Refresher Module",
                destination: .module(weakestModule.module.id)
            )
        }

        if let nextModule = validModules.first(where: { !progress.isCompleted($0.id) }) {
            return MissionFocusRecommendation(
                priority: .nextModule,
                title: "Start \(nextModule.title)",
                detail: nextModule.subtitle,
                supportingMetrics: [
                    "\(nextModule.estimatedMinutes) min",
                    nextModule.difficulty
                ],
                buttonLabel: "Open Module",
                destination: .module(nextModule.id)
            )
        }

        return MissionFocusRecommendation(
            priority: .maintainReadiness,
            title: "Maintain Readiness",
            detail: "Core training is complete. Keep recall sharp with an adaptive mission built from your review history and weak spots.",
            supportingMetrics: [
                "\(progress.dailyFiveStreak)d streak",
                "Best \(progress.bestDailyFiveScore)%"
            ],
            buttonLabel: "Run Adaptive Mission",
            destination: .adaptiveMission
        )
    }

    private static func weakerModuleFirst(_ left: ModuleSnapshot, _ right: ModuleSnapshot) -> Bool {
        let leftAccuracy = left.proficiency?.recentAccuracy ?? 0
        let rightAccuracy = right.proficiency?.recentAccuracy ?? 0
        if leftAccuracy == rightAccuracy {
            if left.overdueCount == right.overdueCount {
                return left.module.title < right.module.title
            }
            return left.overdueCount > right.overdueCount
        }
        return leftAccuracy < rightAccuracy
    }

    private struct ModuleSnapshot {
        let module: TrainingModule
        let proficiency: ModuleProficiency?
        let overdueCount: Int
    }
}
