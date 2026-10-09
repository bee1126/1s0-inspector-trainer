import SwiftUI

struct StudyBuilderView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var configuration: StudyConfiguration
    @State private var showSession = false
    @State private var showReplace = false

    init(initialPool: QuestionPool = .all, moduleID: String? = nil, questionIDs: Set<String>? = nil) {
        _configuration = State(initialValue: StudyConfiguration(pool: initialPool, moduleIDs: moduleID.map { [$0] } ?? [], questionIDs: questionIDs))
    }
    private var questions: [QuizQuestion] { TrainingContent.allQuizQuestions(for: progress.selectedRole) }
    private var matching: [QuizQuestion] { progress.studyQuestions(for: configuration, from: questions) }
    private var count: Int { configuration.questionCount == 0 ? matching.count : min(configuration.questionCount, matching.count) }
    private var difficulties: [QuizDifficulty] { [.all] + QuizDifficulty.allCases.filter { difficulty in difficulty != .all && questions.contains { $0.difficulty == difficulty } } }

    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.section) {
                    ScreenHeading(eyebrow: "YOUR SESSION", title: "Set your focus", detail: "Matching questions: \(matching.count)")
                    GlassCard {
                        VStack(alignment: .leading, spacing: 18) {
                            Picker("Mode", selection: $configuration.mode) { ForEach(StudyMode.allCases) { Text($0.rawValue).tag($0) } }.pickerStyle(.segmented)
                            Text(configuration.mode == .study ? "Learn after each answer. Answers lock when selected." : "Change answers freely. Results appear only after you submit all answers. No timer.")
                                .font(AppFont.body(16)).foregroundStyle(AppTheme.text.opacity(0.68))
                            Picker("Question pool", selection: $configuration.pool) { ForEach(QuestionPool.allCases) { Text($0.rawValue).tag($0) } }
                            Picker("Difficulty", selection: $configuration.difficulty) { ForEach(difficulties) { Text($0.rawValue).tag($0) } }
                            Picker("Session length", selection: $configuration.questionCount) {
                                ForEach([5, 10, 20, 0], id: \.self) { Text($0 == 0 ? "All matching" : "\($0) questions").tag($0) }
                            }
                        }.tint(AppTheme.primary)
                    }
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Topics").font(AppFont.subtitle(20))
                            Text(configuration.moduleIDs.isEmpty ? "All topics selected" : "\(configuration.moduleIDs.count) topics selected").font(AppFont.body(16))
                            Button("Use all topics") { configuration.moduleIDs = [] }.tint(AppTheme.primary)
                            ForEach(TrainingContent.modules(for: progress.selectedRole)) { module in
                                Toggle(module.title, isOn: Binding(get: { configuration.moduleIDs.contains(module.id) }, set: { selected in
                                    if selected { configuration.moduleIDs.insert(module.id) } else { configuration.moduleIDs.remove(module.id) }
                                })).font(AppFont.body(16)).tint(AppTheme.primary)
                            }
                        }
                    }
                    if matching.isEmpty {
                        ContentUnavailableView("No matching questions", systemImage: "line.3.horizontal.decrease.circle", description: Text("Try another pool, topic, or difficulty. No other questions will be substituted."))
                    }
                    if configuration.questionIDs != nil {
                        Text("This session is limited to the questions missed in that debrief.").font(AppFont.body(16))
                    }
                }.tacticalReadableWidth().padding(AppSpacing.screenPadding)
            }.scrollIndicators(.hidden)
        }
        .foregroundStyle(AppTheme.text).navigationTitle("Build a session").navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button("Start \(configuration.mode.rawValue.lowercased()) · \(count) \(count == 1 ? "question" : "questions")") {
                if progress.activeStudySession != nil { showReplace = true } else { start() }
            }.buttonStyle(PrimaryButtonStyle()).disabled(count == 0).studyActionBar()
        }
        .navigationDestination(isPresented: $showSession) { StudySessionView() }
        .confirmationDialog("An unfinished session is saved", isPresented: $showReplace, titleVisibility: .visible) {
            Button("Resume saved session") { showSession = true }
            Button("Discard it and start this session", role: .destructive) { progress.discardStudySession(); start() }
        } message: { Text("Your module progress is separate and will be preserved.") }
    }
    private func start() { showSession = progress.startStudySession(configuration: configuration, questions: questions) }
}

