import SwiftUI

struct QuizFlowView: View {
    @EnvironmentObject private var progress: ProgressStore
    let questions: [QuizQuestion]
    var onWrongAnswer: (() -> Void)? = nil
    let onComplete: (AssessmentResult) -> Void
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
    private let swipeThreshold: CGFloat = 70

    var body: some View {
        let filtered = preparedQuestions.isEmpty ? filteredQuestions : preparedQuestions
        let question = filtered[index]

        GlassCard {
            VStack(alignment: .leading, spacing: AppSpacing.stack) {
                HStack {
                    Text("Quick Check")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
                    Spacer()
                    if showsHearts {
                        HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, compact: true, onDark: false)
                    }
                    Text("\(index + 1)/\(filtered.count)")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
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
                    .foregroundColor(AppTheme.charcoal)

                VStack(spacing: 10) {
                    ForEach(question.choices, id: \.id) { choice in
                        OptionRow(
                            text: choice.text,
                            isSelected: selectedChoiceId == choice.id,
                            isCorrect: choice.isCorrect,
                            isLocked: selectedChoiceId != nil,
                            revealCorrect: true
                        )
                        .onTapGesture {
                            guard selectedChoiceId == nil else { return }
                            selectedChoiceId = choice.id
                            if choice.isCorrect {
                                correctCount += 1
                            } else {
                                onWrongAnswer?()
                            }
                            updateState()
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showFeedback = true
                            }
                        }
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
        .gesture(
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
            onComplete(AssessmentResult(score: correctCount, total: list.count))
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
        if let resumeState {
            let questionMap = Dictionary(uniqueKeysWithValues: questions.map { ($0.id, $0) })
            let ordered = resumeState.questionIds.compactMap { questionMap[$0] }
            if !ordered.isEmpty {
                preparedQuestions = ordered.map { question in
                    let order = resumeState.choiceOrder[question.id]
                    let choicesById = Dictionary(uniqueKeysWithValues: question.choices.map { ($0.id, $0) })
                    let orderedChoices = order?.compactMap { choicesById[$0] } ?? question.choices
                    return QuizQuestion(
                        id: question.id,
                        prompt: question.prompt,
                        difficulty: question.difficulty,
                        imageName: question.imageName,
                        choices: orderedChoices
                    )
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
        list = list.map { question in
            QuizQuestion(
                id: question.id,
                prompt: question.prompt,
                difficulty: question.difficulty,
                imageName: question.imageName,
                choices: question.choices.shuffled()
            )
        }
        preparedQuestions = list
        updateState()
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
