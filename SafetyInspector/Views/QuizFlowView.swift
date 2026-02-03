import SwiftUI

struct QuizFlowView: View {
    let questions: [QuizQuestion]
    let onComplete: (Result) -> Void
    var shuffleQuestions: Bool = false
    var maxQuestions: Int? = nil

    @State private var index = 0
    @State private var selectedChoiceId: String? = nil
    @State private var correctCount = 0
    @State private var showFeedback = false
    @State private var selectedDifficulty: QuizDifficulty = .all
    @State private var preparedQuestions: [QuizQuestion] = []

    var body: some View {
        let filtered = preparedQuestions.isEmpty ? filteredQuestions : preparedQuestions
        let question = filtered[index]

        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Quick Check")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
                    Spacer()
                    Text("\(index + 1)/\(filtered.count)")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
                }

                Picker("Difficulty", selection: $selectedDifficulty) {
                    ForEach(QuizDifficulty.allCases) { level in
                        Text(level.rawValue).tag(level)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedDifficulty) { _, _ in
                    resetProgress()
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
                            isLocked: selectedChoiceId != nil
                        )
                        .onTapGesture {
                            guard selectedChoiceId == nil else { return }
                            selectedChoiceId = choice.id
                            if choice.isCorrect {
                                correctCount += 1
                            }
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
        .padding(.horizontal, 20)
        .onAppear {
            prepareQuestions()
        }
    }

    private func advance() {
        let filtered = filteredQuestions
        if index == filtered.count - 1 {
            onComplete(Result(score: correctCount, total: filtered.count))
        } else {
            index += 1
            selectedChoiceId = nil
            showFeedback = false
        }
    }

    private var filteredQuestions: [QuizQuestion] {
        let filtered = questions.filter { question in
            switch selectedDifficulty {
            case .all:
                return true
            default:
                return question.difficulty == selectedDifficulty
            }
        }
        return filtered.isEmpty ? questions : filtered
    }

    private func resetProgress() {
        index = 0
        selectedChoiceId = nil
        correctCount = 0
        showFeedback = false
        prepareQuestions()
    }

    private func prepareQuestions() {
        var list = filteredQuestions
        if shuffleQuestions {
            list.shuffle()
        }
        if let maxQuestions {
            list = Array(list.prefix(maxQuestions))
        }
        preparedQuestions = list
    }
}
