import SwiftUI

struct ScenarioFlowView: View {
    @EnvironmentObject private var progress: ProgressStore
    @EnvironmentObject private var adaptiveManager: AdaptiveDifficultyManager
    let scenario: Scenario
    var onWrongAnswer: (() -> Void)? = nil
    let onComplete: (AssessmentResult) -> Void
    var showsHearts: Bool = true

    @State private var currentStepId: String
    @State private var selectedOptionId: String? = nil
    @State private var showFeedback = false
    @State private var correctCount = 0
    @State private var answeredCount = 0
    @State private var timeLeft: Int = 25
    @State private var timerActive = true
    @State private var shuffledOptionsByStepId: [String: [ScenarioOption]]
    private let swipeThreshold: CGFloat = 70

    private let timeLimit = 25
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(scenario: Scenario, onWrongAnswer: (() -> Void)? = nil, showsHearts: Bool = true, onComplete: @escaping (AssessmentResult) -> Void) {
        self.scenario = scenario
        self.onWrongAnswer = onWrongAnswer
        self.showsHearts = showsHearts
        self.onComplete = onComplete
        _currentStepId = State(initialValue: scenario.startStepId)
        _shuffledOptionsByStepId = State(initialValue: Self.buildShuffledOptions(for: scenario))
    }

    var body: some View {
        let step = stepForCurrent()
        let options = shuffledOptionsByStepId[step.id] ?? step.options

        ScrollView {
            GlassCard {
                VStack(alignment: .leading, spacing: AppSpacing.stack) {
                    Text("Scenario")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.muted)

                    Text(scenario.title)
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.text)

                    Text(scenario.intro)
                        .font(AppFont.body(14))
                        .foregroundColor(AppTheme.muted)

                    Divider().overlay(AppTheme.border)

                    HStack {
                        Text("Time")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.muted)
                        Text("\(timeLeft)s")
                            .font(AppFont.subtitle(14))
                            .foregroundColor(timeLeft <= 5 ? AppTheme.danger : AppTheme.text)
                        Spacer()
                        if showsHearts {
                            HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, compact: true, onDark: false)
                        }
                        Toggle("Time Pressure", isOn: $timerActive)
                            .labelsHidden()
                            .tint(AppTheme.primary)
                    }

                    Text(step.prompt)
                        .font(AppFont.subtitle(17))
                        .foregroundColor(AppTheme.text)

                    VStack(spacing: 10) {
                        ForEach(options, id: \.id) { option in
                            Button {
                                guard selectedOptionId == nil else { return }
                                selectedOptionId = option.id
                                answeredCount += 1
                                if option.isCorrect {
                                    correctCount += 1
                                    adaptiveManager.recordCorrect()
                                    AppFeedback.correct()
                                } else {
                                    onWrongAnswer?()
                                    adaptiveManager.recordWrong()
                                    AppFeedback.incorrect()
                                }
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showFeedback = true
                                }
                            } label: {
                                OptionRow(
                                    text: option.text,
                                    isSelected: selectedOptionId == option.id,
                                    isCorrect: option.isCorrect,
                                    isLocked: selectedOptionId != nil,
                                    revealCorrect: true
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    if let selectedId = selectedOptionId, let option = step.options.first(where: { $0.id == selectedId }) {
                        FeedbackView(text: option.feedback, isCorrect: option.isCorrect)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    if showFeedback {
                        Button(step.nextStepId(for: selectedOptionId) == nil ? "Finish Scenario" : "Continue") {
                            advance(from: step)
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
            }
            .tacticalReadableWidth()
            .padding(.horizontal, AppSpacing.screenPadding)
        }
        .scrollIndicators(.hidden)
        .simultaneousGesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    handleSwipe(value, step: step)
                }
        )
        .onChange(of: currentStepId) { newValue in
            ensureOptions(for: newValue)
        }
        .onReceive(timer) { _ in
            guard timerActive, selectedOptionId == nil else { return }
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                triggerTimeout(for: step)
            }
        }
        .onAppear {
            ensureOptions(for: scenario.startStepId)
            resetTimer()
        }
    }

    private func stepForCurrent() -> ScenarioStep {
        scenario.steps.first(where: { $0.id == currentStepId }) ?? scenario.steps[0]
    }

    private func advance(from step: ScenarioStep) {
        guard let selectedId = selectedOptionId,
              let option = step.options.first(where: { $0.id == selectedId }) else {
            return
        }

        if let nextId = option.nextStepId {
            ensureOptions(for: nextId)
            currentStepId = nextId
            selectedOptionId = nil
            showFeedback = false
            resetTimer()
        } else {
            onComplete(AssessmentResult(score: correctCount, total: answeredCount))
        }
    }

    private func triggerTimeout(for step: ScenarioStep) {
        guard selectedOptionId == nil else { return }
        let options = shuffledOptionsByStepId[step.id] ?? step.options
        if let fallback = options.filter({ !$0.isCorrect }).randomElement() ?? options.randomElement() {
            selectedOptionId = fallback.id
            answeredCount += 1
            onWrongAnswer?()
            adaptiveManager.recordWrong()
            AppFeedback.incorrect()
            showFeedback = true
        }
    }

    private func resetTimer() {
        timeLeft = timeLimit
    }

    private func ensureOptions(for stepId: String) {
        guard shuffledOptionsByStepId[stepId] == nil,
              let step = scenario.steps.first(where: { $0.id == stepId }) else {
            return
        }
        shuffledOptionsByStepId[stepId] = step.options.shuffled()
    }

    private func handleSwipe(_ value: DragGesture.Value, step: ScenarioStep) {
        guard showFeedback else { return }
        let horizontal = value.translation.width
        guard abs(horizontal) > swipeThreshold else { return }
        if horizontal < 0 {
            advance(from: step)
        }
    }

    private static func buildShuffledOptions(for scenario: Scenario) -> [String: [ScenarioOption]] {
        let maxAttempts = 6
        var attempts = 0
        var optionsByStepId = shuffleOptionsMap(for: scenario.steps)
        while attempts < maxAttempts && allCorrectIndicesSame(steps: scenario.steps, optionsByStepId: optionsByStepId) {
            optionsByStepId = shuffleOptionsMap(for: scenario.steps)
            attempts += 1
        }
        return optionsByStepId
    }

    private static func shuffleOptionsMap(for steps: [ScenarioStep]) -> [String: [ScenarioOption]] {
        Dictionary(uniqueKeysWithValues: steps.map { ($0.id, $0.options.shuffled()) })
    }

    private static func allCorrectIndicesSame(steps: [ScenarioStep], optionsByStepId: [String: [ScenarioOption]]) -> Bool {
        guard steps.count >= 2 else { return false }
        var targetIndex: Int? = nil
        for step in steps {
            guard let options = optionsByStepId[step.id],
                  let correctIndex = options.firstIndex(where: { $0.isCorrect }) else {
                return false
            }
            if let targetIndex {
                if correctIndex != targetIndex { return false }
            } else {
                targetIndex = correctIndex
            }
        }
        return targetIndex != nil
    }
}

private extension ScenarioStep {
    func nextStepId(for selectedOptionId: String?) -> String? {
        guard let selectedOptionId else { return nil }
        return options.first(where: { $0.id == selectedOptionId })?.nextStepId
    }
}
