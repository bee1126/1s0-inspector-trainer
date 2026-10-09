import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var progress: ProgressStore
    private var modules: [TrainingModule] { TrainingContent.modules(for: progress.selectedRole) }

    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.section) {
                    ScreenHeading(eyebrow: "YOUR DAILY TRAINING", title: "Build your judgment.", detail: "One focused session at a time.")
                    GlassCard {
                        HStack(spacing: 20) {
                            ZStack {
                                Circle().stroke(AppTheme.border, lineWidth: 5)
                                Circle().trim(from: 0, to: progress.dailyGoalProgress)
                                    .stroke(AppTheme.primary, style: StrokeStyle(lineWidth: 5, lineCap: .round)).rotationEffect(.degrees(-90))
                                Image(systemName: progress.dailyGoalProgress >= 1 ? "checkmark" : "bolt.fill")
                                    .foregroundStyle(AppTheme.accent).font(.system(size: 24, weight: .semibold))
                            }.frame(width: 60, height: 60).accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(progress.dailyXp) / \(progress.dailyGoal) XP today").font(AppFont.subtitle(18))
                                Text("Level \(progress.level) · \(progress.dailyStreak) day streak")
                                    .font(AppFont.body(16)).foregroundStyle(AppTheme.text.opacity(0.68))
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Up next").font(AppFont.subtitle(21))
                        recommendation
                    }
                    NavigationLink { PracticeSessionView() } label: {
                        ActionCard(title: "Daily Five", detail: progress.playedDailyFiveToday ? "Completed today. Practice again anytime." : "Five questions selected for your review needs.", icon: "sparkles", badge: progress.playedDailyFiveToday ? "DONE" : "5 QUESTIONS")
                    }.buttonStyle(.plain)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's lesson").font(AppFont.subtitle(21))
                        DailyLessonCard(lesson: DailyLessonBank.lessonForToday())
                    }
                    if progress.onboardingCheckIns.count < PracticeContent.onboardingDays(for: progress.selectedRole).count {
                        NavigationLink { OnboardingPathView() } label: {
                            ActionCard(title: "Your starter path", detail: "\(progress.onboardingCheckIns.count) of 7 check-ins complete", icon: "point.topleft.down.to.point.bottomright.curvepath")
                        }.buttonStyle(.plain)
                    }
                    Text("Independent training aid. Verify current publications and local procedures.")
                        .font(AppFont.body(14)).foregroundStyle(AppTheme.text.opacity(0.68))
                }
                .tacticalReadableWidth().padding(AppSpacing.screenPadding)
            }.scrollIndicators(.hidden)
        }
        .foregroundStyle(AppTheme.text)
        .navigationTitle("Today").navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarTrailing) { NavigationLink { ToolsView() } label: { Image(systemName: "person.crop.circle").accessibilityLabel("Profile and feedback") } } }
        .onAppear { progress.refreshForNewDayIfNeeded() }
    }

    @ViewBuilder private var recommendation: some View {
        if let session = progress.activeStudySession,
           progress.resumeState == nil || session.updatedAt >= progress.resumeState!.updatedAt {
            NavigationLink { StudySessionView() } label: {
                ActionCard(title: "Continue your \(session.configuration.mode.rawValue.lowercased()) session", detail: "\(session.answers.count) of \(session.questions.count) answered", icon: "play.fill", prominent: true)
            }.buttonStyle(.plain)
        } else if let resume = progress.resumeState, let module = modules.first(where: { $0.id == resume.moduleId }) {
            NavigationLink { ModuleFlowView(module: module) } label: {
                ActionCard(title: "Continue \(module.title)", detail: "Pick up where you left off.", icon: "play.fill", prominent: true)
            }.buttonStyle(.plain)
        } else if progress.overdueCount() > 0 {
            NavigationLink { StudyBuilderView(initialPool: .due) } label: {
                ActionCard(title: "Refresh what you've learned", detail: "\(progress.overdueCount()) questions ready for review", icon: "arrow.clockwise", prominent: true)
            }.buttonStyle(.plain)
        } else if let weak = modules.filter({ progress.moduleProficiency[ModuleHelper.modulePrefix(for: $0.quiz.first?.id ?? $0.id)]?.needsWork == true }).sorted(by: {
            (progress.moduleProficiency[ModuleHelper.modulePrefix(for: $0.quiz.first?.id ?? $0.id)]?.recentAccuracy ?? 1) < (progress.moduleProficiency[ModuleHelper.modulePrefix(for: $1.quiz.first?.id ?? $1.id)]?.recentAccuracy ?? 1)
        }).first {
            NavigationLink { StudyBuilderView(moduleID: weak.id) } label: {
                ActionCard(title: "Strengthen \(weak.title)", detail: "Focus on a topic that needs more practice.", icon: "scope", prominent: true)
            }.buttonStyle(.plain)
        } else if let next = modules.first(where: { !progress.isCompleted($0.id) && $0.isIntegrityValid }) {
            NavigationLink { ModuleDetailView(module: next) } label: {
                ActionCard(title: next.title, detail: "Your next module · \(next.estimatedMinutes) min", icon: "book.closed.fill", prominent: true)
            }.buttonStyle(.plain)
        } else {
            NavigationLink { StudyBuilderView() } label: {
                ActionCard(title: "Keep your skills sharp", detail: "Build a mixed-topic practice session.", icon: "scope", prominent: true)
            }.buttonStyle(.plain)
        }
    }
}
