import Foundation

enum PracticeContent {
    static let racHazards: [RacHazard] = [
        RacHazard(
            id: "rac-h1",
            title: "Unprotected 30-ft roof edge",
            detail: "Crew works within 3 ft of roof edge with no fall arrest.",
            rac: .rac1
        ),
        RacHazard(
            id: "rac-h2",
            title: "Open 480V panel",
            detail: "Panel is open with energized conductors exposed and no barrier.",
            rac: .rac1
        ),
        RacHazard(
            id: "rac-h3",
            title: "Confined space entry without permit",
            detail: "Entry planned with no attendant or permit controls in place.",
            rac: .rac2
        ),
        RacHazard(
            id: "rac-h4",
            title: "Missing machine guard",
            detail: "Rotating shaft guard removed while equipment remains in operation.",
            rac: .rac2
        ),
        RacHazard(
            id: "rac-h5",
            title: "Forklift seatbelt not used",
            detail: "Operator drives unbelted in mixed vehicle-pedestrian traffic area.",
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
            detail: "Extension ladder on uneven surface with no tie-off in use.",
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
        ),
        RacHazard(
            id: "rac-h11",
            title: "Worn crane sling in daily use",
            detail: "Frayed sling lifts 2-ton loads each shift on overhead crane.",
            rac: .rac1
        ),
        RacHazard(
            id: "rac-h12",
            title: "Bypassed press interlock",
            detail: "Interlock is taped down; operator exposed at point of operation.",
            rac: .rac1
        ),
        RacHazard(
            id: "rac-h13",
            title: "Blocked hangar fire exit",
            detail: "Equipment blocks egress route during shift peak (borderline RAC 2/3).",
            rac: .rac2
        ),
        RacHazard(
            id: "rac-h14",
            title: "Eyewash checks undocumented",
            detail: "Station works, but monthly test logs missing 6 months (borderline 2/3).",
            rac: .rac3
        ),
        RacHazard(
            id: "rac-h15",
            title: "Damaged safety poster",
            detail: "Poster torn but readable; minor awareness loss (borderline RAC 3/4).",
            rac: .rac4
        ),
        RacHazard(
            id: "rac-h16",
            title: "Worn floor tape markings",
            detail: "Aisle markings faded in low-traffic corner (borderline RAC 3/4).",
            rac: .rac4
        )
    ]

    static func trueFalseQuestions(for role: TrainingRole?) -> [TrueFalseQuestion] {
        oneS0TrueFalseQuestions
    }

    static func microDrillTopics(for role: TrainingRole?) -> [MicroDrillTopic] {
        oneS0MicroDrillTopics
    }

    static func procedureSets(for role: TrainingRole?) -> [ProcedureSet] {
        [
            ProcedureSet(
                id: "proc-loto-deenergize",
                title: "LOTO De-Energize Sequence",
                detail: "Anchor: Lockout / Tagout",
                steps: [
                    "Notify affected personnel and review written energy control procedure.",
                    "Identify every electrical, mechanical, hydraulic, pneumatic, and thermal energy source.",
                    "Shut down equipment using normal stopping controls.",
                    "Isolate all energy sources at disconnects, valves, and breakers.",
                    "Apply personal lockout or tagout devices at each isolation point.",
                    "Release or block stored energy through bleed down, venting, blocking, or grounding.",
                    "Verify zero-energy state with try-out and instrument check.",
                    "Perform work, then clear tools, remove personal locks, and notify affected personnel before restart."
                ]
            ),
            ProcedureSet(
                id: "proc-rm-five-step",
                title: "RM Five-Step Cycle",
                detail: "Anchor: Risk Management",
                steps: [
                    "Identify hazards tied to mission task and environment.",
                    "Assess each hazard for severity and probability.",
                    "Develop control measures and make risk decisions.",
                    "Implement controls with clear responsibilities and timelines.",
                    "Supervise execution and evaluate control effectiveness."
                ]
            ),
            ProcedureSet(
                id: "proc-rac-assessment",
                title: "RAC Assignment Workflow",
                detail: "Anchor: RAC System",
                steps: [
                    "Define the specific hazard condition and who is exposed.",
                    "Determine worst credible mishap outcome severity.",
                    "Estimate probability using exposure frequency and history.",
                    "Use the RAC matrix to assign the initial code.",
                    "Validate code against existing controls and residual risk.",
                    "Record RAC and elevation recommendations in inspection notes."
                ]
            ),
            ProcedureSet(
                id: "proc-confined-entry",
                title: "Confined Space Entry Controls",
                detail: "Anchor: Confined Space",
                steps: [
                    "Confirm space classification and permit requirements.",
                    "Isolate and lockout all hazardous energy and lines.",
                    "Test atmosphere for oxygen, flammables, and toxics.",
                    "Complete permit with entrant, attendant, and supervisor roles.",
                    "Brief rescue plan, communications, and retrieval equipment.",
                    "Authorize entry and maintain continuous atmospheric monitoring.",
                    "Close permit, account for personnel, and return space to service."
                ]
            ),
            ProcedureSet(
                id: "proc-hot-work-cycle",
                title: "Hot Work Permit to Closeout",
                detail: "Anchor: Hot Work",
                steps: [
                    "Survey worksite and remove combustibles within required radius.",
                    "Verify extinguishers, alarms, and suppression systems are ready.",
                    "Issue hot work permit with scope, time window, and controls.",
                    "Assign fire watch and brief stop-work triggers.",
                    "Conduct cutting or welding while monitoring sparks and heat spread.",
                    "Complete fire watch period, close permit, and document conditions."
                ]
            ),
            ProcedureSet(
                id: "proc-mishap-initial",
                title: "Mishap Initial Reporting Actions",
                detail: "Anchor: Mishap Reporting",
                steps: [
                    "Render emergency aid and activate emergency response.",
                    "Secure scene to prevent secondary injuries.",
                    "Notify chain of command and safety office immediately.",
                    "Capture factual details, witnesses, and initial conditions.",
                    "Submit required initial mishap report within timelines.",
                    "Initiate follow-up actions and preserve records for investigation."
                ]
            )
        ]
    }

