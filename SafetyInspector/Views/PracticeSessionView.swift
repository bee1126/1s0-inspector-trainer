import SwiftUI

struct PracticeSessionView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss

    @State private var result: AssessmentResult? = nil
    @State private var rewardSummary: RewardSummary? = nil
    @State private var sessionId = UUID()

    private var questionPool: [QuizQuestion] {
        TrainingContent.modules.flatMap { $0.quiz }
    }

    var body: some View {
        ZStack {
            BackgroundView()

            if let result {
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Practice Complete")
                            .font(AppFont.title(22))
                            .foregroundColor(AppTheme.charcoal)
                        Text("Score: \(result.score)/\(result.total)")
                            .font(AppFont.subtitle(16))
                            .foregroundColor(AppTheme.charcoal)

                        if let rewardSummary {
                            RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                        }

                        Button("Practice Again") {
                            resetSession()
                        }
                        .buttonStyle(PrimaryButtonStyle())

                        Button("Back to Home") {
                            dismiss()
                        }
                        .buttonStyle(OutlineButtonStyle())
                    }
                }
                .padding(AppSpacing.screenPadding)
            } else {
                QuizFlowView(
                    questions: questionPool,
                    onComplete: { result in
                        rewardSummary = progress.completePractice(score: result.score, total: result.total)
                        self.result = result
                    },
                    shuffleQuestions: true,
                    maxQuestions: 6
                )
                .id(sessionId)
            }
        }
        .navigationTitle("Practice")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            progress.refreshForNewDayIfNeeded()
        }
    }

    private func resetSession() {
        result = nil
        rewardSummary = nil
        sessionId = UUID()
    }
}
