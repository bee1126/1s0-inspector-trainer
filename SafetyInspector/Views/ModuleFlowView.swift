import SwiftUI
import UIKit

struct ModuleFlowView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    let module: TrainingModule

    @State private var stage: ModuleStage = .lesson
    @State private var scenarioResult = AssessmentResult(score: 0, total: 0)
    @State private var quizResult = AssessmentResult(score: 0, total: 0)
    @State private var appeared = false
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
                    LessonPagerView(pages: module.lessonPages, onSkip: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            stage = .scenario
                        }
                    }) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            stage = .scenario
                        }
                    }
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
                    }, onComplete: { result in
                        quizResult = result
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            stage = .complete
                        }
                    }, showsHearts: false, shuffleQuestions: true, maxQuestions: 10)
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
                            quizResult: quizResult
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
                withAnimation(.easeOut(duration: 0.4)) {
                    appeared = true
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
            .foregroundColor(isActive ? .white : AppTheme.charcoal)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(isActive ? AppTheme.blue : Color.white.opacity(0.85))
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

                HStack(spacing: 10) {
                    Text("Status")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
                    Text(passed ? "Pass" : "Remediate")
                        .font(AppFont.subtitle(16))
                        .foregroundColor(passed ? AppTheme.safetyGreen : Color.red.opacity(0.8))
                }
                Text("Pass threshold: 80%")
                    .font(AppFont.body(12))
                    .foregroundColor(AppTheme.charcoal.opacity(0.6))

                if showRacInput {
                    FormFieldLabel(text: "RAC Justification")
                    AppTextEditor(text: $racJustification, height: 100)
                } else if !racJustification.isEmpty {
                    FormFieldLabel(text: "RAC Justification")
                    Text(racJustification)
                        .font(AppFont.body(12))
                        .foregroundColor(AppTheme.charcoal.opacity(0.7))
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
                    let text = "I completed \(moduleTitle) with a score of \(score)% in the Safety Inspector Trainer."
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

// MARK: - Placeholders for missing app-specific types and views to allow compilation
// Simple theme and font placeholders
struct AppTheme {
    static let charcoal = Color.black.opacity(0.85)
    static let blue = Color.blue
    static let safetyGreen = Color.green
}

struct AppFont {
    static func title(_ size: CGFloat) -> Font { .system(size: size, weight: .bold) }
    static func subtitle(_ size: CGFloat) -> Font { .system(size: size, weight: .semibold) }
    static func body(_ size: CGFloat) -> Font { .system(size: size, weight: .regular) }
    static func mono(_ size: CGFloat) -> Font { .system(size: size, design: .monospaced) }
}

struct AppSpacing {
    static let stack: CGFloat = 16
    static let screenPadding: CGFloat = 16
}

// Placeholder models
struct AssessmentResult {
    var score: Int
    var total: Int
}

struct TrainingModule {
    var id: String
    var title: String
    var lessonPages: [String] = []
    var scenario: String = ""
    var quiz: [String] = []
}

// Placeholder progress store
final class ProgressStore: ObservableObject {
    @Published var hearts: Int = 5
    let maxHearts: Int = 5
    var xpToNextLevel: Int { 100 }

    func refreshForNewDayIfNeeded() {}
    func consumeHeart() { hearts = max(0, hearts - 1) }
    @discardableResult
    func completeModule(moduleId: String, score: Int, scenarioResult: AssessmentResult, quizResult: AssessmentResult) -> RewardSummary {
        return RewardSummary(xpEarned: 10, coinsEarned: 1)
    }
}

// Placeholder reward summary and card
struct RewardSummary {
    var xpEarned: Int
    var coinsEarned: Int
}

struct RewardSummaryCard: View {
    let summary: RewardSummary
    let xpToNextLevel: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rewards")
                .font(AppFont.subtitle(16))
            Text("XP: \(summary.xpEarned) • Coins: \(summary.coinsEarned)")
                .font(AppFont.body(14))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.9)))
    }
}

// Placeholder views used in ModuleFlowView
struct BackgroundView: View { var body: some View { Color(.systemGroupedBackground).ignoresSafeArea() } }

struct HeartsView: View {
    let hearts: Int
    let maxHearts: Int
    var body: some View { Text("\(hearts)/\(maxHearts) ❤︎").font(AppFont.mono(12)) }
}

struct LessonPagerView: View {
    let pages: [String]
    let onSkip: () -> Void
    let onComplete: () -> Void
    var body: some View {
        VStack(spacing: 12) {
            Text("Lesson (") + Text("\(pages.count)") + Text(")")
            Button("Skip", action: onSkip)
            Button("Continue", action: onComplete)
        }
        .padding()
    }
}

struct ScenarioFlowView: View {
    let scenario: String
    let onWrongAnswer: () -> Void
    let showsHearts: Bool
    let onComplete: (AssessmentResult) -> Void
    var body: some View {
        VStack(spacing: 12) {
            Text("Scenario")
            Button("Wrong Answer", action: onWrongAnswer)
            Button("Complete") { onComplete(AssessmentResult(score: 1, total: 1)) }
        }
        .padding()
    }
}

struct QuizFlowView: View {
    let questions: [String]
    let onWrongAnswer: () -> Void
    let onComplete: (AssessmentResult) -> Void
    let showsHearts: Bool
    let shuffleQuestions: Bool
    let maxQuestions: Int
    var body: some View {
        VStack(spacing: 12) {
            Text("Quiz (") + Text("\(min(maxQuestions, questions.count))") + Text(")")
            Button("Wrong Answer", action: onWrongAnswer)
            Button("Finish") { onComplete(AssessmentResult(score: 1, total: 1)) }
        }
        .padding()
    }
}

struct HeartsEmptyOverlay: View {
    let onPractice: () -> Void
    let onExit: () -> Void
    var body: some View {
        VStack(spacing: 12) {
            Text("Out of hearts")
            Button("Practice", action: onPractice)
            Button("Exit", action: onExit)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
    }
}

struct PracticeSessionView: View { var body: some View { Text("Practice Session") } }

struct GlassCard<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct ScoreBadge: View {
    let score: Int
    var body: some View {
        Text("\(score)%")
            .font(AppFont.subtitle(16))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.blue.opacity(0.15)))
    }
}

struct FormFieldLabel: View {
    let text: String
    var body: some View { Text(text).font(AppFont.mono(12)).foregroundColor(AppTheme.charcoal.opacity(0.6)) }
}

struct AppTextEditor: View {
    @Binding var text: String
    var height: CGFloat
    var body: some View {
        TextEditor(text: $text)
            .frame(minHeight: height, maxHeight: height)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
    }
}

// Placeholder button styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
            .foregroundColor(Color.blue)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

