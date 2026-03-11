import Foundation

enum TrainingRole: String, CaseIterable, Identifiable, Codable {
    case oneS0 = "1S0"

    var id: String { rawValue }

    var shortName: String { rawValue }

    var displayName: String { "1S0 Safety Inspector" }

    var programName: String { "Wing Safety Program" }

    var appTitle: String { "1S0 Inspector Trainer" }

    var homeSubtitle: String { "Level up your inspection skills with daily practice." }

    var lessonContext: String { "1S0 focus: enterprise oversight, inspection standards, and program execution." }

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
