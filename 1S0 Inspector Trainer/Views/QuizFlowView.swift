import Foundation
import SwiftUI

struct QuizFlowView: View {
    @EnvironmentObject private var progress: ProgressStore
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
    @State private var selectedDifficulty: QuizDifficulty = .hard
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
        let question = filtered[index]

        ScrollView {
            GlassCard {
                VStack(alignment: .leading, spacing: AppSpacing.stack) {
                    HStack {
                        Text("Quick Check")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.muted)
                        Spacer()
                        if showsHearts {
                            HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, compact: true, onDark: false)
                        }
                        Text("\(index + 1)/\(filtered.count)")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.muted)
                    }

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

                    VStack(spacing: 10) {
                        ForEach(question.choices, id: \.id) { choice in
                            Button {
                                guard selectedChoiceId == nil else { return }
                                selectedChoiceId = choice.id
                                if choice.isCorrect {
                                    correctCount += 1
                                    registerCorrectAnswer()
                                    AppFeedback.correct()
                                } else {
                                    onWrongAnswer?()
                                    registerIncorrectAnswer()
                                    AppFeedback.incorrect()
                                }
                                updateState()
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showFeedback = true
                                }
                            } label: {
                                OptionRow(
                                    text: choice.text,
                                    isSelected: selectedChoiceId == choice.id,
                                    isCorrect: choice.isCorrect,
                                    isLocked: selectedChoiceId != nil,
                                    revealCorrect: true
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
                        Button(index == filtered.count - 1 ? "Finish Quiz" : "Next Question") {
                            advance()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
            }
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

    private func advance() {
        let list = preparedQuestions.isEmpty ? filteredQuestions : preparedQuestions
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
        let filtered = questions.filter { question in
            question.difficulty == selectedDifficulty
        }
        return filtered.isEmpty ? questions : filtered
    }

    private func prepareQuestions() {
        resetStreak()
        if let resumeState {
            let questionMap = Dictionary(uniqueKeysWithValues: questions.map { ($0.id, $0) })
            let ordered = resumeState.questionIds.compactMap { questionMap[$0] }
            if !ordered.isEmpty {
                preparedQuestions = randomizedQuestions(from: ordered)
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
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            showStreakPopup = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showStreakPopup = false
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
}
