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
    let choices: [QuizChoice]
}

struct QuizChoice: Identifiable, Hashable {
    let id: String
    let text: String
    let isCorrect: Bool
}

struct ReferenceSource: Identifiable, Hashable {
    let id: String
    let title: String
    let date: String
    let notes: String
}
