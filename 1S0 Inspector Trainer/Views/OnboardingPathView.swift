import SwiftUI

struct OnboardingPathView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var rewardSummary: RewardSummary?
    @State private var showRestartAlert = false

    private var days: [OnboardingDay] { PracticeContent.onboardingDays(for: progress.selectedRole) }
    private var completedCount: Int { progress.onboardingCheckIns.count }
    private var totalDays: Int { days.count }
    private var progressValue: Double {
        guard totalDays > 0 else { return 0 }
        return Double(completedCount) / Double(totalDays)
    }
    private var currentDayNumber: Int? { progress.onboardingDayNumber() }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text("STARTER PROGRAM")
                        .font(AppFont.title(26))
                        .foregroundColor(AppTheme.text)

                    if progress.onboardingStartDate == nil {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("7-Day Starter Path")
                                    .font(AppFont.subtitle(18))
                                    .foregroundColor(AppTheme.text)
                                Text("Complete one short check-in each day to build momentum.")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)
                                Button("Start Program") {
                                    progress.startOnboardingIfNeeded()
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            }
                        }
                    } else {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("PROGRESS")
                                    .font(AppFont.mono(11))
                                    .foregroundColor(AppTheme.muted)

                                ProgressView(value: progressValue)
                                    .tint(AppTheme.primary)

                                Text("\(completedCount)/\(totalDays) check-ins")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)

                                if let dayNumber = currentDayNumber {
                                    Text("Day \(dayNumber) of \(totalDays)")
                                        .font(AppFont.subtitle(15))
                                        .foregroundColor(AppTheme.info)
                                }

                                if canCheckIn, let dayNumber = currentDayNumber {
                                    Button("Check in for Day \(dayNumber)") {
                                        rewardSummary = progress.checkInOnboardingDay()
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                } else {
                                    Text("Check-in complete for today.")
                                        .font(AppFont.body(12))
                                        .foregroundColor(AppTheme.muted)
                                }
                            }
                        }
                    }

                    if let rewardSummary {
                        RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                    }

                    ForEach(days) { day in
                        let isComplete = progress.isOnboardingDayComplete(day.id)
                        let isCurrent = day.id == currentDayNumber
                        GlassCard {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Day \(day.id)")
                                        .font(AppFont.mono(12))
                                        .foregroundColor(AppTheme.info)
                                    if isComplete {
                                        Text("Complete")
                                            .font(AppFont.mono(11))
                                            .foregroundColor(AppTheme.primary)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Capsule().fill(AppTheme.primary.opacity(0.15)))
                                    } else if isCurrent {
                                        Text("Today")
                                            .font(AppFont.mono(11))
                                            .foregroundColor(AppTheme.accent)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Capsule().fill(AppTheme.accent.opacity(0.2)))
                                    }
                                    Spacer()
                                }

                                Text(day.title)
                                    .font(AppFont.subtitle(17))
                                    .foregroundColor(AppTheme.text)

                                Text(day.summary)
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)

                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(day.tasks, id: \.self) { task in
                                        Text("• \(task)")
                                            .font(AppFont.body(12))
                                            .foregroundColor(AppTheme.muted)
                                    }
                                }

                                if let action = day.action {
                                    NavigationLink {
                                        destination(for: action)
                                    } label: {
                                        HStack {
                                            Text(actionLabel(for: action))
                                            Spacer()
                                            Image(systemName: "arrow.right.circle.fill")
                                        }
                                    }
                                    .buttonStyle(OutlineButtonStyle())
                                }
                            }
                        }
                    }

                    if progress.onboardingStartDate != nil {
                        Button("Restart Program") {
                            showRestartAlert = true
                        }
                        .buttonStyle(OutlineButtonStyle())
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Starter Program")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            progress.refreshForNewDayIfNeeded()
        }
        .alert("Restart Starter Program?", isPresented: $showRestartAlert) {
            Button("Restart", role: .destructive) {
                rewardSummary = nil
                progress.restartOnboarding()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This clears your current 7-day progress and starts over today.")
        }
    }

    private var canCheckIn: Bool {
        guard let dayNumber = currentDayNumber else { return false }
        return !progress.isOnboardingDayComplete(dayNumber)
    }

    @ViewBuilder
    private func destination(for action: OnboardingAction) -> some View {
        switch action {
        case .module(let id):
            if let module = TrainingContent.modules(for: progress.selectedRole).first(where: { $0.id == id }) {
                ModuleFlowView(module: module)
            } else {
                Text("Module unavailable")
            }
        case .dailyFive:
            PracticeSessionView()
        }
    }

    private func actionLabel(for action: OnboardingAction) -> String {
        switch action {
        case .module:
            return "Open Module"
        case .dailyFive:
            return "Run Adaptive Mission"
        }
    }
}
