import SwiftUI

struct PracticeSessionView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var missionPlan = AdaptiveMissionPlan(items: [])
    @State private var runID = UUID()
    @State private var completed: StudyHistoryEntry?

    var body: some View {
        ZStack {
            BackgroundView()
            if let completed {
                StudyDebriefView(entry: completed)
                    .safeAreaInset(edge: .bottom) {
                        Button("Practice again") { start() }.buttonStyle(OutlineButtonStyle()).studyActionBar()
                    }
            } else if missionPlan.questions.isEmpty {
                ContentUnavailableView("Daily Five unavailable", systemImage: "book.closed", description: Text("No questions are available for this profile."))
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Five targeted questions from your misses, due reviews, and weaker topics.")
                        .font(AppFont.body(16)).foregroundStyle(AppTheme.text.opacity(0.68)).padding(.horizontal, AppSpacing.screenPadding)
                    QuizFlowView(questions: missionPlan.questions, onComplete: { _, _ in
                        completed = progress.studyHistory.first
                    }, shuffleQuestions: false, title: "Daily Five", useAdaptiveDifficulty: false, historyKind: .dailyFive)
                    .id(runID)
                }.padding(.top, 16)
            }
        }.navigationTitle("Daily Five").navigationBarTitleDisplayMode(.inline)
            .onAppear { if missionPlan.questions.isEmpty { start() } }
    }
    private func start() {
        progress.refreshForNewDayIfNeeded()
        missionPlan = progress.adaptiveRemediationPlan(from: progress.catalog.questions)
        runID = UUID()
        completed = nil
    }
}
