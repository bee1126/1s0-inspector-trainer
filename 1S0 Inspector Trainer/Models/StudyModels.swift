import Foundation

enum StudyMode: String, Codable, CaseIterable, Identifiable {
    case study = "Study"
    case exam = "Exam"
    var id: String { rawValue }
}

enum QuestionPool: String, Codable, CaseIterable, Identifiable {
    case all = "All questions"
    case saved = "Saved questions"
    case missed = "Unresolved misses"
    case due = "Review due"
    var id: String { rawValue }
}

struct StudyConfiguration: Codable, Equatable {
    var mode: StudyMode = .study
    var pool: QuestionPool = .all
    var moduleIDs: Set<String> = [] // Empty means all topics.
    var difficulty: QuizDifficulty = .all
    var questionCount: Int = 10 // Zero means all matching questions.
    var questionIDs: Set<String>? = nil // A debrief's explicit remediation set.
}

struct QuestionReference: Codable, Hashable {
    let title: String
    let section: String
    let url: URL
}

/// Snapshot keeps an old debrief truthful even when the question bank changes.
struct StudyQuestion: Codable, Hashable, Identifiable {
    let id: String
    let moduleID: String
    let prompt: String
    let imageName: String?
    let choices: [QuizChoice]
    let explanation: String
    let reference: QuestionReference?
    let revision: Int

    init(_ question: QuizQuestion, shuffle: Bool = true) {
        id = question.id
        moduleID = ModuleHelper.moduleID(for: question.id)
        prompt = question.prompt
        imageName = question.imageName
        choices = shuffle ? question.choices.shuffled() : question.choices
        explanation = question.explanation
        reference = question.reference
        revision = question.contentRevision
    }

    func isCorrect(_ choiceID: String?) -> Bool {
        choices.first { $0.id == choiceID }?.isCorrect == true
    }
}

struct StudySession: Codable, Identifiable {
    let id: UUID
    let configuration: StudyConfiguration
    let startedAt: Date
    let questions: [StudyQuestion]
    var answers: [String: String] = [:]
    var index: Int = 0
    var updatedAt: Date

    var isComplete: Bool {
        !questions.isEmpty && questions.allSatisfy { question in
            question.choices.contains { $0.id == answers[question.id] }
        }
    }
    var score: Int { questions.filter { $0.isCorrect(answers[$0.id]) }.count }
}

enum StudySessionKind: String, Codable {
    case study = "Study"
    case exam = "Exam"
    case dailyFive = "Daily Five"
    case module = "Module quiz"
}

struct StudyHistoryEntry: Codable, Identifiable {
    let id: UUID
    let kind: StudySessionKind
    let completedAt: Date
    let questions: [StudyQuestion]
    let answers: [String: String]
    let score: Int
    let total: Int
    let xpEarned: Int
    var missedIDs: Set<String> {
        Set(questions.filter { answers[$0.id] != nil && !$0.isCorrect(answers[$0.id]) }.map(\.id))
    }
}

struct StudyPersistence: Codable {
    var savedQuestionIDs: Set<String> = []
    var unresolvedQuestionIDs: Set<String> = []
    var activeSession: StudySession?
    var history: [StudyHistoryEntry] = []
    // Separate from bounded history so pruning cannot make a completion payable again.
    var completedSessionIDs: Set<UUID> = []
    var rewardedModuleSessionIDs: Set<UUID> = []
}
