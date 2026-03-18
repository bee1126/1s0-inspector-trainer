import SwiftUI

struct PracticeSessionView: View {
    @EnvironmentObject private var progress: ProgressStore

    @State private var runID = UUID()
    @State private var missionPlan = AdaptiveMissionPlan(items: [])
    @State private var latestResult: AssessmentResult? = nil
    @State private var latestReward: RewardSummary? = nil
    @State private var latestStreak = QuizStreakSummary(maxStreak: 0, multiplier: 1.0)
    @State private var sessionComplete = false

    private var allQuestions: [QuizQuestion] {
        TrainingContent.allQuizQuestions(for: progress.selectedRole)
    }

    private var playedToday: Bool {
        guard let lastRun = progress.lastDailyFiveDate else { return false }
        return Calendar.current.isDateInToday(lastRun)
    }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    GlassCard(glow: AppTheme.accent.opacity(0.35)) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ADAPTIVE REMEDIATION")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.accent)

                            Text("Five targeted questions built from your misses, review queue, and weakest modules.")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.text)

                            Text("Run it once a day to tighten weak spots, keep your Daily Five streak alive, and collect a clean-sweep bonus for going 5-for-5.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.muted)

                            HStack(spacing: 10) {
                                ForEach(reasonPills, id: \.self) { label in
                                    TagPill(text: label)
                                }
                                TagPill(text: "\(progress.dailyFiveStreak)d streak")
                                TagPill(text: "Best \(progress.bestDailyFiveScore)%")
                                if let lastRun = progress.lastDailyFiveDate {
                                    TagPill(text: shortDate(lastRun))
                                }
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("STATUS")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)

                            Text(playedToday ? "Today's adaptive mission is already logged." : "No adaptive mission recorded yet today.")
                                .font(AppFont.subtitle(16))
                                .foregroundColor(AppTheme.text)

                            Text(playedToday
                                ? "Replays update your last and best score, but the streak only advances once per day."
                                : "Finish a run to update your Daily Five streak, earn practice XP, and secure the clean-sweep bonus if you go perfect.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.muted)
                        }
                    }

                    if let latestResult {
                        GlassCard(glow: AppTheme.primary.opacity(0.35)) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("LATEST RUN")
                                    .font(AppFont.mono(11))
                                    .foregroundColor(AppTheme.primary)

                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(latestResult.score)/\(latestResult.total) correct")
                                            .font(AppFont.title(24))
                                            .foregroundColor(AppTheme.text)
                                        Text("Max streak \(latestStreak.maxStreak)")
                                            .font(AppFont.body(13))
                                            .foregroundColor(AppTheme.muted)
                                        if latestResult.score == latestResult.total && latestResult.total > 0 {
                                            Text("Clean sweep bonus secured")
                                                .font(AppFont.mono(11))
                                                .foregroundColor(AppTheme.primary)
                                        }
                                    }
                                    Spacer()
                                    ScoreBadge(score: percentage(for: latestResult))
                                }

                                if let latestReward {
                                    RewardSummaryCard(summary: latestReward, xpToNextLevel: progress.xpToNextLevel)
                                }

                                Button("Run Mission Again") {
                                    startNewRun()
                                }
                                .buttonStyle(OutlineButtonStyle())
                            }
                        }
                    }

                    if allQuestions.isEmpty || missionPlan.questions.isEmpty {
                        GlassCard(glow: AppTheme.danger.opacity(0.35)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Adaptive Mission Unavailable")
                                    .font(AppFont.subtitle(18))
                                    .foregroundColor(AppTheme.text)
                                Text("No quiz questions are available to build today's targeted drill.")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)
                            }
                        }
                    } else if !sessionComplete {
                        QuizFlowView(
                            questions: missionPlan.questions,
                            onComplete: { result, streak in
                                latestResult = result
                                latestStreak = streak
                                latestReward = progress.completeAdaptiveRemediation(
                                    score: result.score,
                                    total: result.total,
                                    streakMultiplier: streak.multiplier
                                )
                                sessionComplete = true
                            },
                            shuffleQuestions: false,
                            maxQuestions: nil,
                            title: "Adaptive Mission",
                            emptyStateText: "No questions are available for today's mission.",
                            statusLabelText: "● TARGETED",
                            statusLabelColor: AppTheme.accent,
                            useAdaptiveDifficulty: false
                        )
                        .id(runID)
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Adaptive Mission")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            progress.refreshForNewDayIfNeeded()
            if missionPlan.questions.isEmpty {
                startNewRun()
            }
        }
    }

    private func startNewRun() {
        missionPlan = progress.adaptiveRemediationPlan(from: allQuestions, questionCount: 5)
        latestResult = nil
        latestReward = nil
        latestStreak = QuizStreakSummary(maxStreak: 0, multiplier: 1.0)
        sessionComplete = false
        runID = UUID()
    }

    private func percentage(for result: AssessmentResult) -> Int {
        guard result.total > 0 else { return 0 }
        return Int(round(Double(result.score) / Double(result.total) * 100))
    }

    private func shortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    private var reasonPills: [String] {
        AdaptiveMissionReason.allCases.compactMap { reason in
            let count = missionPlan.count(for: reason)
            guard count > 0 else { return nil }
            return "\(count) \(reason.label)"
        }
    }
}
