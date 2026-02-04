import SwiftUI

struct ScenarioFlowView: View {
    @EnvironmentObject private var progress: ProgressStore
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

    private let timeLimit = 25
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(scenario: Scenario, onWrongAnswer: (() -> Void)? = nil, showsHearts: Bool = true, onComplete: @escaping (AssessmentResult) -> Void) {
        self.scenario = scenario
        self.onWrongAnswer = onWrongAnswer
        self.showsHearts = showsHearts
        self.onComplete = onComplete
        _currentStepId = State(initialValue: scenario.startStepId)
        let startStep = scenario.steps.first(where: { $0.id == scenario.startStepId })
        _shuffledOptionsByStepId = State(initialValue: [
            scenario.startStepId: (startStep?.options ?? []).shuffled()
        ])
    }

    var body: some View {
        let step = stepForCurrent()
        let options = shuffledOptionsByStepId[step.id] ?? step.options

        GlassCard {
            VStack(alignment: .leading, spacing: AppSpacing.stack) {
                Text("Scenario")
                    .font(AppFont.mono(12))
                    .foregroundColor(AppTheme.charcoal.opacity(0.6))

                Text(scenario.title)
                    .font(AppFont.title(22))
                    .foregroundColor(AppTheme.charcoal)

                Text(scenario.intro)
                    .font(AppFont.body(14))
                    .foregroundColor(AppTheme.charcoal.opacity(0.75))

                Divider().opacity(0.3)

                HStack {
                    Text("Time")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
                    Text("\(timeLeft)s")
                        .font(AppFont.subtitle(14))
                        .foregroundColor(timeLeft <= 5 ? Color.red.opacity(0.8) : AppTheme.charcoal)
                    Spacer()
                    if showsHearts {
                        HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, compact: true, onDark: false)
                    }
                    Toggle("Time Pressure", isOn: $timerActive)
                        .labelsHidden()
                        .tint(AppTheme.blue)
                }

                Text(step.prompt)
                    .font(AppFont.subtitle(17))
                    .foregroundColor(AppTheme.charcoal)

                VStack(spacing: 10) {
                    ForEach(options, id: \.id) { option in
                        OptionRow(
                            text: option.text,
                            isSelected: selectedOptionId == option.id,
                            isCorrect: option.isCorrect,
                            isLocked: selectedOptionId != nil,
                            revealCorrect: true
                        )
                        .onTapGesture {
                            guard selectedOptionId == nil else { return }
                            selectedOptionId = option.id
                            answeredCount += 1
                            if option.isCorrect {
                                correctCount += 1
                            } else {
                                onWrongAnswer?()
                            }
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showFeedback = true
                            }
                        }
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
        .padding(.horizontal, AppSpacing.screenPadding)
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
}

private extension ScenarioStep {
    func nextStepId(for selectedOptionId: String?) -> String? {
        guard let selectedOptionId else { return nil }
        return options.first(where: { $0.id == selectedOptionId })?.nextStepId
    }
}

struct OptionRow: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isLocked: Bool
    var revealCorrect: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(.top, 6)
            Text(text)
                .font(AppFont.body(14))
                .foregroundColor(AppTheme.charcoal)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.item)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(isSelected ? Color.white : Color.white.opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(borderColor, lineWidth: 1)
                )
        )
        .opacity(isLocked && !isSelected && !(revealCorrect && isCorrect) ? 0.6 : 1.0)
    }

    private var indicatorColor: Color {
        if isSelected {
            return isCorrect ? AppTheme.safetyGreen : Color.red.opacity(0.8)
        }
        if revealCorrect && isLocked && isCorrect {
            return AppTheme.safetyGreen
        }
        return AppTheme.blue
    }

    private var borderColor: Color {
        if isSelected {
            return isCorrect ? AppTheme.safetyGreen : Color.red.opacity(0.7)
        }
        if revealCorrect && isLocked && isCorrect {
            return AppTheme.safetyGreen.opacity(0.85)
        }
        return Color.white.opacity(0.4)
    }
}

struct FeedbackView: View {
    let text: String
    let isCorrect: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(isCorrect ? AppTheme.safetyGreen : Color.red.opacity(0.7))
                .frame(width: 10, height: 10)
                .padding(.top, 6)
            Text(text)
                .font(AppFont.body(14))
                .foregroundColor(AppTheme.charcoal)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(AppSpacing.item)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(isCorrect ? AppTheme.mint.opacity(0.6) : Color.red.opacity(0.1))
        )
    }
}
