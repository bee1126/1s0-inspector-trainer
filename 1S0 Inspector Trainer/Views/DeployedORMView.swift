import SwiftUI

struct DeployedORMView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var phase: GamePhase = .picker
    @State private var scenario: ORMScenario = DeployedORMBank.allScenarios[0]
    @State private var steps: [ORMProcessingStep] = []
    @State private var currentStepIndex: Int = 0
    @State private var stepResults: [String: Bool] = [:]
    @State private var selectedAnswers: [String: Int] = [:]
    @State private var rewardSummary: RewardSummary? = nil
    @State private var earnedBadgeThisRun = false

    private enum GamePhase {
        case picker
        case situationBrief
        case step
        case stepFeedback
        case debrief
        case rewards
    }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(spacing: AppSpacing.section) {
                    header

                    switch phase {
                    case .picker:
                        scenarioPickerView
                    case .situationBrief:
                        situationBriefView
                    case .step:
                        stepView
                    case .stepFeedback:
                        stepFeedbackView
                    case .debrief:
                        debriefView
                    case .rewards:
                        rewardsView
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Deployed ORM")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(phase != .picker)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if phase != .picker {
                    Button {
                        goBack()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Back")
                                .font(AppFont.body(14))
                        }
                        .foregroundColor(AppTheme.primary)
                    }
                }
            }
        }
    }

    // MARK: - Navigation

    private func goBack() {
        switch phase {
        case .picker:
            dismiss()
        case .situationBrief:
            transition(to: .picker)
        case .step:
            if currentStepIndex > 0 {
                currentStepIndex = 0
                stepResults = [:]
                selectedAnswers = [:]
            }
            transition(to: .situationBrief)
        case .stepFeedback:
            transition(to: .step)
        case .debrief, .rewards:
            resetAndReturn()
        }
    }

    private func resetAndReturn() {
        currentStepIndex = 0
        stepResults = [:]
        selectedAnswers = [:]
        rewardSummary = nil
        earnedBadgeThisRun = false
        transition(to: .picker)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("FIELD EXERCISE")
                .font(AppFont.mono(11))
                .foregroundColor(AppTheme.muted)
                .tracking(1.5)
            Spacer()
        }
    }

    // MARK: - Scenario Picker

    private var scenarioPickerView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.stack) {
            if progress.allORMScenariosCompleted {
                GlassCard(glow: AppTheme.primary.opacity(0.5)) {
                    HStack(spacing: 10) {
                        Image(systemName: "medal.fill")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(AppTheme.accent)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ORM FIELD ADVISOR")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.accent)
                                .tracking(1)
                            Text("All scenarios assessed. Badge earned!")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.text)
                        }
                        Spacer()
                    }
                }
            } else {
                GlassCard {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Assess deployed operational risks through a 5-step ORM workflow. Complete all \(DeployedORMBank.allScenarios.count) to earn the ORM Field Advisor badge.")
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.muted)
                        HStack(spacing: 4) {
                            Text("\(progress.completedORMScenarios.count)/\(DeployedORMBank.allScenarios.count)")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.text)
                            Text("completed")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.muted)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(AppTheme.border)
                                    .frame(height: 6)
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(AppTheme.primary)
                                    .frame(width: geo.size.width * pickerProgress, height: 6)
                                    .shadow(color: AppTheme.primary.opacity(0.4), radius: 4, x: 0, y: 0)
                            }
                        }
                        .frame(height: 6)
                    }
                }
            }

            ForEach(DeployedORMBank.allScenarios, id: \.id) { s in
                Button {
                    scenario = s
                    steps = DeployedORMBank.steps(for: s)
                    currentStepIndex = 0
                    stepResults = [:]
                    selectedAnswers = [:]
                    rewardSummary = nil
                    earnedBadgeThisRun = false
                    transition(to: .situationBrief)
                } label: {
                    scenarioRow(s)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func scenarioRow(_ s: ORMScenario) -> some View {
        let isCompleted = progress.completedORMScenarios.contains(s.id)
        return GlassCard(glow: isCompleted ? AppTheme.primary.opacity(0.2) : .clear) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(s.title)
                        .font(AppFont.subtitle(14))
                        .foregroundColor(AppTheme.text)
                        .multilineTextAlignment(.leading)
                    Text(s.location)
                        .font(AppFont.mono(11))
                        .foregroundColor(AppTheme.info)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(AppTheme.primary)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppTheme.muted)
                }
            }
        }
    }

    private var pickerProgress: Double {
        let total = DeployedORMBank.allScenarios.count
        guard total > 0 else { return 0 }
        return Double(progress.completedORMScenarios.count) / Double(total)
    }

    // MARK: - Situation Brief (SITREP)

    private var situationBriefView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.stack) {
            GlassCard(glow: Color(red: 0.9, green: 0.5, blue: 0.1).opacity(0.3)) {
                VStack(alignment: .leading, spacing: AppSpacing.stack) {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.shield")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.9, green: 0.5, blue: 0.1))
                        Text("DEPLOYED ORM ASSESSMENT")
                            .font(AppFont.mono(12))
                            .foregroundColor(Color(red: 0.9, green: 0.5, blue: 0.1))
                            .tracking(1)
                    }

                    sitrepField(label: "LOCATION", value: scenario.location)
                    sitrepField(label: "MISSION CONTEXT", value: scenario.missionContext)
                    sitrepField(label: "SITUATION", value: scenario.situationBrief)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("COMPLICATING FACTORS")
                            .font(AppFont.mono(10))
                            .foregroundColor(AppTheme.muted)
                            .tracking(0.5)
                        ForEach(Array(scenario.complicatingFactors.enumerated()), id: \.offset) { _, factor in
                            HStack(alignment: .top, spacing: 6) {
                                Text("\u{2022}")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.danger)
                                Text(factor)
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.text)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }

            GlassCard {
                VStack(alignment: .leading, spacing: 6) {
                    Text("You will process this scenario through 5 ORM decision steps.")
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.muted)
                    Text("Read the situation brief carefully before proceeding. Consider the complicating factors — they represent the 'gray area' pressures you will face.")
                        .font(AppFont.body(12))
                        .foregroundColor(AppTheme.muted)
                }
            }

            Button {
                transition(to: .step)
            } label: {
                HStack {
                    Text("Begin Assessment")
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    private func sitrepField(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(AppFont.mono(10))
                .foregroundColor(AppTheme.muted)
                .tracking(0.5)
            Text(value)
                .font(AppFont.body(14))
                .foregroundColor(AppTheme.text)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Step View

    private var currentStep: ORMProcessingStep {
        steps[currentStepIndex]
    }

    private var stepView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.stack) {
            stepProgressBar

            GlassCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text(currentStep.title)
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.accent)
                        .tracking(1)

                    Text(currentStep.prompt)
                        .font(AppFont.body(14))
                        .foregroundColor(AppTheme.text)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            ForEach(Array(currentStep.options.enumerated()), id: \.offset) { index, option in
                Button {
                    selectOption(index)
                } label: {
                    optionRow(text: option, index: index)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func selectOption(_ index: Int) {
        let step = currentStep
        selectedAnswers[step.id] = index
        stepResults[step.id] = index == step.correctIndex
        if index == step.correctIndex {
            AppFeedback.correct()
        } else {
            AppFeedback.incorrect()
        }
        transition(to: .stepFeedback)
    }

    private func optionRow(text: String, index: Int) -> some View {
        HStack(spacing: 12) {
            Text(String(UnicodeScalar(65 + index)!))
                .font(AppFont.mono(13))
                .foregroundColor(AppTheme.accent)
                .frame(width: 28, height: 28)
                .background(
                    Circle().fill(AppTheme.accent.opacity(0.1))
                )

            Text(text)
                .font(AppFont.body(14))
                .foregroundColor(AppTheme.text)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(AppSpacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(AppTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(AppTheme.border, lineWidth: 1)
        )
    }

    private var stepProgressBar: some View {
        HStack(spacing: 6) {
            Text("STEP \(currentStepIndex + 1) OF \(steps.count)")
                .font(AppFont.mono(11))
                .foregroundColor(AppTheme.muted)
                .tracking(1)

            Spacer()

            ForEach(0..<steps.count, id: \.self) { index in
                Circle()
                    .fill(stepDotColor(for: index))
                    .frame(width: 8, height: 8)
            }
        }
    }

    private func stepDotColor(for index: Int) -> Color {
        if let result = stepResults[steps[index].id] {
            return result ? AppTheme.primary : AppTheme.danger
        }
        if index == currentStepIndex {
            return AppTheme.accent
        }
        return AppTheme.border
    }

    // MARK: - Step Feedback

    private var stepFeedbackView: some View {
        let step = currentStep
        let isCorrect = stepResults[step.id] ?? false
        let selectedIndex = selectedAnswers[step.id] ?? 0
        let feedbackColor = isCorrect ? AppTheme.primary : AppTheme.danger

        return VStack(alignment: .leading, spacing: AppSpacing.stack) {
            stepProgressBar

            GlassCard(glow: feedbackColor.opacity(0.4)) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(feedbackColor)
                        Text(isCorrect ? "Correct!" : "Incorrect")
                            .font(AppFont.subtitle(16))
                            .foregroundColor(feedbackColor)
                    }

                    if !isCorrect {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your answer:")
                                .font(AppFont.mono(10))
                                .foregroundColor(AppTheme.muted)
                            Text(step.options[selectedIndex])
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.danger)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Correct answer:")
                                .font(AppFont.mono(10))
                                .foregroundColor(AppTheme.muted)
                            Text(step.options[step.correctIndex])
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }

            GlassCard {
                VStack(alignment: .leading, spacing: 6) {
                    Text("EXPLANATION")
                        .font(AppFont.mono(10))
                        .foregroundColor(AppTheme.muted)
                        .tracking(1)
                    Text(step.explanation)
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.text)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Button {
                advanceStep()
            } label: {
                HStack {
                    Text(currentStepIndex < steps.count - 1 ? "Next Step" : "View Results")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    private func advanceStep() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
            transition(to: .step)
        } else {
            submitScore()
            transition(to: .debrief)
        }
    }

    // MARK: - Debrief

    private var debriefView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.stack) {
            GlassCard(glow: scoreColor.opacity(0.4)) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "clipboard.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(scoreColor)
                        Text("ORM ASSESSMENT DEBRIEF")
                            .font(AppFont.mono(12))
                            .foregroundColor(scoreColor)
                    }
                    Text(scenario.title)
                        .font(AppFont.subtitle(15))
                        .foregroundColor(AppTheme.text)
                    HStack(spacing: 12) {
                        Text("Score: \(scorePercent)%")
                            .font(AppFont.mono(16))
                            .foregroundColor(scoreColor)
                        Text("\(correctCount)/\(steps.count) correct")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.muted)
                    }
                }
            }

            Text("STEP RESULTS")
                .font(AppFont.mono(10))
                .foregroundColor(AppTheme.muted)
                .tracking(1)

            ForEach(steps) { step in
                let isCorrect = stepResults[step.id] ?? false
                let selectedIndex = selectedAnswers[step.id] ?? 0
                GlassCard(glow: (isCorrect ? AppTheme.primary : AppTheme.danger).opacity(0.2)) {
                    HStack(spacing: 10) {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(isCorrect ? AppTheme.primary : AppTheme.danger)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(step.title)
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.text)
                            if !isCorrect {
                                Text("Answered: \(step.options[selectedIndex])")
                                    .font(AppFont.body(11))
                                    .foregroundColor(AppTheme.danger)
                                Text("Correct: \(step.options[step.correctIndex])")
                                    .font(AppFont.body(11))
                                    .foregroundColor(AppTheme.primary)
                            }
                        }
                        Spacer()
                    }
                }
            }

            GlassCard(glow: AppTheme.info.opacity(0.2)) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppTheme.info)
                        Text("RECOMMENDED ACTION")
                            .font(AppFont.mono(10))
                            .foregroundColor(AppTheme.info)
                            .tracking(1)
                    }
                    Text(scenario.recommendedAction)
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.text)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Button {
                transition(to: .rewards)
            } label: {
                HStack {
                    Text("Continue")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    // MARK: - Rewards

    private var rewardsView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.stack) {
            GlassCard(glow: AppTheme.primary.opacity(0.4)) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppTheme.accent)
                        Text("SCENARIO ASSESSED")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.accent)
                    }

                    Text(scenario.title)
                        .font(AppFont.subtitle(15))
                        .foregroundColor(AppTheme.text)

                    HStack(spacing: 12) {
                        ScoreBadge(score: scorePercent)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(scoreMessage)
                                .font(AppFont.body(14))
                                .foregroundColor(AppTheme.text)
                            Text("\(correctCount)/\(steps.count) steps correct")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                        }
                    }
                }
            }

            if let rewardSummary {
                RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
            }

            if earnedBadgeThisRun {
                GlassCard(glow: AppTheme.accent.opacity(0.6)) {
                    HStack(spacing: 10) {
                        Image(systemName: "medal.fill")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(AppTheme.accent)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("BADGE EARNED!")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.accent)
                                .tracking(1)
                            Text("ORM Field Advisor \u{2014} All scenarios assessed")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.text)
                        }
                        Spacer()
                    }
                }
            }

            Button {
                resetAndReturn()
            } label: {
                HStack {
                    Text("Choose Another Scenario")
                    Spacer()
                    Image(systemName: "list.bullet")
                }
            }
            .buttonStyle(PrimaryButtonStyle())

            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Back to HQ")
                    Spacer()
                    Image(systemName: "house.fill")
                }
            }
            .buttonStyle(OutlineButtonStyle())
        }
    }

    // MARK: - Scoring

    private var correctCount: Int {
        stepResults.values.filter { $0 }.count
    }

    private var scorePercent: Int {
        guard !steps.isEmpty else { return 0 }
        return Int(round(Double(correctCount) / Double(steps.count) * 100))
    }

    private var scoreColor: Color {
        scorePercent >= 90 ? AppTheme.primary : scorePercent >= 70 ? AppTheme.accent : AppTheme.danger
    }

    private var scoreMessage: String {
        if scorePercent >= 90 {
            return "Outstanding assessment. You demonstrated strong deployed ORM skills."
        } else if scorePercent >= 70 {
            return "Solid effort. Review the missed steps to sharpen your risk assessment."
        } else if scorePercent >= 50 {
            return "Needs improvement. Several ORM decision points were incorrect."
        } else {
            return "Review DAFPAM 90-803 RM procedures and deployed safety guidance, then try again."
        }
    }

    private func submitScore() {
        let hadBadgeBefore = progress.allORMScenariosCompleted
        rewardSummary = progress.completePractice(score: correctCount, total: steps.count)
        progress.markORMScenarioCompleted(scenario.id)
        earnedBadgeThisRun = !hadBadgeBefore && progress.allORMScenariosCompleted
        if scorePercent >= 70 {
            AppFeedback.correct()
        } else {
            AppFeedback.incorrect()
        }
    }

    // MARK: - Transition

    private func transition(to destination: GamePhase) {
        if reduceMotion {
            phase = destination
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                phase = destination
            }
        }
    }
}
