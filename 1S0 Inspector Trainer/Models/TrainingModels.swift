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
