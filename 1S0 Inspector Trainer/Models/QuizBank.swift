import Foundation

enum QuizBank {
    // NOTE: These quizzes are intentionally geared toward 5/7-level pros.
    // They focus on decision-making, sequencing, and edge cases versus simple recall.

    private enum DecisionPattern {
        case verifyControls
        case rerunRiskReview
    }

    private static let questionsPerModule = 10
    private static let choiceLetters = ["a", "b", "c", "d"]
    private static let correctIndexPattern = [0, 1, 2, 3, 1, 2, 3, 0, 2, 1]

    private static let verifyControlPromptTemplates: [String] = [
        "During %@, a supervisor suggests skipping written control verification to keep production moving. What is the best immediate action?",
        "In %@, a new hazard appears after the pre-task brief has ended. What is the most correct next step?",
        "While coordinating %@, two teams assume the other already validated controls. What should happen first?",
        "During %@, workers request to continue under verbal approval only. What is the best response?",
        "In %@, documentation is partially complete but execution is about to start. What is the safest next action?",
        "During %@, an alternate worker takes over without reviewing active controls. What should you do?",
        "In %@, a required control is unavailable and the team wants to rely on PPE alone. What is the best decision?",
        "During %@, leadership pressures the team to move faster than the planned safety sequence. What is the right next action?",
        "In %@, the task changed after setup and existing controls may no longer fit. What should happen immediately?",
        "During %@, controls were copied from a previous job without site-specific checks. What is the best next step?"
    ]

    private static let rerunRiskPromptTemplates: [String] = [
        "During %@, monitoring data shows control performance degrading mid-shift. What is the most correct immediate action?",
        "In %@, incident indicators increase but no injury has occurred yet. What is the best next decision?",
        "During %@, a key assumption in the original risk decision is no longer true. What should happen first?",
        "In %@, the team wants to defer process updates until after mission completion. What is the safest response?",
        "During %@, temporary mitigation is in place but ownership and timelines are unclear. What should happen now?",
        "In %@, task complexity increased beyond the scope of the approved controls. What is the correct next action?",
        "During %@, trend logs show repeat deviations under similar conditions. What is the most correct response?",
        "In %@, staffing changed and no one can verify prior control assumptions. What should happen before work continues?",
        "During %@, command asks to accept risk using outdated exposure assumptions. What is the best immediate action?",
        "In %@, a near-miss indicates the current control plan is no longer adequate. What is the most correct next step?"
    ]

    private static let verifyControlChoices: [String] = [
        "Pause work and verify controls against written steps",
        "Continue task and update records after completion",
        "Use PPE only and skip the control sequence check",
        "Ask for verbal approval, then keep the task moving"
    ]

    private static let rerunRiskChoices: [String] = [
        "Re-run risk review and reassign controls before work",
        "Keep current controls because no incident occurred",
        "Apply interim PPE now and defer process changes",
        "Log concern for trend data and continue under watch"
    ]

    // MARK: Lockout / Tagout (LOTO)

    static let loto: [QuizQuestion] = makeQuestionSet(
        prefix: "loto",
        topic: "lockout/tagout servicing on industrial equipment",
        difficulty: .medium,
        decisionPattern: .verifyControls
    )

    // MARK: Fall Protection

    static let fallProtection: [QuizQuestion] = makeQuestionSet(
        prefix: "fall",
        topic: "elevated work with fall protection systems",
        difficulty: .medium,
        decisionPattern: .verifyControls
    )

    // MARK: Risk Management

    static let riskManagement: [QuizQuestion] = makeQuestionSet(
        prefix: "rm",
        topic: "operational risk management during maintenance tasks",
        difficulty: .medium,
        decisionPattern: .verifyControls
    )

    // MARK: Roles & Responsibilities

    static let rolesResponsibilities: [QuizQuestion] = makeQuestionSet(
        prefix: "roles",
        topic: "shop-level safety role assignment and handoff",
        difficulty: .medium,
        decisionPattern: .verifyControls
    )

    // MARK: Hazard Abatement

    static let hazardAbatement: [QuizQuestion] = makeQuestionSet(
        prefix: "abatement",
        topic: "hazard abatement tracking and interim controls",
        difficulty: .medium,
        decisionPattern: .verifyControls
    )

    // MARK: RAC System

