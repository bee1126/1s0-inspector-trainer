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

struct AssessmentResult: Codable, Hashable {
    let score: Int
    let total: Int
}

struct QuizStreakSummary: Codable, Hashable {
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

enum AdaptiveMissionReason: String, CaseIterable, Hashable, Identifiable {
    case recentMiss
    case overdueReview
    case weakModule
    case fallback

    var id: String { rawValue }

    var label: String {
        switch self {
        case .recentMiss:
            return "Recent Miss"
        case .overdueReview:
            return "Review Due"
        case .weakModule:
            return "Weak Area"
        case .fallback:
            return "Full Bank"
        }
    }
}

struct AdaptiveMissionItem: Identifiable, Hashable {
    let question: QuizQuestion
    let reason: AdaptiveMissionReason

    var id: String { question.id }
}

struct AdaptiveMissionPlan: Hashable {
    let items: [AdaptiveMissionItem]

    var questions: [QuizQuestion] {
        items.map(\.question)
    }

    func count(for reason: AdaptiveMissionReason) -> Int {
        items.filter { $0.reason == reason }.count
    }
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
    case complete
}

struct QuizResumeState: Codable, Hashable {
    let questionIds: [String]
    let choiceOrder: [String: [String]]
    let index: Int
    let correctCount: Int
    let selectedChoiceId: String?
    let showFeedback: Bool
    let streakCount: Int
    let bestStreakCount: Int
    let streakTier: Int
    let bestStreakTier: Int

    init(
        questionIds: [String],
        choiceOrder: [String: [String]],
        index: Int,
        correctCount: Int,
        selectedChoiceId: String? = nil,
        showFeedback: Bool = false,
        streakCount: Int = 0,
        bestStreakCount: Int = 0,
        streakTier: Int = 0,
        bestStreakTier: Int = 0
    ) {
        self.questionIds = questionIds
        self.choiceOrder = choiceOrder
        self.index = index
        self.correctCount = correctCount
        self.selectedChoiceId = selectedChoiceId
        self.showFeedback = showFeedback
        self.streakCount = streakCount
        self.bestStreakCount = bestStreakCount
        self.streakTier = streakTier
        self.bestStreakTier = bestStreakTier
    }

    private enum CodingKeys: String, CodingKey {
        case questionIds
        case choiceOrder
        case index
        case correctCount
        case selectedChoiceId
        case showFeedback
        case streakCount
        case bestStreakCount
        case streakTier
        case bestStreakTier
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        questionIds = try container.decode([String].self, forKey: .questionIds)
        choiceOrder = try container.decode([String: [String]].self, forKey: .choiceOrder)
        index = try container.decode(Int.self, forKey: .index)
        correctCount = try container.decode(Int.self, forKey: .correctCount)
        selectedChoiceId = try container.decodeIfPresent(String.self, forKey: .selectedChoiceId)
        showFeedback = try container.decodeIfPresent(Bool.self, forKey: .showFeedback) ?? false
        streakCount = try container.decodeIfPresent(Int.self, forKey: .streakCount) ?? 0
        bestStreakCount = try container.decodeIfPresent(Int.self, forKey: .bestStreakCount) ?? 0
        streakTier = try container.decodeIfPresent(Int.self, forKey: .streakTier) ?? 0
        bestStreakTier = try container.decodeIfPresent(Int.self, forKey: .bestStreakTier) ?? 0
    }
}

struct ModuleResumeState: Codable, Hashable {
    let moduleId: String
    let stage: ModuleStageKey
    let lessonIndex: Int
    let quizState: QuizResumeState?
    let updatedAt: Date
}

struct PendingModuleCompletion: Codable, Hashable {
    let moduleId: String
    let scenarioResult: AssessmentResult
    let quizResult: AssessmentResult
    let quizStreakSummary: QuizStreakSummary
    let savedAt: Date
}
