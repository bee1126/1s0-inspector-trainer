import SwiftUI
import UIKit

struct ModuleFlowView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    let module: TrainingModule

    @State private var stage: ModuleStage = .lesson
    @State private var scenarioResult = AssessmentResult(score: 0, total: 0)
    @State private var quizResult = AssessmentResult(score: 0, total: 0)
    @State private var quizStreakSummary = QuizStreakSummary(maxStreak: 0, multiplier: 1.0)
    @State private var appeared = false
    @State private var lessonIndex: Int = 0
    @State private var didApplyResume = false
    @State private var racJustification = ""
    @State private var showPracticeSheet = false

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: AppSpacing.stack) {
                HStack(spacing: 12) {
                    StageProgressView(stage: stage)
                    Spacer()
                    HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts)
                }
                .padding(.horizontal, AppSpacing.screenPadding)
                .padding(.top, 8)

                switch stage {
                case .lesson:
                    LessonPagerView(
                        pages: module.lessonPages,
                        onSkip: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                stage = .scenario
                            }
                        },
                        onComplete: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                stage = .scenario
                            }
                        },
                        initialIndex: lessonIndex,
                        onIndexChange: { newIndex in
                            lessonIndex = newIndex
                            progress.updateResume(moduleId: module.id, stage: .lesson, lessonIndex: newIndex)
                        }
                    )
                case .scenario:
                    ScenarioFlowView(scenario: module.scenario, onWrongAnswer: {
                        progress.consumeHeart()
                    }, showsHearts: false) { result in
                        scenarioResult = result
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            stage = .quiz
                        }
                    }
                case .quiz:
                    QuizFlowView(questions: module.quiz, onWrongAnswer: {
                        progress.consumeHeart()
                    }, onComplete: { result, streak in
                        quizResult = result
                        quizStreakSummary = streak
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            stage = .complete
                        }
                    }, showsHearts: false, shuffleQuestions: true, maxQuestions: 10, resumeState: progress.resumeState(for: module.id)?.quizState, onStateUpdate: { state in
                        progress.updateResume(moduleId: module.id, stage: .quiz, quizState: state)
                    })
                case .complete:
                    CompletionView(
                        moduleTitle: module.title,
                        score: finalScore,
                        scenarioResult: scenarioResult,
                        quizResult: quizResult,
                        showRacInput: module.id == "rac-system",
                        racJustification: $racJustification
                    ) {
                        progress.completeModule(
                            moduleId: module.id,
                            score: finalScore,
                            scenarioResult: scenarioResult,
                            quizResult: quizResult,
                            quizMultiplier: quizStreakSummary.multiplier
                        )
                    } onRetry: {
                        scenarioResult = AssessmentResult(score: 0, total: 0)
                        quizResult = AssessmentResult(score: 0, total: 0)
                        racJustification = ""
                        stage = .lesson
                    }
                }
                Spacer()
            }
            .padding(.bottom, AppSpacing.screenPadding)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
            .onAppear {
                progress.refreshForNewDayIfNeeded()
                if !didApplyResume, let resume = progress.resumeState(for: module.id) {
                    lessonIndex = min(resume.lessonIndex, max(0, module.lessonPages.count - 1))
                    switch resume.stage {
                    case .lesson:
                        stage = .lesson
                    case .scenario:
                        stage = .scenario
                    case .quiz:
                        stage = .quiz
                    }
                }
                didApplyResume = true
                withAnimation(.easeOut(duration: 0.4)) {
                    appeared = true
                }
            }
            .onChange(of: stage) { newStage in
                switch newStage {
                case .lesson:
                    progress.updateResume(moduleId: module.id, stage: .lesson, lessonIndex: lessonIndex)
                case .scenario:
                    progress.updateResume(moduleId: module.id, stage: .scenario, lessonIndex: lessonIndex)
                case .quiz:
                    progress.updateResume(moduleId: module.id, stage: .quiz, lessonIndex: lessonIndex, quizState: progress.resumeState(for: module.id)?.quizState)
                case .complete:
                    progress.clearResume(for: module.id)
                }
            }
        }
        .navigationTitle(module.title)
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .center) {
            if progress.hearts == 0 && (stage == .scenario || stage == .quiz) {
                HeartsEmptyOverlay(onPractice: {
                    showPracticeSheet = true
                }, onExit: {
                    dismiss()
                })
            }
        }
        .sheet(isPresented: $showPracticeSheet) {
            PracticeSessionView()
                .environmentObject(progress)
        }
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
            .foregroundColor(isActive ? AppTheme.bg : AppTheme.muted)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(isActive ? AppTheme.primary : AppTheme.surface)
            )
    }
}