    static let racSystem: [QuizQuestion] = makeQuestionSet(
        prefix: "rac",
        topic: "RAC hazard classification and prioritization",
        difficulty: .medium,
        decisionPattern: .verifyControls
    )

    // MARK: Confined Space

    static let confinedSpace: [QuizQuestion] = makeQuestionSet(
        prefix: "cs",
        topic: "permit-required confined space entry operations",
        difficulty: .hard,
        decisionPattern: .rerunRiskReview
    )

    // MARK: Hot Work

    static let hotWork: [QuizQuestion] = makeQuestionSet(
        prefix: "hot",
        topic: "hot work permit execution and fire watch coverage",
        difficulty: .hard,
        decisionPattern: .rerunRiskReview
    )

    // MARK: Hearing Conservation

    static let hearingConservation: [QuizQuestion] = makeQuestionSet(
        prefix: "hc",
        topic: "hearing conservation controls in high-noise areas",
        difficulty: .hard,
        decisionPattern: .rerunRiskReview
    )

    // MARK: Mishap Reporting

    static let mishapReporting: [QuizQuestion] = makeQuestionSet(
        prefix: "mishap",
        topic: "mishap and near-miss reporting workflow",
        difficulty: .hard,
        decisionPattern: .rerunRiskReview
    )

    // MARK: Investigation Basics

    static let investigationBasics: [QuizQuestion] = makeQuestionSet(
        prefix: "invest",
        topic: "initial mishap fact-finding and witness interviews",
        difficulty: .hard,
        decisionPattern: .rerunRiskReview
    )

    // MARK: JHA Fundamentals

    static let jhaFundamentals: [QuizQuestion] = makeQuestionSet(
        prefix: "jha",
        topic: "job hazard analysis updates after task changes",
        difficulty: .hard,
        decisionPattern: .rerunRiskReview
    )

    // MARK: Safety Briefing

    static let safetyBriefing: [QuizQuestion] = makeQuestionSet(
        prefix: "brief",
        topic: "pre-task safety briefing effectiveness checks",
        difficulty: .hard,
        decisionPattern: .rerunRiskReview
    )

    // MARK: PPE Decision

    static let ppeDecision: [QuizQuestion] = makeQuestionSet(
        prefix: "ppe",
        topic: "PPE selection and control integration for hazardous tasks",
        difficulty: .hard,
        decisionPattern: .rerunRiskReview
    )

    private static func makeQuestionSet(
        prefix: String,
        topic: String,
        difficulty: QuizDifficulty,
        decisionPattern: DecisionPattern
    ) -> [QuizQuestion] {
        let templates: [String]
        let choiceTexts: [String]

        switch decisionPattern {
        case .verifyControls:
            templates = verifyControlPromptTemplates
            choiceTexts = verifyControlChoices
        case .rerunRiskReview:
            templates = rerunRiskPromptTemplates
            choiceTexts = rerunRiskChoices
        }

        let normalizedTemplates = Array(templates.prefix(questionsPerModule))
        return normalizedTemplates.enumerated().map { index, template in
            let questionId = "\(prefix)-q\(index + 1)"
            let prompt = String(format: template, topic)
            let correctChoiceIndex = correctIndexPattern[index % correctIndexPattern.count]

            return QuizQuestion(
                id: questionId,
                prompt: prompt,
                difficulty: difficulty,
                choices: makeChoices(
                    questionId: questionId,
                    choiceTexts: choiceTexts,
                    correctChoiceIndex: correctChoiceIndex
                )
            )
        }
    }

    private static func makeChoices(
        questionId: String,
        choiceTexts: [String],
        correctChoiceIndex: Int
    ) -> [QuizChoice] {
        let correctText = choiceTexts[0]
        let distractors = Array(choiceTexts.dropFirst())

        var orderedTexts = Array(repeating: "", count: choiceLetters.count)
        orderedTexts[correctChoiceIndex] = correctText

        var distractorIndex = 0
        for index in orderedTexts.indices where index != correctChoiceIndex {
            orderedTexts[index] = distractors[distractorIndex]
            distractorIndex += 1
        }

        return orderedTexts.enumerated().map { index, text in
            QuizChoice(
                id: "\(questionId)-\(choiceLetters[index])",
                text: text,
                isCorrect: index == correctChoiceIndex
            )
        }
    }
}
