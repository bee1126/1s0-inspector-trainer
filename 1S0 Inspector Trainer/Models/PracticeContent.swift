import Foundation

enum PracticeContent {
    static let racHazards: [RacHazard] = [
        RacHazard(
            id: "rac-h1",
            title: "Unprotected 30-ft roof edge",
            detail: "Maintenance crews are working within 3 feet of the edge without fall protection.",
            rac: .rac1
        ),
        RacHazard(
            id: "rac-h2",
            title: "Open 480V panel",
            detail: "Electrical panel is open with exposed energized conductors and no barrier.",
            rac: .rac1
        ),
        RacHazard(
            id: "rac-h3",
            title: "Confined space entry without permit",
            detail: "Entry planned with no attendant or documented permit.",
            rac: .rac2
        ),
        RacHazard(
            id: "rac-h4",
            title: "Missing machine guard",
            detail: "Rotating shaft guard removed while equipment is operating.",
            rac: .rac2
        ),
        RacHazard(
            id: "rac-h5",
            title: "Forklift seatbelt not used",
            detail: "Operator is not wearing a seatbelt in a busy pedestrian area.",
            rac: .rac2
        ),
        RacHazard(
            id: "rac-h6",
            title: "Trip hazards in walkway",
            detail: "Cables and boxes are cluttering a primary aisle.",
            rac: .rac3
        ),
        RacHazard(
            id: "rac-h7",
            title: "Hearing protection not worn",
            detail: "Work area averages 90 dBA with no hearing protection in use.",
            rac: .rac3
        ),
        RacHazard(
            id: "rac-h8",
            title: "Unsecured ladder",
            detail: "Extension ladder on uneven surface with no tie-off or spotter.",
            rac: .rac3
        ),
        RacHazard(
            id: "rac-h9",
            title: "Faded safety signage",
            detail: "Eyewash station sign is faded and hard to see.",
            rac: .rac4
        ),
        RacHazard(
            id: "rac-h10",
            title: "Minor spill pending cleanup",
            detail: "Small spill in low-traffic area marked for later cleanup.",
            rac: .rac4
        )
    ]

    static let trueFalseQuestions: [TrueFalseQuestion] = [
        TrueFalseQuestion(
            id: "tf-1",
            statement: "Tags alone provide the same level of protection as locks.",
            answer: false,
            explanation: "Tags warn but do not provide physical restraint. Additional measures are required when tagout is used."
        ),
        TrueFalseQuestion(
            id: "tf-2",
            statement: "In general industry, fall protection is typically required at 4 feet above a lower level.",
            answer: true,
            explanation: "The common threshold in general industry is 4 feet, with specific exceptions handled by policy."
        ),
        TrueFalseQuestion(
            id: "tf-3",
            statement: "During LOTO, each authorized employee applies their own lock.",
            answer: true,
            explanation: "Personal control is a core LOTO requirement."
        ),
        TrueFalseQuestion(
            id: "tf-4",
            statement: "A near miss should be reported even if no injury occurred.",
            answer: true,
            explanation: "Near-miss reporting helps prevent future incidents."
        ),
        TrueFalseQuestion(
            id: "tf-5",
            statement: "Hearing conservation is required only when noise exceeds 100 dBA.",
            answer: false,
            explanation: "Programs often begin at lower thresholds such as 85 dBA based on policy."
        ),
        TrueFalseQuestion(
            id: "tf-6",
            statement: "Risk decisions should consider both severity and probability.",
            answer: true,
            explanation: "Both factors are required to assess risk level."
        ),
        TrueFalseQuestion(
            id: "tf-7",
            statement: "If a device cannot be locked, tagout can be used without extra measures.",
            answer: false,
            explanation: "Equivalent protection requires additional measures beyond a tag."
        ),
        TrueFalseQuestion(
            id: "tf-8",
            statement: "Confined spaces always require a permit.",
            answer: false,
            explanation: "Only permit-required confined spaces need a permit."
        ),
        TrueFalseQuestion(
            id: "tf-9",
            statement: "Controls should follow the hierarchy of controls when possible.",
            answer: true,
            explanation: "Engineering and elimination controls are preferred over PPE alone."
        ),
        TrueFalseQuestion(
            id: "tf-10",
            statement: "A spotter replaces fall protection when working near an unprotected edge.",
            answer: false,
            explanation: "A spotter cannot prevent a fall; protection must be in place."
        ),
        TrueFalseQuestion(
            id: "tf-11",
            statement: "Verification is part of LOTO before servicing begins.",
            answer: true,
            explanation: "Try-out/verification is required before exposure to hazards."
        ),
        TrueFalseQuestion(
            id: "tf-12",
            statement: "Mishap reports should document facts, not speculation.",
            answer: true,
            explanation: "Stick to verifiable information in documentation."
        ),
        TrueFalseQuestion(
            id: "tf-13",
            statement: "PPE selection should be based on a hazard assessment.",
            answer: true,
            explanation: "Identify hazards first, then select PPE that addresses them."
        ),
        TrueFalseQuestion(
            id: "tf-14",
            statement: "If equipment is off, you can skip LOTO.",
            answer: false,
            explanation: "Off is not isolated. LOTO is required when hazardous energy is present."
        )
    ]

