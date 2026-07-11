import SwiftUI

struct HazardReportView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var phase: GamePhase = .picker
    @State private var scenario: HazardReportScenario = HazardReportBank.allScenarios[0]
    @State private var steps: [HazardProcessingStep] = []
    @State private var currentStepIndex: Int = 0
    @State private var stepResults: [String: Bool] = [:]
    @State private var selectedAnswers: [String: Int] = [:]
    @State private var rewardSummary: RewardSummary? = nil
    @State private var earnedBadgeThisRun = false

    private enum GamePhase {
        case picker
        case reportReview
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
                    case .reportReview:
                        reportReviewView
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
        .navigationTitle("Hazard Report")
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
        case .reportReview:
            transition(to: .picker)
        case .step:
            if currentStepIndex > 0 {
                currentStepIndex = 0
                stepResults = [:]
                selectedAnswers = [:]
            }
            transition(to: .reportReview)
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
            if progress.allHazardReportsCompleted {
                GlassCard(glow: AppTheme.primary.opacity(0.5)) {
                    HStack(spacing: 10) {
                        Image(systemName: "medal.fill")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(AppTheme.accent)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("HAZARD ANALYST")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.accent)
                                .tracking(1)
                            Text("All reports processed. Badge earned!")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.text)
                        }
                        Spacer()
                    }
                }
            } else {
                GlassCard {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Process DAF Form 457 hazard reports through the correct workflow. Complete all \(HazardReportBank.allScenarios.count) to earn the Hazard Analyst badge.")
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.muted)
                        HStack(spacing: 4) {
                            Text("\(progress.completedHazardReports.count)/\(HazardReportBank.allScenarios.count)")
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

            ForEach(HazardReportBank.allScenarios, id: \.id) { s in
                Button {
                    scenario = s
                    steps = HazardReportBank.steps(for: s)
                    currentStepIndex = 0
                    stepResults = [:]
                    selectedAnswers = [:]
                    rewardSummary = nil
                    earnedBadgeThisRun = false
                    transition(to: .reportReview)
                } label: {
                    scenarioRow(s)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func scenarioRow(_ s: HazardReportScenario) -> some View {
        let isCompleted = progress.completedHazardReports.contains(s.id)
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
                    HStack(spacing: 4) {
                        Text(s.hazardType)
                            .font(AppFont.mono(9))
                            .foregroundColor(AppTheme.danger.opacity(0.8))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(AppTheme.danger.opacity(0.1)))
                    }
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
        let total = HazardReportBank.allScenarios.count
        guard total > 0 else { return 0 }
        return Double(progress.completedHazardReports.count) / Double(total)
    }

    // MARK: - Report Review (DAF Form 457)

    private var reportReviewView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.stack) {
            GlassCard(glow: AppTheme.danger.opacity(0.3)) {
                VStack(alignment: .leading, spacing: AppSpacing.stack) {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppTheme.danger)
                        Text("DAF FORM 457 \u{2014} HAZARD REPORT")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.danger)
                            .tracking(1)
                    }

                    formField(label: "REPORTED BY", value: "\(scenario.reporterName), \(scenario.reporterOrg)")
                    formField(label: "DATE", value: scenario.dateReported)
                    formField(label: "LOCATION", value: scenario.location)

                    HStack(spacing: 8) {
                        Text("HAZARD TYPE")
                            .font(AppFont.mono(10))
                            .foregroundColor(AppTheme.muted)
                        TagPill(text: scenario.hazardType)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("DESCRIPTION OF HAZARD")
                            .font(AppFont.mono(10))
                            .foregroundColor(AppTheme.muted)
                            .tracking(0.5)
                        Text(scenario.hazardDescription)
                            .font(AppFont.body(14))
                            .foregroundColor(AppTheme.text)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("ADDITIONAL DETAILS")
                            .font(AppFont.mono(10))
                            .foregroundColor(AppTheme.muted)
                            .tracking(0.5)
                        Text(scenario.additionalDetails)
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.text.opacity(0.85))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            GlassCard {
                VStack(alignment: .leading, spacing: 6) {
                    Text("You will process this report through 6 decision steps per DAFMAN 91-203.")
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.muted)
                    Text("Each step is scored independently. Read the report carefully before proceeding.")
                        .font(AppFont.body(12))
                        .foregroundColor(AppTheme.muted)
                }
            }

            Button {
                transition(to: .step)
            } label: {
                HStack {
                    Text("Begin Processing")
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    private func formField(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(AppFont.mono(10))
                .foregroundColor(AppTheme.muted)
                .tracking(0.5)
            Text(value)
                .font(AppFont.body(14))
                .foregroundColor(AppTheme.text)
        }
    }

    // MARK: - Step View

    private var currentStep: HazardProcessingStep {
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

            if currentStep.id == "rac" {
                racMatrixView
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

    // MARK: - RAC Matrix

    private var racMatrixView: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("RAC MATRIX REFERENCE")
                    .font(AppFont.mono(10))
                    .foregroundColor(AppTheme.muted)
                    .tracking(1)

                let severities = HazardSeverity.allCases
                let probabilities = HazardProbability.allCases

                // Header row
                HStack(spacing: 0) {
                    Text("")
                        .frame(width: 32)
                    ForEach(probabilities) { prob in
                        Text(prob.short)
                            .font(AppFont.mono(10))
                            .foregroundColor(AppTheme.muted)
                            .frame(maxWidth: .infinity)
                    }
                }

                ForEach(severities) { sev in
                    HStack(spacing: 0) {
                        Text(sev.short)
                            .font(AppFont.mono(10))
                            .foregroundColor(AppTheme.muted)
                            .frame(width: 32, alignment: .leading)

                        ForEach(probabilities) { prob in
                            let rac = HazardReportBank.racMatrix[sev.row][prob.col]
                            let isHighlight = sev == scenario.correctSeverity && prob == scenario.correctProbability
                                && stepResults["severity"] != nil && stepResults["probability"] != nil
                            Text("\(rac)")
                                .font(AppFont.mono(12))
                                .foregroundColor(isHighlight ? AppTheme.bg : HazardReportBank.racColor(rac))
                                .frame(maxWidth: .infinity)
                                .frame(height: 28)
                                .background(
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .fill(isHighlight ? HazardReportBank.racColor(rac) : HazardReportBank.racColor(rac).opacity(0.1))
                                )
                        }
                    }
                }
            }
        }
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
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Correct answer:")
                                .font(AppFont.mono(10))
                                .foregroundColor(AppTheme.muted)
                            Text(step.options[step.correctIndex])
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.primary)
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
                        Text("PROCESSING DEBRIEF")
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
                        Image(systemName: "wrench.and.screwdriver")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppTheme.info)
                        Text("RECOMMENDED CORRECTIVE ACTION")
                            .font(AppFont.mono(10))
                            .foregroundColor(AppTheme.info)
                            .tracking(1)
                    }
                    Text(scenario.correctiveAction)
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
                        Text("REPORT PROCESSED")
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
                            Text("Hazard Analyst \u{2014} All reports processed")
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
                    Text("Choose Another Report")
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
            return "Outstanding processing. You demonstrated strong hazard analysis skills."
        } else if scorePercent >= 70 {
            return "Solid effort. Review the missed steps to sharpen your workflow."
        } else if scorePercent >= 50 {
            return "Needs improvement. Several processing steps were incorrect."
        } else {
            return "Review DAFMAN 91-203 hazard report procedures and try again."
        }
    }

    private func submitScore() {
        let hadBadgeBefore = progress.allHazardReportsCompleted
        rewardSummary = progress.completePractice(score: correctCount, total: steps.count)
        progress.markHazardReportCompleted(scenario.id)
        earnedBadgeThisRun = !hadBadgeBefore && progress.allHazardReportsCompleted
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
