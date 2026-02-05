import Foundation

enum TrainingRole: String, CaseIterable, Identifiable, Codable {
    case oneS0 = "1S0"
    case usr = "USR"
    case msr = "MSR"

    var id: String { rawValue }

    var shortName: String { rawValue }

    var displayName: String {
        switch self {
        case .oneS0:
            return "1S0 Safety Inspector"
        case .usr:
            return "Unit Safety Representative"
        case .msr:
            return "Maintenance Safety Representative"
        }
    }

    var programName: String {
        switch self {
        case .oneS0:
            return "Wing Safety Program"
        case .usr:
            return "Unit Safety Program"
        case .msr:
            return "Maintenance Safety Program"
        }
    }

    var appTitle: String {
        switch self {
        case .oneS0:
            return "1S0 Inspector Trainer"
        case .usr:
            return "USR Safety Trainer"
        case .msr:
            return "MSR Safety Trainer"
        }
    }

    var homeSubtitle: String {
        switch self {
        case .oneS0:
            return "Level up your inspection skills with daily practice."
        case .usr:
            return "Strengthen unit-level safety support with focused practice."
        case .msr:
            return "Sharpen maintenance safety support with targeted practice."
        }
    }

    var lessonContext: String {
        switch self {
        case .oneS0:
            return "1S0 focus: enterprise oversight, inspection standards, and program execution."
        case .usr:
            return "USR focus: unit-level hazard identification, reporting, and program support."
        case .msr:
            return "MSR focus: maintenance-area hazard controls, procedures, and trend awareness."
        }
    }

    var scenarioIntroPrefix: String {
        "You are the \(displayName) for the \(programName). "
    }

    var quizPromptPrefix: String {
        "As the \(displayName), "
    }

    var objectivePrefix: String {
        "Apply requirements as the \(displayName) supporting the \(programName)."
    }
}