struct CompletionView: View {
    @EnvironmentObject private var progress: ProgressStore
    let moduleTitle: String
    let score: Int
    let scenarioResult: AssessmentResult
    let quizResult: AssessmentResult
    let showRacInput: Bool
    @Binding var racJustification: String
    let onComplete: () -> RewardSummary
    let onRetry: () -> Void

    @State private var didSave = false
    @State private var showShareSheet = false
    @State private var shareItems: [Any] = []
    @State private var completionDate = Date()
    @State private var rewardSummary: RewardSummary? = nil

    var body: some View {
        ScrollView {
            GlassCard {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Module Complete")
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.text)

                    Text(moduleTitle)
                        .font(AppFont.subtitle(16))
                        .foregroundColor(AppTheme.muted)

                    HStack(spacing: 12) {
                        VStack(alignment: .leading) {
                            Text("Scenario")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.muted)
                            Text("\(scenarioResult.score)/\(scenarioResult.total)")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.text)
                        }
                        VStack(alignment: .leading) {
                            Text("Quiz")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.muted)
                            Text("\(quizResult.score)/\(quizResult.total)")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.text)
                        }
                        Spacer()
                        ScoreBadge(score: score)
                    }

                    HStack(spacing: 10) {
                        Text("Status")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.muted)
                        Text(passed ? "Pass" : "Remediate")
                            .font(AppFont.subtitle(16))
                            .foregroundColor(passed ? AppTheme.primary : AppTheme.danger)
                    }
                    Text("Pass threshold: 80%")
                        .font(AppFont.body(12))
                        .foregroundColor(AppTheme.muted)

                    if showRacInput {
                        FormFieldLabel(text: "RAC Justification")
                        AppTextEditor(text: $racJustification, height: 100)
                    } else if !racJustification.isEmpty {
                        FormFieldLabel(text: "RAC Justification")
                        Text(racJustification)
                            .font(AppFont.body(12))
                            .foregroundColor(AppTheme.muted)
                    }

                    if didSave {
                        Button("Saved") {
                            // No-op once saved
                        }
                        .buttonStyle(OutlineButtonStyle())
                    } else {
                        Button("Save Progress") {
                            rewardSummary = onComplete()
                            didSave = true
                            completionDate = Date()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }

                    if let rewardSummary {
                        RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                    }

                    Button("Generate Completion Summary") {
                        let pdfData = CompletionSummaryPDF.generate(
                            moduleTitle: moduleTitle,
                            score: score,
                            scenarioResult: scenarioResult,
                            quizResult: quizResult,
                            passed: passed,
                            completionDate: completionDate,
                            racJustification: racJustification.isEmpty ? nil : racJustification
                        )
                        let safeTitle = moduleTitle.replacingOccurrences(of: " ", with: "-")
                        let fileURL = FileManager.default.temporaryDirectory
                            .appendingPathComponent("CompletionSummary-\(safeTitle).pdf")
                        try? pdfData.write(to: fileURL, options: .atomic)
                        shareItems = [fileURL]
                        showShareSheet = true
                    }
                    .buttonStyle(OutlineButtonStyle())

                    Button("Share Challenge") {
                        let appName = progress.selectedRole?.appTitle ?? "Inspector Trainer"
                        let text = "I completed \(moduleTitle) with a score of \(score)% in the \(appName)."
                        shareItems = [text]
                        showShareSheet = true
                    }
                    .buttonStyle(OutlineButtonStyle())

                    if !passed {
                        Button("Retry Module") {
                            onRetry()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: shareItems)
        }
    }

    private var passed: Bool {
        score >= 80
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if let popover = controller.popoverPresentationController {
            // Prefer the key window's root view as the anchor if available; otherwise, fall back to the controller's view.
            let sourceView: UIView
            if let keyWindowView = UIApplication.shared.keyWindow?.rootViewController?.view {
                sourceView = keyWindowView
            } else if let controllerView = controller.view {
                sourceView = controllerView
            } else {
                // As a last resort, create a temporary view to satisfy popover requirements.
                sourceView = UIView(frame: .zero)
            }

            popover.sourceView = sourceView
            let rect = sourceView.bounds
            popover.sourceRect = CGRect(
                x: rect.midX,
                y: rect.midY,
                width: 1,
                height: 1
            )
            popover.permittedArrowDirections = []
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

private extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

enum CompletionSummaryPDF {
    static func generate(
        moduleTitle: String,
        score: Int,
        scenarioResult: AssessmentResult,
        quizResult: AssessmentResult,
        passed: Bool,
        completionDate: Date,
        racJustification: String?
    ) -> Data {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let bounds = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: bounds)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        return renderer.pdfData { context in
            context.beginPage()

            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 26),
                .foregroundColor: UIColor.black
            ]
            let headingAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ]
            let bodyAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.darkGray
            ]

            var y: CGFloat = 48
            let x: CGFloat = 48
            let width: CGFloat = pageWidth - 96

            let title = "Training Completion Summary"
            title.draw(in: CGRect(x: x, y: y, width: width, height: 32), withAttributes: titleAttributes)
            y += 40

            let moduleLine = "Module: \(moduleTitle)"
            moduleLine.draw(in: CGRect(x: x, y: y, width: width, height: 20), withAttributes: headingAttributes)
            y += 24

            let dateLine = "Completion Date: \(formatter.string(from: completionDate))"
            dateLine.draw(in: CGRect(x: x, y: y, width: width, height: 18), withAttributes: bodyAttributes)
            y += 24

            let statusLine = "Status: \(passed ? "Pass" : "Remediate")"
            statusLine.draw(in: CGRect(x: x, y: y, width: width, height: 18), withAttributes: bodyAttributes)
            y += 24

            let scoreLine = "Overall Score: \(score)%"
            scoreLine.draw(in: CGRect(x: x, y: y, width: width, height: 18), withAttributes: bodyAttributes)
            y += 24

            let scenarioLine = "Scenario: \(scenarioResult.score)/\(scenarioResult.total)"
            scenarioLine.draw(in: CGRect(x: x, y: y, width: width, height: 18), withAttributes: bodyAttributes)
            y += 18

            let quizLine = "Quiz: \(quizResult.score)/\(quizResult.total)"
            quizLine.draw(in: CGRect(x: x, y: y, width: width, height: 18), withAttributes: bodyAttributes)
            y += 30

            if let racJustification, !racJustification.isEmpty {
                let racTitle = "RAC Justification"
                racTitle.draw(in: CGRect(x: x, y: y, width: width, height: 18), withAttributes: headingAttributes)
                y += 22
                racJustification.draw(in: CGRect(x: x, y: y, width: width, height: 80), withAttributes: bodyAttributes)
                y += 90
            }

            let noteTitle = "Notes"
            noteTitle.draw(in: CGRect(x: x, y: y, width: width, height: 18), withAttributes: headingAttributes)
            y += 22

            let noteText = "This summary is a training aid and does not replace official Air Force guidance or OSHA requirements. Verify current publications and local procedures."
            noteText.draw(in: CGRect(x: x, y: y, width: width, height: 60), withAttributes: bodyAttributes)
        }
    }
}
