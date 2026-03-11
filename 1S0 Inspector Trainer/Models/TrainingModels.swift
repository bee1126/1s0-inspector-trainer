import Foundation

struct TrainingModule: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let estimatedMinutes: Int
    let difficulty: String
    let tags: [String]
    let objectives: [String]
    let lessonPages: [LessonPage]
    let scenario: Scenario
    let quiz: [QuizQuestion]
}

enum ModuleIntegrityIssue: Hashable, Identifiable {
    case missingTitle
    case missingSubtitle
    case missingLessonPages
    case missingScenarioSteps
    case invalidScenarioStart
    case missingQuizQuestions

    var id: String { message }

    var message: String {
        switch self {
        case .missingTitle:
            return "Module title is missing."
        case .missingSubtitle:
            return "Module subtitle is missing."
        case .missingLessonPages:
            return "Lesson pages are missing."
        case .missingScenarioSteps:
            return "Scenario steps are missing."
        case .invalidScenarioStart:
            return "Scenario start step does not match available steps."
        case .missingQuizQuestions:
            return "Quiz questions are missing."
        }
    }
}

extension TrainingModule {
    var integrityIssues: [ModuleIntegrityIssue] {
        var issues: [ModuleIntegrityIssue] = []
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            issues.append(.missingTitle)
        }
        if subtitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            issues.append(.missingSubtitle)
        }
        if lessonPages.isEmpty {
            issues.append(.missingLessonPages)
        }
        if scenario.steps.isEmpty {
            issues.append(.missingScenarioSteps)
        } else {
            let stepIds = Set(scenario.steps.map(\.id))
            if !stepIds.contains(scenario.startStepId) {
                issues.append(.invalidScenarioStart)
            }
        }
        if quiz.isEmpty {
            issues.append(.missingQuizQuestions)
        }
        return issues
    }

    var isIntegrityValid: Bool {
        integrityIssues.isEmpty
    }
}

struct LessonPage: Identifiable, Hashable {
    let id: String
    let title: String
    let bullets: [String]
}

struct Scenario: Hashable {
    let title: String
    let intro: String
    let startStepId: String
    let steps: [ScenarioStep]
}

struct ScenarioStep: Identifiable, Hashable {
    let id: String
    let prompt: String
    let options: [ScenarioOption]
}

struct ScenarioOption: Identifiable, Hashable {
    let id: String
    let text: String
    let feedback: String
    let isCorrect: Bool
    let nextStepId: String?
}

struct QuizQuestion: Identifiable, Hashable {
    let id: String
    let prompt: String
    let imageName: String?
    let choices: [QuizChoice]
    let difficulty: QuizDifficulty

    init(id: String, prompt: String, difficulty: QuizDifficulty = .easy, imageName: String? = nil, choices: [QuizChoice]) {
        self.id = id
        self.prompt = prompt
        self.imageName = imageName
        self.difficulty = difficulty
        self.choices = choices
    }
}

struct QuizChoice: Identifiable, Hashable {
    let id: String
    let text: String
    let isCorrect: Bool
}

struct AssessmentResult: Hashable {
    let score: Int
    let total: Int
}

struct QuizStreakSummary: Hashable {
    let maxStreak: Int
    let multiplier: Double
}

enum QuizDifficulty: String, CaseIterable, Identifiable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case all = "All"

    var id: String { rawValue }
}

struct ReferenceSource: Identifiable, Hashable {
    let id: String
    let title: String
    let date: String
    let notes: String
}

enum ModuleStageKey: String, Codable {
    case lesson
    case scenario
    case quiz
}

struct QuizResumeState: Codable, Hashable {
    let questionIds: [String]
    let choiceOrder: [String: [String]]
    let index: Int
    let correctCount: Int
}

struct ModuleResumeState: Codable, Hashable {
    let moduleId: String
    let stage: ModuleStageKey
    let lessonIndex: Int
    let quizState: QuizResumeState?
    let updatedAt: Date
}

struct ProcedureDrillRoundState: Codable, Hashable {
    let setId: String
    var currentOrder: [Int]
    var failedChecks: Int
    var finalCorrectPlacements: Int?
    var finalScore: Int?
    var didAutoSubmit: Bool
    var isComplete: Bool
}

struct ProcedureDrillRunState: Codable, Hashable {
    let roundSetIds: [String]
    var rounds: [ProcedureDrillRoundState]
    var currentRoundIndex: Int
    let startedAt: Date
    var updatedAt: Date
}

struct ProcedureDrillRoundOutcome: Hashable {
    let correctPlacements: Int
    let failedChecks: Int
    let totalSteps: Int
}

enum ProcedureDrillScoring {
    static func roundScore(correctPlacements: Int, failedChecks: Int, totalSteps: Int) -> Int {
        let boundedSteps = max(0, totalSteps)
        let boundedCorrect = max(0, min(correctPlacements, boundedSteps))
        let penalty = max(0, failedChecks)
        return max(0, boundedCorrect - penalty)
    }

    static func aggregateScore(rounds: [ProcedureDrillRoundOutcome]) -> AssessmentResult {
        let total = rounds.reduce(0) { partial, round in
            partial + max(0, round.totalSteps)
        }
        let score = rounds.reduce(0) { partial, round in
            partial + roundScore(
                correctPlacements: round.correctPlacements,
                failedChecks: round.failedChecks,
                totalSteps: round.totalSteps
            )
        }
        return AssessmentResult(score: score, total: total)
    }
}