extension View {
    func studyActionBar() -> some View {
        self.tacticalReadableWidth().padding(.horizontal, AppSpacing.screenPadding).padding(.vertical, 12).background(AppTheme.bg)
    }
}

struct StudySessionView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @EnvironmentObject private var progress: ProgressStore
    @State private var completed: StudyHistoryEntry?
    @State private var confirmSubmit = false
    private var questions: [QuizQuestion] { TrainingContent.allQuizQuestions(for: progress.selectedRole) }

    var body: some View {
        ZStack {
            BackgroundView()
            if let completed {
                StudyDebriefView(entry: completed)
            } else if let session = progress.activeStudySession {
                if progress.studySessionIsValid(questions: questions) {
                    sessionContent(session)
                } else {
                    VStack(spacing: 20) {
                        ContentUnavailableView("Training content changed", systemImage: "arrow.clockwise", description: Text("This unfinished session uses questions that changed. Start a fresh session to use the updated material. Your previous progress is preserved."))
                        Button("Discard outdated session") { progress.discardStudySession() }.buttonStyle(OutlineButtonStyle())
                    }.padding(AppSpacing.screenPadding)
                }
            } else {
                VStack(spacing: 20) {
                    ContentUnavailableView("Ready for a fresh session", systemImage: "book.closed", description: Text("Choose topics and a mode to begin."))
                    NavigationLink("Build a session") { StudyBuilderView() }.buttonStyle(PrimaryButtonStyle())
                }.padding(AppSpacing.screenPadding)
            }
        }.foregroundStyle(AppTheme.text)
        .navigationTitle(completed == nil ? (progress.activeStudySession?.configuration.mode.rawValue ?? "Practice") : "Session complete")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Submit your exam?", isPresented: $confirmSubmit, titleVisibility: .visible) {
            Button("Submit and view results") { finish() }
        } message: { Text("Your answers will be final.") }
    }

    private func sessionContent(_ session: StudySession) -> some View {
        let index = min(max(0, session.index), session.questions.count - 1)
        let question = session.questions[index]
        let reveal = session.configuration.mode == .study && session.answers[question.id] != nil
        return ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                (dynamicTypeSize.isAccessibilitySize ? AnyLayout(VStackLayout(alignment: .leading, spacing: 8)) : AnyLayout(HStackLayout())) {
                    Text("Question \(index + 1) of \(session.questions.count)").font(AppFont.mono(13))
                    if !dynamicTypeSize.isAccessibilitySize { Spacer() }
                    Text("\(session.answers.count) answered").font(AppFont.mono(12))
                }
                ProgressView(value: Double(session.answers.count), total: Double(session.questions.count)).tint(AppTheme.primary)
                    .accessibilityLabel("Answered").accessibilityValue("\(session.answers.count) of \(session.questions.count)")
                StudyQuestionCard(question: question, selectedID: session.answers[question.id], reveal: reveal,
                                  locked: reveal, onSelect: { choice in progress.selectStudyAnswer(questionID: question.id, choiceID: choice) })
                if session.configuration.mode == .exam {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 48))]) {
                        ForEach(session.questions.indices, id: \.self) { position in
                            Button { progress.moveStudyQuestion(to: position) } label: {
                                Text("\(position + 1)").font(AppFont.mono(15)).frame(maxWidth: .infinity, minHeight: 48)
                                    .background(position == index ? AppTheme.primary.opacity(0.2) : AppTheme.surface, in: RoundedRectangle(cornerRadius: 12))
                                    .overlay(alignment: .bottom) { if session.answers[session.questions[position].id] != nil { Circle().fill(AppTheme.primary).frame(width: 5, height: 5).padding(4) } }
                            }.accessibilityLabel("Question \(position + 1)").accessibilityValue((position == index ? "Current question. " : "") + (session.answers[session.questions[position].id] == nil ? "Unanswered" : "Answered"))
                        }
                    }
                }
            }.tacticalReadableWidth().padding(AppSpacing.screenPadding)
        }
        .id(question.id)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                (dynamicTypeSize.isAccessibilitySize ? AnyLayout(VStackLayout(spacing: 8)) : AnyLayout(HStackLayout())) {
                    if index > 0 {
                        Button("Back") { progress.moveStudyQuestion(to: index - 1) }.buttonStyle(OutlineButtonStyle())
                    }
                    if index < session.questions.count - 1 {
                        Button("Next") { progress.moveStudyQuestion(to: index + 1) }.buttonStyle(PrimaryButtonStyle())
                            .disabled(session.configuration.mode == .study && session.answers[question.id] == nil)
                    } else {
                        Button(session.configuration.mode == .exam ? "Submit exam" : "Finish session") {
                            if session.configuration.mode == .exam { confirmSubmit = true } else { finish() }
                        }.buttonStyle(PrimaryButtonStyle()).disabled(!session.isComplete)
                    }
                }
                if session.configuration.mode == .exam && index == session.questions.count - 1 && !session.isComplete {
                    Text("Answer every question before submitting.").font(AppFont.body(14))
                }
            }.studyActionBar()
        }
    }
    private func finish() {
        guard let id = progress.activeStudySession?.id else { return }
        completed = progress.finishStudySession(id: id, questions: questions)
    }
}

