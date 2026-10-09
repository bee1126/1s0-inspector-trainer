import SwiftUI

struct ScreenHeading: View {
    let eyebrow: String
    let title: String
    let detail: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(eyebrow).font(AppFont.mono(11)).tracking(1.5).foregroundStyle(AppTheme.primary)
            Text(title).font(AppFont.title(30)).fixedSize(horizontal: false, vertical: true)
            Text(detail).font(AppFont.body(17)).foregroundStyle(AppTheme.text.opacity(0.68))
        }.foregroundStyle(AppTheme.text)
    }
}

struct ActionCard: View {
    let title: String
    let detail: String
    let icon: String
    var badge: String? = nil
    var prominent = false
    var body: some View {
        GlassCard {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: icon).font(.title3).foregroundStyle(AppTheme.primary).frame(width: 26).accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 8) {
                    Text(title).font(prominent ? .title3.weight(.semibold) : .headline).foregroundStyle(AppTheme.text)
                    Text(detail).font(.subheadline).foregroundStyle(.secondary)
                    if let badge { Text(badge).font(.caption).foregroundStyle(.secondary) }
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary).padding(.top, 4).accessibilityHidden(true)
            }
        }.accessibilityElement(children: .combine)
    }
}

struct LearnView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var query = ""
    @State private var filter = "All"
    private let filters = ["All", "To learn", "Completed"]
    private var modules: [TrainingModule] {
        progress.catalog.modules.filter { module in
            (query.isEmpty || "\(module.title) \(module.subtitle) \(module.tags.joined(separator: " "))".localizedCaseInsensitiveContains(query)) &&
            (filter == "All" || (filter == "Completed" ? progress.isCompleted(module.id) : !progress.isCompleted(module.id)))
        }
    }
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.section) {
                    ScreenHeading(eyebrow: "LEARN WITH PURPOSE", title: "Your training library", detail: "\(progress.catalog.modules.count) topics · \(progress.catalog.questions.count) questions")
                    NavigationLink { OnboardingPathView() } label: {
                        ActionCard(title: "7-day starter path", detail: "\(progress.onboardingCheckIns.count) check-ins complete", icon: "calendar")
                    }.buttonStyle(.plain)
                    Picker("Completion", selection: $filter) { ForEach(filters, id: \.self) { Text($0) } }.pickerStyle(.segmented)
                    if modules.isEmpty { ContentUnavailableView.search(text: query) }
                    LazyVStack(spacing: 12) {
                        ForEach(modules) { module in
                            NavigationLink { ModuleDetailView(module: module) } label: {
                                ActionCard(title: module.title, detail: "\(module.subtitle)\n\(module.estimatedMinutes) min · \(module.quiz.count) questions", icon: progress.isCompleted(module.id) ? "checkmark.seal.fill" : "book.closed", badge: progress.isCompleted(module.id) ? "COMPLETED" : nil)
                            }.buttonStyle(.plain).disabled(!module.isIntegrityValid)
                        }
                    }
                }.tacticalReadableWidth().padding(AppSpacing.screenPadding)
            }.scrollIndicators(.hidden)
        }.foregroundStyle(AppTheme.text).navigationTitle("Learn").navigationBarTitleDisplayMode(.inline).searchable(text: $query, prompt: "Find a topic")
    }
}

struct PracticeHubView: View {
    @EnvironmentObject private var progress: ProgressStore
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.section) {
                    ScreenHeading(eyebrow: "MAKE IT STICK", title: "Practice your way", detail: "Choose your focus. Learn from every answer.")
                    if progress.hasHiddenSession { HiddenSessionNotice() }
                    if !progress.hasHiddenSession, let session = progress.activeStudySession {
                        NavigationLink { StudySessionView() } label: {
                            ActionCard(title: "Resume \(session.configuration.mode.rawValue.lowercased())", detail: "\(session.answers.count) of \(session.questions.count) answered", icon: "play.fill", prominent: true)
                        }.buttonStyle(.plain)
                    }
                    NavigationLink { StudyBuilderView() } label: {
                        ActionCard(title: "Build a session", detail: "Choose topics, difficulty, and study or exam mode.", icon: "slider.horizontal.3", prominent: true)
                    }.buttonStyle(.plain)
                    VStack(spacing: 12) {
                        NavigationLink { PracticeSessionView() } label: { ActionCard(title: "Daily Five", detail: "Your daily adaptive review", icon: "sparkles") }.buttonStyle(.plain)
                        ForEach([QuestionPool.missed, .due], id: \.self) { pool in
                            NavigationLink { StudyBuilderView(initialPool: pool) } label: {
                                ActionCard(title: pool.rawValue, detail: "Available questions: \(count(pool))", icon: pool == .due ? "clock.arrow.circlepath" : "arrow.triangle.2.circlepath")
                            }.buttonStyle(.plain)
                        }
                        NavigationLink { SavedQuestionsView() } label: {
                            ActionCard(title: "Saved questions", detail: "Questions in your collection: \(count(.saved))", icon: "bookmark")
                        }.buttonStyle(.plain)
                    }
                    Text("Field exercises").font(AppFont.subtitle(22))
                    NavigationLink { PPELoadoutView() } label: { ActionCard(title: "PPE decisions", detail: "Match protection to the actual exposure.", icon: "shield.lefthalf.filled") }.buttonStyle(.plain)
                    NavigationLink { LocalHazardReportsView() } label: { ActionCard(title: "Hazard Report & Risk Matrix", detail: "Record hazards, controls, and follow-up on this device.", icon: "doc.text") }.buttonStyle(.plain)
                    if progress.catalog.showsDAFTools {
                        NavigationLink { HazardReportView() } label: { ActionCard(title: "DAF Form 457 + RAC", detail: "Practice hazard reporting and risk assessment.", icon: "doc.text") }.buttonStyle(.plain)
                        NavigationLink { DeployedORMView() } label: { ActionCard(title: "Deployed ORM", detail: "Work through operational decisions.", icon: "globe") }.buttonStyle(.plain)
                    }
                    NavigationLink { CodeLookupView() } label: { ActionCard(title: "Code lookup", detail: "Connect hazards to the right reference.", icon: "text.book.closed") }.buttonStyle(.plain)
                }.tacticalReadableWidth().padding(AppSpacing.screenPadding)
            }.scrollIndicators(.hidden)
        }.foregroundStyle(AppTheme.text).navigationTitle("Practice").navigationBarTitleDisplayMode(.inline)
    }
    private func count(_ pool: QuestionPool) -> Int {
        progress.studyQuestions(for: StudyConfiguration(pool: pool), from: progress.catalog.questions).count
    }
}
