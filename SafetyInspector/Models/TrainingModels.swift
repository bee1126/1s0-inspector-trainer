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