struct BookmarkQuestionButton: View {
    @EnvironmentObject private var progress: ProgressStore
    let questionID: String
    var body: some View {
        Button { progress.toggleSavedQuestion(questionID) } label: {
            Image(systemName: progress.isQuestionSaved(questionID) ? "bookmark.fill" : "bookmark")
                .frame(minWidth: 44, minHeight: 44).foregroundStyle(AppTheme.primary)
        }.buttonStyle(.plain)
            .accessibilityLabel(progress.isQuestionSaved(questionID) ? "Remove saved question" : "Save question")
    }
}

struct QuestionExplanationView: View {
    let explanation: String
    let reference: QuestionReference?
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Why this answer").font(AppFont.subtitle(18))
            Text(explanation).font(AppFont.body(17)).fixedSize(horizontal: false, vertical: true)
            if let reference {
                Link(destination: reference.url) {
                    Label("\(reference.title) · \(reference.section)", systemImage: "arrow.up.right.square")
                        .font(AppFont.body(15)).multilineTextAlignment(.leading)
                }.tint(AppTheme.primary)
                Text("Verify current publications and local procedures. Source links require internet access.")
                    .font(AppFont.body(13)).foregroundStyle(AppTheme.text.opacity(0.68))
            }
        }.foregroundStyle(AppTheme.text)
    }
}

struct StudyQuestionCard: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let question: StudyQuestion
    let selectedID: String?
    var reveal: Bool
    var locked: Bool
    var onSelect: (String) -> Void
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 20) {
                if let imageName = question.imageName {
                    Image(imageName).resizable().scaledToFit().frame(maxHeight: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 14)).accessibilityHidden(true)
                }
                (dynamicTypeSize.isAccessibilitySize ? AnyLayout(VStackLayout(alignment: .leading, spacing: 12)) : AnyLayout(HStackLayout(alignment: .top))) {
                    Text(question.prompt).font(AppFont.subtitle(22)).fixedSize(horizontal: false, vertical: true)
                    BookmarkQuestionButton(questionID: question.id)
                }
                ForEach(question.choices) { choice in
                    Button { onSelect(choice.id) } label: {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: symbol(choice)).frame(width: 22)
                            Text(choice.text).font(AppFont.body(17)).frame(maxWidth: .infinity, alignment: .leading)
                        }.padding(16).frame(minHeight: 52)
                            .foregroundStyle(color(choice))
                            .background(color(choice).opacity(selectedID == choice.id ? 0.1 : 0.035), in: RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(color(choice).opacity(selectedID == choice.id ? 0.7 : 0.15)))
                    }.buttonStyle(.plain).disabled(locked)
                        .accessibilityValue(reveal ? (choice.isCorrect ? "Correct answer" : (selectedID == choice.id ? "Selected, incorrect" : "Incorrect")) : (selectedID == choice.id ? "Selected" : "Not selected"))
                }
                if reveal { QuestionExplanationView(explanation: question.explanation, reference: question.reference) }
            }
        }.foregroundStyle(AppTheme.text)
    }
    private func symbol(_ choice: QuizChoice) -> String {
        if reveal && choice.isCorrect { return "checkmark.circle.fill" }
        if reveal && selectedID == choice.id { return "xmark.circle.fill" }
        return selectedID == choice.id ? "largecircle.fill.circle" : "circle"
    }
    private func color(_ choice: QuizChoice) -> Color {
        if reveal && choice.isCorrect { return AppTheme.primary }
        if reveal && selectedID == choice.id { return AppTheme.danger }
        return selectedID == choice.id ? AppTheme.primary : AppTheme.text
    }
}

