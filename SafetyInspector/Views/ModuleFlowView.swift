import SwiftUI

struct ModuleFlowView: View {
    @EnvironmentObject private var progress: ProgressStore
    let module: TrainingModule

    @State private var stage: ModuleStage = .lesson
    @State private var scenarioResult = Result(score: 0, total: 0)
    @State private var quizResult = Result(score: 0, total: 0)
    @State private var appeared = false

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 16) {
                StageProgressView(stage: stage)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                switch stage {
                case .lesson:
                    LessonPagerView(pages: module.lessonPages) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            stage = .scenario
                        }
                    }
                case .scenario:
                    ScenarioFlowView(scenario: module.scenario) { result in
                        scenarioResult = result
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            stage = .quiz
                        }
                    }
                case .quiz:
                    QuizFlowView(questions: module.quiz) { result in
                        quizResult = result
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            stage = .complete
                        }
                    }
                case .complete:
                    CompletionView(
                        moduleTitle: module.title,
                        score: finalScore,
                        scenarioResult: scenarioResult,
                        quizResult: quizResult
                    ) {
                        progress.markCompleted(moduleId: module.id, score: finalScore)
                    }
                }
                Spacer()
            }
            .padding(.bottom, 20)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4)) {
                    appeared = true
                }
            }
        }
        .navigationTitle(module.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var finalScore: Int {
        let total = scenarioResult.total + quizResult.total
        guard total > 0 else { return 0 }
        let points = scenarioResult.score + quizResult.score
        return Int(round(Double(points) / Double(total) * 100))
    }
}

enum ModuleStage {
    case lesson
    case scenario
    case quiz
    case complete
}

struct Result {
    let score: Int
    let total: Int
}

struct StageProgressView: View {
    let stage: ModuleStage

    var body: some View {
        HStack(spacing: 8) {
            StageChip(title: "Lesson", isActive: stage == .lesson)
            StageChip(title: "Scenario", isActive: stage == .scenario)
            StageChip(title: "Quiz", isActive: stage == .quiz)
            StageChip(title: "Complete", isActive: stage == .complete)
        }
    }
}

struct StageChip: View {
    let title: String
    let isActive: Bool

    var body: some View {
        Text(title)
            .font(AppFont.mono(11))
            .foregroundColor(isActive ? .white : AppTheme.charcoal)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(isActive ? AppTheme.blue : Color.white.opacity(0.85))
            )
    }
}

struct CompletionView: View {
    let moduleTitle: String
    let score: Int
    let scenarioResult: Result
    let quizResult: Result
    let onComplete: () -> Void

    @State private var didSave = false

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("Module Complete")
                    .font(AppFont.title(22))
                    .foregroundColor(AppTheme.charcoal)

                Text(moduleTitle)
                    .font(AppFont.subtitle(16))
                    .foregroundColor(AppTheme.charcoal.opacity(0.8))

                HStack(spacing: 12) {
                    VStack(alignment: .leading) {
                        Text("Scenario")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.charcoal.opacity(0.6))
                        Text("\(scenarioResult.score)/\(scenarioResult.total)")
                            .font(AppFont.subtitle(18))
                    }
                    VStack(alignment: .leading) {
                        Text("Quiz")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.charcoal.opacity(0.6))
                        Text("\(quizResult.score)/\(quizResult.total)")
                            .font(AppFont.subtitle(18))
                    }
                    Spacer()
                    ScoreBadge(score: score)
                }

                if didSave {
                    Button("Saved") {
                        // No-op once saved
                    }
                    .buttonStyle(OutlineButtonStyle())
                } else {
                    Button("Save Progress") {
                        onComplete()
                        didSave = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