    static let microDrillTopics: [MicroDrillTopic] = [
        MicroDrillTopic(
            id: "micro-loto",
            title: "LOTO Micro-Drill",
            detail: "Fast checks on energy control and verification.",
            moduleIds: ["loto"],
            maxQuestions: 5
        ),
        MicroDrillTopic(
            id: "micro-rm",
            title: "Risk Management Micro-Drill",
            detail: "Practice the 5-step RM process.",
            moduleIds: ["risk-management"],
            maxQuestions: 5
        ),
        MicroDrillTopic(
            id: "micro-fall",
            title: "Fall Protection Micro-Drill",
            detail: "Quick checks on PFAS and walking-working surfaces.",
            moduleIds: ["fall-protection"],
            maxQuestions: 5
        ),
        MicroDrillTopic(
            id: "micro-reporting",
            title: "Mishap Reporting Micro-Drill",
            detail: "Test reporting steps and documentation basics.",
            moduleIds: ["mishap-reporting"],
            maxQuestions: 5
        )
    ]

    static var sequenceSets: [SequenceSet] {
        let lotoSteps = lessonBullets(moduleId: "loto", pageId: "loto-3")
        let rmSteps = lessonBullets(moduleId: "risk-management", pageId: "rm-1")
        let mishapSteps = lessonBullets(moduleId: "mishap-reporting", pageId: "mr-2")

        return [
            SequenceSet(
                id: "seq-loto",
                title: "LOTO Sequence",
                detail: "Order the OSHA lockout/tagout steps.",
                steps: lotoSteps
            ),
            SequenceSet(
                id: "seq-rm",
                title: "Risk Management Steps",
                detail: "Put the five RM steps in order.",
                steps: rmSteps
            ),
            SequenceSet(
                id: "seq-reporting",
                title: "Mishap Reporting Actions",
                detail: "Order the immediate reporting actions.",
                steps: mishapSteps
            )
        ].filter { !$0.steps.isEmpty }
    }

    static let onboardingDays: [OnboardingDay] = [
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
                "Complete a Daily 5 session",
                "Run a True/False Blitz"
            ],
            action: .trueFalseBlitz
        ),
        OnboardingDay(
            id: 3,
            title: "Pattern Recognition",
            summary: "Reinforce key terms and responses.",
            tasks: [
                "Complete one Match Sprint",
                "Review two mistakes from the sprint"
            ],
            action: .matchSprint
        ),
        OnboardingDay(
            id: 4,
            title: "RM Focus",
            summary: "Apply the five-step risk management process.",
            tasks: [
                "Run a Risk Management micro-drill",
                "Identify one control you can implement"
            ],
            action: .microDrill
        ),
        OnboardingDay(
            id: 5,
            title: "RAC Practice",
            summary: "Sort hazards by severity and probability.",
            tasks: [
                "Complete a RAC Sort round",
                "Review any missed hazards"
            ],
            action: .racSort
        ),
        OnboardingDay(
            id: 6,
            title: "Sequence Builder",
            summary: "Lock in step-by-step procedures.",
            tasks: [
                "Build one sequence correctly",
                "Run a second sequence if time allows"
            ],
            action: .sequenceBuilder
        ),
        OnboardingDay(
            id: 7,
            title: "Capstone",
            summary: "Put everything together in a reporting module.",
            tasks: [
                "Complete the Mishap Reporting module",
                "Submit one feedback item"
            ],
            action: .module("mishap-reporting")
        )
    ]

    private static func lessonBullets(moduleId: String, pageId: String) -> [String] {
        guard let module = TrainingContent.modules.first(where: { $0.id == moduleId }) else { return [] }
        guard let page = module.lessonPages.first(where: { $0.id == pageId }) else { return [] }
        return page.bullets.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
}

struct RacHazard: Identifiable, Hashable {
    let id: String
    let title: String
    let detail: String
    let rac: RacCategory
}

enum RacCategory: String, CaseIterable, Identifiable {
    case rac1 = "RAC 1"
    case rac2 = "RAC 2"
    case rac3 = "RAC 3"
    case rac4 = "RAC 4"

    var id: String { rawValue }

    var severity: String {
        switch self {
        case .rac1: return "Critical"
        case .rac2: return "Serious"
        case .rac3: return "Moderate"
        case .rac4: return "Minor"
        }
    }

    var description: String {
        switch self {
        case .rac1: return "Immediate danger, high likelihood or severity."
        case .rac2: return "Major injury or high impact possible."
        case .rac3: return "Moderate impact, manageable with controls."
        case .rac4: return "Low impact, minimal operational effect."
        }
    }
}

struct TrueFalseQuestion: Identifiable, Hashable {
    let id: String
    let statement: String
    let answer: Bool
    let explanation: String
}

struct SequenceSet: Identifiable, Hashable {
    let id: String
    let title: String
    let detail: String
    let steps: [String]
}

struct MicroDrillTopic: Identifiable, Hashable {
    let id: String
    let title: String
    let detail: String
    let moduleIds: [String]
    let maxQuestions: Int
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
    case matchSprint
    case racSort
    case sequenceBuilder
    case trueFalseBlitz
    case microDrill
}
