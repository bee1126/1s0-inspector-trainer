import Foundation


enum QuizBank {
    // NOTE: These quizzes are intentionally geared toward 5/7-level pros.
    // They focus on decision-making, sequencing, and edge cases versus simple recall.

    // MARK: Lockout / Tagout (LOTO)

    static let loto: [QuizQuestion] = [
        QuizQuestion(
            id: "loto-q1",
            prompt: "A mechanic isolates energy for pump repair but skips try-start verification. What is the most correct next step?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "loto-q1-a", text: "Pause work and verify controls against written steps", isCorrect: true),
                QuizChoice(id: "loto-q1-b", text: "Continue task and update records after completion", isCorrect: false),
                QuizChoice(id: "loto-q1-c", text: "Use PPE only and skip the control sequence check", isCorrect: false),
                QuizChoice(id: "loto-q1-d", text: "Ask for verbal approval, then keep the task moving", isCorrect: false),
            ]
        )
    ]

    // MARK: Fall Protection

    static let fallProtection: [QuizQuestion] = [
        QuizQuestion(
            id: "fall-q1",
            prompt: "A rooftop crew clips in, but anchor distance creates swing-fall risk at the edge. What is the most correct next step?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "fall-q1-a", text: "Continue task and update records after completion", isCorrect: false),
                QuizChoice(id: "fall-q1-b", text: "Pause work and verify controls against written steps", isCorrect: true),
                QuizChoice(id: "fall-q1-c", text: "Use PPE only and skip the control sequence check", isCorrect: false),
                QuizChoice(id: "fall-q1-d", text: "Ask for verbal approval, then keep the task moving", isCorrect: false),
            ]
        )
    ]

    // MARK: Risk Management

    static let riskManagement: [QuizQuestion] = [
        QuizQuestion(
            id: "rm-q1",
            prompt: "During a pretask brief, a new hazard appears after controls were accepted. What is the most correct next step?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rm-q1-a", text: "Continue task and update records after completion", isCorrect: false),
                QuizChoice(id: "rm-q1-b", text: "Use PPE only and skip the control sequence check", isCorrect: false),
                QuizChoice(id: "rm-q1-c", text: "Pause work and verify controls against written steps", isCorrect: true),
                QuizChoice(id: "rm-q1-d", text: "Ask for verbal approval, then keep the task moving", isCorrect: false),
            ]
        )
    ]

    // MARK: Roles & Responsibilities

    static let rolesResponsibilities: [QuizQuestion] = [
        QuizQuestion(
            id: "roles-q1",
            prompt: "A shop chief assigns one Airman to decide controls while others stay silent. What is the most correct next step?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "roles-q1-a", text: "Continue task and update records after completion", isCorrect: false),
                QuizChoice(id: "roles-q1-b", text: "Use PPE only and skip the control sequence check", isCorrect: false),
                QuizChoice(id: "roles-q1-c", text: "Ask for verbal approval, then keep the task moving", isCorrect: false),
                QuizChoice(id: "roles-q1-d", text: "Pause work and verify controls against written steps", isCorrect: true),
            ]
        )
    ]

    // MARK: Hazard Abatement

    static let hazardAbatement: [QuizQuestion] = [
        QuizQuestion(
            id: "abatement-q1",
            prompt: "Two sections abate one hazard and each assumes the other posted interim controls. What is the most correct next step?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "abatement-q1-a", text: "Pause work and verify controls against written steps", isCorrect: true),
                QuizChoice(id: "abatement-q1-b", text: "Continue task and update records after completion", isCorrect: false),
                QuizChoice(id: "abatement-q1-c", text: "Use PPE only and skip the control sequence check", isCorrect: false),
                QuizChoice(id: "abatement-q1-d", text: "Ask for verbal approval, then keep the task moving", isCorrect: false),
            ]
        )
    ]

    // MARK: RAC System

    static let racSystem: [QuizQuestion] = [
        QuizQuestion(
            id: "rac-q1",
            prompt: "A team marks a hazard RAC 4 before checking longer exposure duration on nights. What is the most correct next step?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "rac-q1-a", text: "Continue task and update records after completion", isCorrect: false),
                QuizChoice(id: "rac-q1-b", text: "Pause work and verify controls against written steps", isCorrect: true),
                QuizChoice(id: "rac-q1-c", text: "Use PPE only and skip the control sequence check", isCorrect: false),
                QuizChoice(id: "rac-q1-d", text: "Ask for verbal approval, then keep the task moving", isCorrect: false),
            ]
        )
    ]

    // MARK: Confined Space

    static let confinedSpace: [QuizQuestion] = [
        QuizQuestion(
            id: "cs-q1",
            prompt: "Confined-space entry starts, then ventilation drops below plan limits for minutes. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "cs-q1-a", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "cs-q1-b", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "cs-q1-c", text: "Re-run risk review and reassign controls before work", isCorrect: true),
                QuizChoice(id: "cs-q1-d", text: "Log concern for trend data and continue under watch", isCorrect: false),
            ]
        )
    ]

    // MARK: Hot Work

    static let hotWork: [QuizQuestion] = [
        QuizQuestion(
            id: "hot-q1",
            prompt: "A hot-work permit is active, but the fire watch leaves early to move equipment. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hot-q1-a", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "hot-q1-b", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "hot-q1-c", text: "Log concern for trend data and continue under watch", isCorrect: false),
                QuizChoice(id: "hot-q1-d", text: "Re-run risk review and reassign controls before work", isCorrect: true),
            ]
        )
    ]

    // MARK: Hearing Conservation

    static let hearingConservation: [QuizQuestion] = [
        QuizQuestion(
            id: "hc-q1",
            prompt: "Noise readings rise above limits, but fit checks were skipped at shift turnover. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "hc-q1-a", text: "Re-run risk review and reassign controls before work", isCorrect: true),
                QuizChoice(id: "hc-q1-b", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "hc-q1-c", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "hc-q1-d", text: "Log concern for trend data and continue under watch", isCorrect: false),
            ]
        )
    ]

    // MARK: Mishap Reporting

    static let mishapReporting: [QuizQuestion] = [
        QuizQuestion(
            id: "mishap-q1",
            prompt: "After a near miss, witness notes are delayed so production can restart quickly. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "mishap-q1-a", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "mishap-q1-b", text: "Re-run risk review and reassign controls before work", isCorrect: true),
                QuizChoice(id: "mishap-q1-c", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "mishap-q1-d", text: "Log concern for trend data and continue under watch", isCorrect: false),
            ]
        )
    ]

    // MARK: Investigation Basics

    static let investigationBasics: [QuizQuestion] = [
        QuizQuestion(
            id: "invest-q1",
            prompt: "Investigators interview one witness only because turnover is near. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "invest-q1-a", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "invest-q1-b", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "invest-q1-c", text: "Re-run risk review and reassign controls before work", isCorrect: true),
                QuizChoice(id: "invest-q1-d", text: "Log concern for trend data and continue under watch", isCorrect: false),
            ]
        )
    ]

    // MARK: JHA Fundamentals

    static let jhaFundamentals: [QuizQuestion] = [
        QuizQuestion(
            id: "jha-q1",
            prompt: "A JHA was approved yesterday, but a new tool changes pinch-point exposure today. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "jha-q1-a", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "jha-q1-b", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "jha-q1-c", text: "Log concern for trend data and continue under watch", isCorrect: false),
                QuizChoice(id: "jha-q1-d", text: "Re-run risk review and reassign controls before work", isCorrect: true),
            ]
        )
    ]

    // MARK: Safety Briefing

    static let safetyBriefing: [QuizQuestion] = [
        QuizQuestion(
            id: "brief-q1",
            prompt: "At a safety brief, workers acknowledge hazards but cannot restate key controls. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "brief-q1-a", text: "Re-run risk review and reassign controls before work", isCorrect: true),
                QuizChoice(id: "brief-q1-b", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "brief-q1-c", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "brief-q1-d", text: "Log concern for trend data and continue under watch", isCorrect: false),
            ]
        )
    ]

    // MARK: PPE Decision

    static let ppeDecision: [QuizQuestion] = [
        QuizQuestion(
            id: "ppe-q1",
            prompt: "A painter has the correct respirator type, but cartridge change timing is unclear. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "ppe-q1-a", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "ppe-q1-b", text: "Re-run risk review and reassign controls before work", isCorrect: true),
                QuizChoice(id: "ppe-q1-c", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "ppe-q1-d", text: "Log concern for trend data and continue under watch", isCorrect: false),
            ]
        )
    ]

    // MARK: USR Program Fundamentals

    static let usrProgramFundamentals: [QuizQuestion] = [
        QuizQuestion(
            id: "usr-pf-q1",
            prompt: "A USR rep tracks slip hazards monthly, but repeat risks rise between reports. What is the most correct next step?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "usr-pf-q1-a", text: "Continue task and update records after completion", isCorrect: false),
                QuizChoice(id: "usr-pf-q1-b", text: "Use PPE only and skip the control sequence check", isCorrect: false),
                QuizChoice(id: "usr-pf-q1-c", text: "Pause work and verify controls against written steps", isCorrect: true),
                QuizChoice(id: "usr-pf-q1-d", text: "Ask for verbal approval, then keep the task moving", isCorrect: false),
            ]
        )
    ]

    // MARK: USR Roles & Responsibilities

    static let usrRolesResponsibilities: [QuizQuestion] = [
        QuizQuestion(
            id: "usr-roles-q1",
            prompt: "USR duty letters are signed, but alternates never practiced role handoffs. What is the most correct next step?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "usr-roles-q1-a", text: "Continue task and update records after completion", isCorrect: false),
                QuizChoice(id: "usr-roles-q1-b", text: "Use PPE only and skip the control sequence check", isCorrect: false),
                QuizChoice(id: "usr-roles-q1-c", text: "Ask for verbal approval, then keep the task moving", isCorrect: false),
                QuizChoice(id: "usr-roles-q1-d", text: "Pause work and verify controls against written steps", isCorrect: true),
            ]
        )
    ]

    // MARK: USR Hazard Reporting & Tracking

    static let usrHazardReporting: [QuizQuestion] = [
        QuizQuestion(
            id: "usr-hz-q1",
            prompt: "A hazard is logged in USR tracking, but interim controls have no owner. What is the most correct next step?",
            difficulty: .medium,
            choices: [
                QuizChoice(id: "usr-hz-q1-a", text: "Pause work and verify controls against written steps", isCorrect: true),
                QuizChoice(id: "usr-hz-q1-b", text: "Continue task and update records after completion", isCorrect: false),
                QuizChoice(id: "usr-hz-q1-c", text: "Use PPE only and skip the control sequence check", isCorrect: false),
                QuizChoice(id: "usr-hz-q1-d", text: "Ask for verbal approval, then keep the task moving", isCorrect: false),
            ]
        )
    ]

    // MARK: USR Risk Management Basics

    static let usrRiskManagement: [QuizQuestion] = [
        QuizQuestion(
            id: "usr-rm-q1",
            prompt: "USR risk acceptance used last-quarter data though mission tempo changed this week. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "usr-rm-q1-a", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "usr-rm-q1-b", text: "Re-run risk review and reassign controls before work", isCorrect: true),
                QuizChoice(id: "usr-rm-q1-c", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "usr-rm-q1-d", text: "Log concern for trend data and continue under watch", isCorrect: false),
            ]
        )
    ]

    // MARK: USR Spot Inspections & Self-Assessments

    static let usrSpotInspections: [QuizQuestion] = [
        QuizQuestion(
            id: "usr-spot-q1",
            prompt: "A self-assessment finds a blocked exit, but action is deferred to next audit. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "usr-spot-q1-a", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "usr-spot-q1-b", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "usr-spot-q1-c", text: "Re-run risk review and reassign controls before work", isCorrect: true),
                QuizChoice(id: "usr-spot-q1-d", text: "Log concern for trend data and continue under watch", isCorrect: false),
            ]
        )
    ]

    // MARK: USR Safety Training & Briefings

    static let usrTrainingBriefings: [QuizQuestion] = [
        QuizQuestion(
            id: "usr-train-q1",
            prompt: "Safety briefing slides were sent, but attendance and understanding were not checked. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "usr-train-q1-a", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "usr-train-q1-b", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "usr-train-q1-c", text: "Log concern for trend data and continue under watch", isCorrect: false),
                QuizChoice(id: "usr-train-q1-d", text: "Re-run risk review and reassign controls before work", isCorrect: true),
            ]
        )
    ]

    // MARK: USR Mishap & Near-Miss Reporting

    static let usrMishapReporting: [QuizQuestion] = [
        QuizQuestion(
            id: "usr-mr-q1",
            prompt: "A near-miss report is drafted, but trend coding was skipped to save time. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "usr-mr-q1-a", text: "Re-run risk review and reassign controls before work", isCorrect: true),
                QuizChoice(id: "usr-mr-q1-b", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "usr-mr-q1-c", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "usr-mr-q1-d", text: "Log concern for trend data and continue under watch", isCorrect: false),
            ]
        )
    ]

    // MARK: USR Hazard Abatement & Interim Controls

    static let usrHazardAbatement: [QuizQuestion] = [
        QuizQuestion(
            id: "usr-abate-q1",
            prompt: "An interim barrier is installed, but no suspense date exists for final abatement. What is the most correct next step?",
            difficulty: .hard,
            choices: [
                QuizChoice(id: "usr-abate-q1-a", text: "Keep current controls because no incident occurred", isCorrect: false),
                QuizChoice(id: "usr-abate-q1-b", text: "Re-run risk review and reassign controls before work", isCorrect: true),
                QuizChoice(id: "usr-abate-q1-c", text: "Apply interim PPE now and defer process changes", isCorrect: false),
                QuizChoice(id: "usr-abate-q1-d", text: "Log concern for trend data and continue under watch", isCorrect: false),
            ]
        )
    ]

}
