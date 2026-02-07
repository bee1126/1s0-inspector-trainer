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

    static func trueFalseQuestions(for role: TrainingRole?) -> [TrueFalseQuestion] {
        switch role {
        case .usr:
            return usrTrueFalseQuestions
        case .oneS0, .none:
            return oneS0TrueFalseQuestions
        }
    }

    static func microDrillTopics(for role: TrainingRole?) -> [MicroDrillTopic] {
        switch role {
        case .usr:
            return usrMicroDrillTopics
        case .oneS0, .none:
            return oneS0MicroDrillTopics
        }
    }

    static func sequenceSets(for role: TrainingRole?) -> [SequenceSet] {
        switch role {
        case .usr:
            let hazardSteps = lessonBullets(moduleId: "usr-hazard-reporting", pageId: "usr-hazard-steps", role: .usr)
            let inspectionSteps = lessonBullets(moduleId: "usr-spot-inspections", pageId: "usr-spot-steps", role: .usr)
            let mishapSteps = lessonBullets(moduleId: "usr-mishap-reporting", pageId: "usr-mishap-steps", role: .usr)

            return [
                SequenceSet(
                    id: "usr-seq-hazard-reporting",
                    title: "Hazard Reporting Flow",
                    detail: "Order the USR hazard reporting and tracking steps.",
                    steps: hazardSteps
                ),
                SequenceSet(
                    id: "usr-seq-spot-inspection",
                    title: "Spot Inspection Flow",
                    detail: "Put the USR spot inspection actions in order.",
                    steps: inspectionSteps
                ),
                SequenceSet(
                    id: "usr-seq-mishap-reporting",
                    title: "Mishap Reporting Flow",
                    detail: "Order the immediate USR mishap reporting actions.",
                    steps: mishapSteps
                )
            ].filter { !$0.steps.isEmpty }
        case .oneS0, .none:
            let lotoSteps = lessonBullets(moduleId: "loto", pageId: "loto-3", role: .oneS0)
            let rmSteps = lessonBullets(moduleId: "risk-management", pageId: "rm-1", role: .oneS0)
            let mishapSteps = lessonBullets(moduleId: "mishap-reporting", pageId: "mr-2", role: .oneS0)

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
    }

    static func onboardingDays(for role: TrainingRole?) -> [OnboardingDay] {
        switch role {
        case .usr:
            return usrOnboardingDays
        case .oneS0, .none:
            return oneS0OnboardingDays
        }
    }

    private static let oneS0TrueFalseQuestions: [TrueFalseQuestion] = [
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

    private static let usrTrueFalseQuestions: [TrueFalseQuestion] = [
        TrueFalseQuestion(
            id: "usr-tf-1",
            statement: "The USR replaces supervisor responsibility for day-to-day safety enforcement.",
            answer: false,
            explanation: "Supervisors remain responsible for daily execution; the USR supports and tracks."
        ),
        TrueFalseQuestion(
            id: "usr-tf-2",
            statement: "Near misses should be reported even if no one is injured.",
            answer: true,
            explanation: "Near-miss reporting helps identify hazards before injuries occur."
        ),
        TrueFalseQuestion(
            id: "usr-tf-3",
            statement: "Hazards can be closed once a plan is written, even if controls are not implemented.",
            answer: false,
            explanation: "Hazards close only after corrective action is complete and verified."
        ),
        TrueFalseQuestion(
            id: "usr-tf-4",
            statement: "A strong hazard report includes location, observed condition, and exposure details.",
            answer: true,
            explanation: "Clear details make corrective action and follow-up possible."
        ),
        TrueFalseQuestion(
            id: "usr-tf-5",
            statement: "Interim controls are temporary measures until permanent abatement is completed.",
            answer: true,
            explanation: "Interim controls reduce risk while the long-term fix is developed and implemented."
        ),
        TrueFalseQuestion(
            id: "usr-tf-6",
            statement: "If residual risk stays high, the USR should accept the risk to avoid mission delay.",
            answer: false,
            explanation: "High residual risk must be elevated to the proper acceptance authority."
        ),
        TrueFalseQuestion(
            id: "usr-tf-7",
            statement: "Spot inspections should prioritize high-risk tasks and repeat findings.",
            answer: true,
            explanation: "Risk-based prioritization is the most effective use of limited inspection capacity."
        ),
        TrueFalseQuestion(
            id: "usr-tf-8",
            statement: "Safety briefing records are optional if the briefing was short.",
            answer: false,
            explanation: "Briefings should be documented with date, topic, and attendees."
        ),
        TrueFalseQuestion(
            id: "usr-tf-9",
            statement: "The safety office can advise and inspect, but unit leadership still owns execution.",
            answer: true,
            explanation: "Safety staff support and verify; command responsibility remains in the unit."
        ),
        TrueFalseQuestion(
            id: "usr-tf-10",
            statement: "If no injury occurred, a mishap or near miss does not need to be tracked.",
            answer: false,
            explanation: "Tracking near misses supports trend analysis and prevention."
        ),
        TrueFalseQuestion(
            id: "usr-tf-11",
            statement: "The USR should use objective, fact-based language in reports.",
            answer: true,
            explanation: "Objective reports are easier to act on and defend."
        ),
        TrueFalseQuestion(
            id: "usr-tf-12",
            statement: "Once funding is approved for a fix, the hazard is automatically closed.",
            answer: false,
            explanation: "Funding approval is not closure; corrective action still needs verification."
        )
    ]

    private static let oneS0MicroDrillTopics: [MicroDrillTopic] = [
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

    private static let usrMicroDrillTopics: [MicroDrillTopic] = [
        MicroDrillTopic(
            id: "usr-micro-fundamentals",
            title: "USR Fundamentals Drill",
            detail: "Quick checks on core USR duties and boundaries.",
            moduleIds: ["usr-program-fundamentals", "usr-roles-responsibilities"],
            maxQuestions: 5
        ),
        MicroDrillTopic(
            id: "usr-micro-hazard",
            title: "Hazard Tracking Drill",
            detail: "Practice hazard reporting and follow-up actions.",
            moduleIds: ["usr-hazard-reporting", "usr-hazard-abatement"],
            maxQuestions: 5
        ),
        MicroDrillTopic(
            id: "usr-micro-rm",
            title: "USR RM Drill",
            detail: "Apply RM basics and risk elevation decisions.",
            moduleIds: ["usr-risk-management"],
            maxQuestions: 5
        ),
        MicroDrillTopic(
            id: "usr-micro-briefings",
            title: "Briefings Drill",
            detail: "Review training, briefing, and mishap reporting decisions.",
            moduleIds: ["usr-training-briefings", "usr-mishap-reporting"],
            maxQuestions: 5
        )
    ]

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

    private static let usrOnboardingDays: [OnboardingDay] = [
        OnboardingDay(
            id: 1,
            title: "USR Start",
            summary: "Learn the USR role and program structure.",
            tasks: [
                "Start the USR Program Fundamentals module",
                "Review role boundaries and responsibilities"
            ],
            action: .module("usr-program-fundamentals")
        ),
        OnboardingDay(
            id: 2,
            title: "Tracking Habit",
            summary: "Build consistency with daily practice.",
            tasks: [
                "Complete a Daily 5 session",
                "Run a True/False Blitz"
            ],
            action: .trueFalseBlitz
        ),
        OnboardingDay(
            id: 3,
            title: "Pattern Recognition",
            summary: "Reinforce core USR decision points.",
            tasks: [
                "Complete one Match Sprint",
                "Review two missed questions"
            ],
            action: .matchSprint
        ),
        OnboardingDay(
            id: 4,
            title: "RM Basics",
            summary: "Practice risk decisions at the USR level.",
            tasks: [
                "Run a USR RM micro-drill",
                "Identify one risk elevation trigger"
            ],
            action: .microDrill
        ),
        OnboardingDay(
            id: 5,
            title: "Hazard Tracking",
            summary: "Practice reporting and follow-up discipline.",
            tasks: [
                "Complete one RAC Sort round",
                "Review one open hazard and its suspense"
            ],
            action: .racSort
        ),
        OnboardingDay(
            id: 6,
            title: "Process Sequence",
            summary: "Lock in USR process order and follow-up.",
            tasks: [
                "Build one sequence correctly",
                "Run a second sequence if time allows"
            ],
            action: .sequenceBuilder
        ),
        OnboardingDay(
            id: 7,
            title: "USR Capstone",
            summary: "Put reporting and follow-up together.",
            tasks: [
                "Complete the Mishap & Near-Miss Reporting module",
                "Submit one feedback item"
            ],
            action: .module("usr-mishap-reporting")
        )
    ]

    private static func lessonBullets(moduleId: String, pageId: String, role: TrainingRole?) -> [String] {
        guard let module = TrainingContent.modules(for: role).first(where: { $0.id == moduleId }) else { return [] }
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
