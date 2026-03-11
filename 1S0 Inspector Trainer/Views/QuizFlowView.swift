import Foundation
import SwiftUI

struct QuizFlowView: View {
    @EnvironmentObject private var progress: ProgressStore
    @EnvironmentObject private var adaptiveManager: AdaptiveDifficultyManager
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let questions: [QuizQuestion]
    var onWrongAnswer: (() -> Void)? = nil
    let onComplete: (AssessmentResult, QuizStreakSummary) -> Void
    var showsHearts: Bool = true
    var shuffleQuestions: Bool = false
    var maxQuestions: Int? = nil
    var resumeState: QuizResumeState? = nil
    var onStateUpdate: ((QuizResumeState) -> Void)? = nil

    @State private var index = 0
    @State private var selectedChoiceId: String? = nil
    @State private var correctCount = 0
    @State private var showFeedback = false
    @State private var preparedQuestions: [QuizQuestion] = []
    @State private var streakCount = 0
    @State private var bestStreakCount = 0
    @State private var streakTier = 0
    @State private var bestStreakTier = 0
    @State private var streakPopupText: String? = nil
    @State private var showStreakPopup = false
    private let swipeThreshold: CGFloat = 70

    var body: some View {
        let filtered = preparedQuestions.isEmpty ? filteredQuestions : preparedQuestions

        ScrollView {
            GlassCard {
                if filtered.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.stack) {
                        Text("Quick Check")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.muted)
                        Text("No medium or hard questions are available.")
                            .font(AppFont.subtitle(18))
                            .foregroundColor(AppTheme.text)
                    }
                } else {
                    let safeIndex = min(index, filtered.count - 1)
                    let question = filtered[safeIndex]

                    VStack(alignment: .leading, spacing: AppSpacing.stack) {
                        HStack {
                            Text("Quick Check")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.muted)
                            Spacer()
                            if showsHearts {
                                HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, compact: true, onDark: false)
                            }
                            Text("\(safeIndex + 1)/\(filtered.count)")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.muted)
                            Text(adaptiveLabelText)
                                .font(AppFont.mono(11))
                                .foregroundColor(adaptiveLabelColor)
                        }

                        ProgressView(value: Double(safeIndex + 1), total: Double(filtered.count))
                            .tint(AppTheme.info)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(AccessibilityCopy.progressLabel(name: "Quiz", current: safeIndex + 1, total: filtered.count))
                            .accessibilityValue(AccessibilityCopy.progressValue(current: safeIndex + 1, total: filtered.count))

                        if let imageName = question.imageName {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }

                        Text(question.prompt)
                            .font(AppFont.subtitle(18))
                            .foregroundColor(AppTheme.text)

                        Text("Select the best answer.")
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.muted)

                        VStack(spacing: 10) {
                            ForEach(question.choices, id: \.id) { choice in
                                Button {
                                    guard selectedChoiceId == nil else { return }
                                    selectedChoiceId = choice.id
                                    let isCorrect = choice.isCorrect
                                    if isCorrect {
                                        correctCount += 1
                                        registerCorrectAnswer()
                                        adaptiveManager.recordCorrect()
                                        AppFeedback.correct()
                                    } else {
                                        onWrongAnswer?()
                                        registerIncorrectAnswer()
                                        adaptiveManager.recordWrong()
                                        AppFeedback.incorrect()
                                    }
                                    progress.updateSRCard(questionId: question.id, quality: isCorrect ? 4 : 1)
                                    progress.recordModuleAnswer(moduleId: modulePrefix(for: question.id), correct: isCorrect)
                                    updateState()
                                    revealFeedback()
                                } label: {
                                    OptionRow(
                                        text: choice.text,
                                        isSelected: selectedChoiceId == choice.id,
                                        isCorrect: choice.isCorrect,
                                        isLocked: selectedChoiceId != nil,
                                        revealCorrect: true,
                                        accessibilityValue: choiceAccessibilityValue(choice)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        if let selectedId = selectedChoiceId,
                           let selected = question.choices.first(where: { $0.id == selectedId }) {
                            FeedbackView(
                                text: selected.isCorrect ? "Correct." : "Not quite. Review the lesson and try again.",
                                isCorrect: selected.isCorrect
                            )
                        }

                        if showFeedback {
                            Button(safeIndex == filtered.count - 1 ? "Finish Quiz" : "Next Question") {
                                advance()
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                    }
                }
            }
            .tacticalReadableWidth()
            .padding(.horizontal, AppSpacing.screenPadding)
            .overlay(alignment: .top) {
                if showStreakPopup, let streakPopupText {
                    StreakPopupView(text: streakPopupText)
                        .padding(.top, -8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .scrollIndicators(.hidden)
        .simultaneousGesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    handleSwipe(value)
                }
        )
        .onAppear {
            prepareQuestions()
        }
    }

    private func revealFeedback() {
        if reduceMotion {
            showFeedback = true
        } else {
            withAnimation(.easeInOut(duration: 0.2)) {
                showFeedback = true
            }
        }
    }

    private func choiceAccessibilityValue(_ choice: QuizChoice) -> String {
        guard selectedChoiceId != nil else { return "Not selected" }
        if selectedChoiceId == choice.id {
            return choice.isCorrect ? "Selected, correct" : "Selected, incorrect"
        }
        return choice.isCorrect ? "Correct answer" : "Not selected"
    }

    private func advance() {
        let list = preparedQuestions.isEmpty ? filteredQuestions : preparedQuestions
        guard !list.isEmpty else { return }
        if index == list.count - 1 {
            let summary = QuizStreakSummary(
                maxStreak: bestStreakCount,
                multiplier: 1.0 + Double(bestStreakTier) * 0.1
            )
            onComplete(AssessmentResult(score: correctCount, total: list.count), summary)
        } else {
            index += 1
            selectedChoiceId = nil
            showFeedback = false
            updateState()
        }
    }

    private var filteredQuestions: [QuizQuestion] {
        let medium = questions.filter { $0.difficulty == .medium }
        let hard = questions.filter { $0.difficulty == .hard }

        switch adaptiveManager.currentDifficulty {
        case .hard:
            if !hard.isEmpty {
                return hard
            }
            if !medium.isEmpty {
                return medium
            }
        case .medium:
            if !medium.isEmpty {
                return medium
            }
            if !hard.isEmpty {
                return hard
            }
        case .easy, .all:
            break
        }
        return []
    }

    private var adaptiveLabelText: String {
        adaptiveManager.currentDifficulty == .hard ? "● HARD" : "● STANDARD"
    }

    private var adaptiveLabelColor: Color {
        adaptiveManager.currentDifficulty == .hard ? AppTheme.accent : AppTheme.muted
    }

    private func prepareQuestions() {
        resetStreak()
        if let resumeState {
            let questionMap = Dictionary(uniqueKeysWithValues: questions.map { ($0.id, $0) })
            let ordered = resumeState.questionIds.compactMap { questionMap[$0] }
            if !ordered.isEmpty {
                preparedQuestions = ordered.map { question in
                    questionWithChoiceOrder(question, choiceOrder: resumeState.choiceOrder[question.id])
                }
                index = min(resumeState.index, max(0, preparedQuestions.count - 1))
                correctCount = resumeState.correctCount
                updateState()
                return
            }
        }

        var list = filteredQuestions
        if shuffleQuestions {
            list.shuffle()
        }
        if let maxQuestions {
            list = Array(list.prefix(maxQuestions))
        }
        preparedQuestions = randomizedQuestions(from: list)
        updateState()
    }

    private func questionWithChoiceOrder(_ question: QuizQuestion, choiceOrder: [String]?) -> QuizQuestion {
        guard let choiceOrder, !choiceOrder.isEmpty else { return question }
        let choiceMap = Dictionary(uniqueKeysWithValues: question.choices.map { ($0.id, $0) })
        var ordered = choiceOrder.compactMap { choiceMap[$0] }
        if ordered.count != question.choices.count {
            let orderedIds = Set(ordered.map(\.id))
            let remaining = question.choices.filter { !orderedIds.contains($0.id) }
            ordered.append(contentsOf: remaining)
        }
        return QuizQuestion(
            id: question.id,
            prompt: question.prompt,
            difficulty: question.difficulty,
            imageName: question.imageName,
            choices: ordered
        )
    }

    private func shuffleChoices(for question: QuizQuestion) -> QuizQuestion {
        QuizQuestion(
            id: question.id,
            prompt: question.prompt,
            difficulty: question.difficulty,
            imageName: question.imageName,
            choices: question.choices.shuffled()
        )
    }

    private func allCorrectIndicesSame(in list: [QuizQuestion]) -> Bool {
        guard list.count >= 2 else { return false }
        var targetIndex: Int? = nil
        for question in list {
            guard let correctIndex = question.choices.firstIndex(where: { $0.isCorrect }) else {
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

    private func randomizedQuestions(from list: [QuizQuestion]) -> [QuizQuestion] {
        guard !list.isEmpty else { return [] }
        let maxAttempts = 6
        var attempts = 0
        var shuffled = list.map { shuffleChoices(for: $0) }
        while attempts < maxAttempts && allCorrectIndicesSame(in: shuffled) {
            shuffled = list.map { shuffleChoices(for: $0) }
            attempts += 1
        }
        return shuffled
    }

    private func registerCorrectAnswer() {
        streakCount += 1
        bestStreakCount = max(bestStreakCount, streakCount)
        let newTier = streakCount / 3
        if newTier > streakTier {
            streakTier = newTier
            bestStreakTier = max(bestStreakTier, newTier)
            showStreakPopup(for: newTier)
        } else {
            bestStreakTier = max(bestStreakTier, newTier)
        }
    }

    private func registerIncorrectAnswer() {
        streakCount = 0
        streakTier = 0
    }

    private func resetStreak() {
        streakCount = 0
        bestStreakCount = 0
        streakTier = 0
        bestStreakTier = 0
        showStreakPopup = false
        streakPopupText = nil
    }

    private func showStreakPopup(for tier: Int) {
        let multiplier = 1.0 + Double(tier) * 0.1
        streakPopupText = "Streak x\(String(format: "%.1f", multiplier))"
        if reduceMotion {
            showStreakPopup = true
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showStreakPopup = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if reduceMotion {
                showStreakPopup = false
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showStreakPopup = false
                }
            }
        }
    }

    private func handleSwipe(_ value: DragGesture.Value) {
        guard showFeedback else { return }
        let horizontal = value.translation.width
        guard abs(horizontal) > swipeThreshold else { return }
        if horizontal < 0 {
            advance()
        }
    }

    private func updateState() {
        let list = preparedQuestions.isEmpty ? filteredQuestions : preparedQuestions
        guard !list.isEmpty else { return }
        let questionIds = list.map { $0.id }
        var choiceOrder: [String: [String]] = [:]
        for question in list {
            choiceOrder[question.id] = question.choices.map { $0.id }
        }
        onStateUpdate?(
            QuizResumeState(
                questionIds: questionIds,
                choiceOrder: choiceOrder,
                index: index,
                correctCount: correctCount
            )
        )
    }

    private func modulePrefix(for questionId: String) -> String {
        let components = questionId.split(separator: "-")
        guard components.count > 1 else { return questionId }
        return components.dropLast().joined(separator: "-")
    }
}
