import SwiftUI

struct QuizFlowView: View {
    let questions: [QuizQuestion]
    let onComplete: (Result) -> Void

    @State private var index = 0
    @State private var selectedChoiceId: String? = nil
    @State private var correctCount = 0
    @State private var showFeedback = false

    var body: some View {
        let question = questions[index]

        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Quick Check")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
                    Spacer()
                    Text("\(index + 1)/\(questions.count)")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
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
                    Button(index == questions.count - 1 ? "Finish Quiz" : "Next Question") {
                        advance()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
        .padding(.horizontal, 20)
    }

    private func advance() {
        if index == questions.count - 1 {
            onComplete(Result(score: correctCount, total: questions.count))
        } else {
            index += 1
            selectedChoiceId = nil
            showFeedback = false
        }
    }
}