    static func onboardingDays(for role: TrainingRole?) -> [OnboardingDay] {
        oneS0OnboardingDays
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
        ),
        TrueFalseQuestion(
            id: "tf-15",
            statement: "A group LOTO transfer is compliant if the lead lock stays on at shift change.",
            answer: false,
            explanation: "Oncoming workers apply personal locks before outgoing locks are removed."
        ),
        TrueFalseQuestion(
            id: "tf-16",
            statement: "If combustible gas reads zero once, permit-space entry can start immediately.",
            answer: false,
            explanation: "Atmosphere testing follows permit requirements and monitoring may be continuous."
        ),
        TrueFalseQuestion(
            id: "tf-17",
            statement: "A JHA should be updated when tools, scope, or environment changes.",
            answer: true,
            explanation: "Changes alter hazards and can invalidate existing controls."
        ),
        TrueFalseQuestion(
            id: "tf-18",
            statement: "A fire watch may leave as soon as welding stops and tools are secured.",
            answer: false,
            explanation: "Fire watch remains for the required post-work monitoring period."
        ),
        TrueFalseQuestion(
            id: "tf-19",
            statement: "Risk acceptance authority depends on residual RAC, not schedule pressure.",
            answer: true,
            explanation: "Mission urgency does not override delegated risk-acceptance thresholds."
        ),
        TrueFalseQuestion(
            id: "tf-20",
            statement: "Near misses are optional to document if supervisors already know about them.",
            answer: false,
            explanation: "Near misses need formal documentation for trend analysis and follow-up."
        ),
        TrueFalseQuestion(
            id: "tf-21",
            statement: "Hearing protection alone is not a substitute for feasible engineering controls.",
            answer: true,
            explanation: "Controls should follow the hierarchy; PPE is not the first control choice."
        ),
        TrueFalseQuestion(
            id: "tf-22",
            statement: "PPE can be selected by AFSC when a hazard assessment is unavailable.",
            answer: false,
            explanation: "PPE selection must be based on identified hazards, not job title."
        ),
        TrueFalseQuestion(
            id: "tf-23",
            statement: "Tagout-only never needs extra measures if the tag is signed and dated.",
            answer: false,
            explanation: "Tagout-only requires additional measures to provide equivalent protection."
        ),
        TrueFalseQuestion(
            id: "tf-24",
            statement: "Abatement is incomplete until corrective action is verified in the field.",
            answer: true,
            explanation: "Verification confirms the control works as intended at point of use."
        ),
        TrueFalseQuestion(
            id: "tf-25",
            statement: "A supervisor may remove any employee lock if production is delayed.",
            answer: false,
            explanation: "Lock removal requires formal verification and employee notification steps."
        ),
        TrueFalseQuestion(
            id: "tf-26",
            statement: "RAC can be assigned from severity alone when probability is uncertain.",
            answer: false,
            explanation: "RAC requires both severity and probability to support risk decisions."
        ),
        TrueFalseQuestion(
            id: "tf-27",
            statement: "Investigation quality improves when system factors are analyzed, not just errors.",
            answer: true,
            explanation: "System analysis finds latent causes and prevents repeat mishaps."
        ),
        TrueFalseQuestion(
            id: "tf-28",
            statement: "Briefing signatures alone prove an effective safety brief occurred.",
            answer: false,
            explanation: "Effectiveness depends on relevant hazards, controls, and worker understanding."
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
            title: "Procedure Drill",
            summary: "Run mission-style procedural reps.",
            tasks: [
                "Complete one 3-round Procedure Drill run",
                "Review replay highlights for any weak steps"
            ],
            action: .procedureDrill
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

struct ProcedureSet: Identifiable, Hashable {
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
    case procedureDrill
    case trueFalseBlitz
    case microDrill
}
