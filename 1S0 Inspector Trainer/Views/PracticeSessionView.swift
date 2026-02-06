import SwiftUI

enum PracticeMode {
    case practice
    case dailyFive
}

struct PracticeSessionView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    let mode: PracticeMode

    @State private var result: AssessmentResult? = nil
    @State private var rewardSummary: RewardSummary? = nil
    @State private var sessionId = UUID()
    @State private var priorDailyScore: Int = 0

    private var questionPool: [QuizQuestion] {
        TrainingContent.allQuizQuestions(for: progress.selectedRole)
    }

    init(mode: PracticeMode = .practice) {
        self.mode = mode
    }

    var body: some View {
        ZStack {
            BackgroundView()

            if let result {
                ScrollView {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(mode == .dailyFive ? "Daily 5 Complete" : "Practice Complete")
                                .font(AppFont.title(22))
                                .foregroundColor(AppTheme.text)
                            Text("Score: \(result.score)/\(result.total)")
                                .font(AppFont.subtitle(16))
                                .foregroundColor(AppTheme.text)

                            if mode == .dailyFive {
                                Text("Daily 5 Streak: \(progress.dailyFiveStreak) days")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Challenges")
                                        .font(AppFont.subtitle(14))
                                        .foregroundColor(AppTheme.text)
                                    ChallengeRow(
                                        title: "Beat your last score",
                                        isComplete: priorDailyScore > 0 && progress.lastDailyFiveScore > priorDailyScore
                                    )
                                    ChallengeRow(
                                        title: "3-day streak",
                                        isComplete: progress.dailyFiveStreak >= 3
                                    )
                                    if progress.bestDailyFiveScore > 0 {
                                        Text("Best Daily 5: \(progress.bestDailyFiveScore)%")
                                            .font(AppFont.body(12))
                                            .foregroundColor(AppTheme.muted)
                                    }
                                }
                            }

                            if let rewardSummary {
                                RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                            }

                            Button(mode == .dailyFive ? "Run Another Daily 5" : "Practice Again") {
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
                }
                .scrollIndicators(.hidden)
            } else {
                QuizFlowView(
                    questions: questionPool,
                    onComplete: { result, streak in
                        rewardSummary = progress.completePractice(score: result.score, total: result.total, streakMultiplier: streak.multiplier)
                        if mode == .dailyFive {
                            priorDailyScore = progress.lastDailyFiveScore
                            progress.recordDailyFive(score: result.score, total: result.total)
                        }
                        self.result = result
                    },
                    shuffleQuestions: true,
                    maxQuestions: mode == .dailyFive ? 5 : 6
                )
                .id(sessionId)
            }
        }
        .navigationTitle(mode == .dailyFive ? "Daily 5" : "Practice")
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