struct StudyDebriefView: View {
    let entry: StudyHistoryEntry
    private var moduleIDs: [String] { Set(entry.questions.map(\.moduleID)).sorted() }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.section) {
                ScreenHeading(eyebrow: entry.kind.rawValue.uppercased(), title: "\(entry.score) of \(entry.total) correct", detail: entry.completedAt.formatted(date: .abbreviated, time: .shortened))
                if entry.xpEarned > 0 { Text(entry.kind == .module ? "Module reward: +\(entry.xpEarned) XP" : "+\(entry.xpEarned) XP earned").font(AppFont.subtitle(20)).foregroundStyle(AppTheme.accent) }
                GlassCard {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("By topic · recorded answers").font(AppFont.subtitle(20))
                        ForEach(moduleIDs, id: \.self) { id in
                            let items = entry.questions.filter { $0.moduleID == id && entry.answers[$0.id] != nil }
                            HStack {
                                Text(TrainingContent.modules.first(where: { $0.id == id })?.title ?? id)
                                Spacer()
                                Text("\(items.filter { $0.isCorrect(entry.answers[$0.id]) }.count)/\(items.count)").font(AppFont.mono(15))
                            }.font(AppFont.body(16))
                        }
                    }
                }
                if !entry.missedIDs.isEmpty {
                    NavigationLink("Practice these misses") { StudyBuilderView(questionIDs: entry.missedIDs) }.buttonStyle(PrimaryButtonStyle())
                }
                Text("Answer review").font(AppFont.subtitle(22))
                ForEach(entry.questions) { question in
                    if entry.answers[question.id] == nil {
                        Text("Your selected answer wasn't recorded for this older resumed quiz.").font(AppFont.body(14))
                    }
                    StudyQuestionCard(question: question, selectedID: entry.answers[question.id], reveal: true, locked: true, onSelect: { _ in })
                }
            }.tacticalReadableWidth().padding(AppSpacing.screenPadding)
        }.foregroundStyle(AppTheme.text).scrollIndicators(.hidden)
    }
}

struct StudyHistoryView: View {
    @EnvironmentObject private var progress: ProgressStore
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    Text("Your latest 200 sessions. History starts with this update.").font(AppFont.body(16))
                    if progress.studyHistory.isEmpty { ContentUnavailableView("Your next session starts here", systemImage: "chart.bar", description: Text("Complete a quiz, Daily Five, or custom session to see your history.")) }
                    ForEach(progress.studyHistory) { entry in
                        NavigationLink { ZStack { BackgroundView(); StudyDebriefView(entry: entry) }.navigationTitle("Review session").navigationBarTitleDisplayMode(.inline) } label: {
                            ActionCard(title: "\(entry.kind.rawValue) · \(entry.score)/\(entry.total)", detail: entry.completedAt.formatted(date: .abbreviated, time: .shortened), icon: "checkmark.circle")
                        }.buttonStyle(.plain)
                    }
                }.tacticalReadableWidth().padding(AppSpacing.screenPadding)
            }
        }.foregroundStyle(AppTheme.text).navigationTitle("Session history").navigationBarTitleDisplayMode(.inline)
    }
}

struct SavedQuestionsView: View {
    @EnvironmentObject private var progress: ProgressStore
    private var saved: [QuizQuestion] { progress.studyQuestions(for: StudyConfiguration(pool: .saved), from: TrainingContent.allQuizQuestions(for: progress.selectedRole)) }
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    if saved.isEmpty { ContentUnavailableView("Save what matters", systemImage: "bookmark", description: Text("Tap the bookmark beside any question to keep it here.")) }
                    else {
                        NavigationLink("Practice saved questions") { StudyBuilderView(initialPool: .saved) }.buttonStyle(PrimaryButtonStyle())
                        ForEach(saved) { question in
                            DisclosureGroup {
                                StudyQuestionCard(question: StudyQuestion(question, shuffle: false), selectedID: nil, reveal: true, locked: true, onSelect: { _ in })
                            } label: { Text(question.prompt).font(AppFont.body(17)).foregroundStyle(AppTheme.text) }
                        }
                    }
                }.tacticalReadableWidth().padding(AppSpacing.screenPadding)
            }
        }.foregroundStyle(AppTheme.text).navigationTitle("Saved questions").navigationBarTitleDisplayMode(.inline)
    }
}
