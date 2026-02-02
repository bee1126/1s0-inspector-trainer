import SwiftUI

struct ScenarioFlowView: View {
    let scenario: Scenario
    let onComplete: (Result) -> Void

    @State private var currentStepId: String
    @State private var selectedOptionId: String? = nil
    @State private var showFeedback = false
    @State private var correctCount = 0
    @State private var answeredCount = 0

    init(scenario: Scenario, onComplete: @escaping (Result) -> Void) {
        self.scenario = scenario
        self.onComplete = onComplete
        _currentStepId = State(initialValue: scenario.startStepId)
    }

    var body: some View {
        let step = stepForCurrent()

        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
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

                Text(step.prompt)
                    .font(AppFont.subtitle(17))
                    .foregroundColor(AppTheme.charcoal)

                VStack(spacing: 10) {
                    ForEach(step.options, id: \.id) { option in
                        OptionRow(
                            text: option.text,
                            isSelected: selectedOptionId == option.id,
                            isCorrect: option.isCorrect,
                            isLocked: selectedOptionId != nil
                        )
                        .onTapGesture {
                            guard selectedOptionId == nil else { return }
                            selectedOptionId = option.id
                            answeredCount += 1
                            if option.isCorrect {
                                correctCount += 1
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
        .padding(.horizontal, 20)
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
            currentStepId = nextId
            selectedOptionId = nil
            showFeedback = false
        } else {
            onComplete(Result(score: correctCount, total: answeredCount))
        }
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

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(.top, 6)
            Text(text)
                .font(AppFont.body(14))
                .foregroundColor(AppTheme.charcoal)
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(isSelected ? Color.white : Color.white.opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(borderColor, lineWidth: 1)
                )
        )
        .opacity(isLocked && !isSelected ? 0.6 : 1.0)
    }

    private var indicatorColor: Color {
        if isSelected {
            return isCorrect ? AppTheme.safetyGreen : Color.red.opacity(0.8)
        }
        return AppTheme.blue
    }

    private var borderColor: Color {
        if isSelected {
            return isCorrect ? AppTheme.safetyGreen : Color.red.opacity(0.7)
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
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(isCorrect ? AppTheme.mint.opacity(0.6) : Color.red.opacity(0.1))
        )
    }
}
