import Foundation

enum PracticeContent {

    static func onboardingDays(for role: TrainingRole?) -> [OnboardingDay] {
        oneS0OnboardingDays
    }

    private static let oneS0OnboardingDays: [OnboardingDay] = [
        OnboardingDay(
            id: 1,
            title: "Mission Start",
            summary: "Get familiar with core safety expectations.",
            tasks: [
                "Start the Lockout/Tagout module",
                "Review the learning objectives"
            ],
            action: .module("loto")
        ),
        OnboardingDay(
            id: 2,
            title: "Daily Rhythm",
            summary: "Build a daily practice habit.",
            tasks: [
                "Complete a Fall Protection module",
                "Review any missed quiz questions"
            ],
            action: .module("fall-protection")
        ),
        OnboardingDay(
            id: 3,
            title: "Risk Foundations",
            summary: "Reinforce the five-step RM process.",
            tasks: [
                "Complete the Risk Management module",
                "Review the scenario decisions"
            ],
            action: .module("risk-management")
        ),
        OnboardingDay(
            id: 4,
            title: "Program Responsibilities",
            summary: "Understand how 1S0 inspectors, commanders, and supervisors share safety responsibilities.",
            tasks: [
                "Complete the Program Responsibilities module",
                "Review the 1S0 inspector responsibilities"
            ],
            action: .module("roles-responsibilities")
        ),
        OnboardingDay(
            id: 5,
            title: "Specialty Topics",
            summary: "Dive into confined space and hot work controls.",
            tasks: [
                "Complete the Confined Space module",
                "Review permit-required entry procedures"
            ],
            action: .module("confined-space")
        ),
        OnboardingDay(
            id: 6,
            title: "Capstone",
            summary: "Put everything together in a reporting module.",
            tasks: [
                "Complete the Mishap Reporting module",
                "Submit one feedback item"
            ],
            action: .module("mishap-reporting")
        ),
        OnboardingDay(
            id: 7,
            title: "Daily Five Launch",
            summary: "Lock in a repeatable daily readiness check.",
            tasks: [
                "Run the Daily Five challenge",
                "Review your score and keep the streak alive"
            ],
            action: .dailyFive
        )
    ]

}

struct OnboardingDay: Identifiable, Hashable {
    let id: Int
    let title: String
    let summary: String
    let tasks: [String]
    let action: OnboardingAction?
}

enum OnboardingAction: Hashable {
    case module(String)
    case dailyFive
}
