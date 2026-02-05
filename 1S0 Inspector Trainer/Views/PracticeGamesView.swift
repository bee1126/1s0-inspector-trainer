import SwiftUI
import UniformTypeIdentifiers

// MARK: - RAC Sort

struct RacSortView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss

    @State private var unassigned: [RacHazard] = []
    @State private var buckets: [RacCategory: [RacHazard]] = [:]
    @State private var score: Int = 0
    @State private var mistakes: [RacSortMistake] = []
    @State private var rewardSummary: RewardSummary? = nil
    @State private var isComplete = false

    var body: some View {
        ZStack {
            BackgroundView()

            if isComplete {
                resultsView
            } else {
                gameplayView
            }
        }
        .navigationTitle("RAC Sort")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            progress.refreshForNewDayIfNeeded()
            resetGame()
        }
    }

    private var gameplayView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.section) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(AppFont.mono(12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule().fill(Color.white.opacity(0.18))
                        )
                    }
                    Spacer()
                    Text("\(sortedCount)/\(totalCount) sorted")
                        .font(AppFont.mono(12))
                        .foregroundColor(Color.white.opacity(0.8))
                }

                Text("RAC Sort")
                    .font(AppFont.title(26))
                    .foregroundColor(.white)

                Text("Drag hazards into the correct Risk Assessment Code bucket.")
                    .font(AppFont.body(14))
                    .foregroundColor(Color.white.opacity(0.85))

                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Unsorted Hazards")
                            .font(AppFont.subtitle(16))
                            .foregroundColor(AppTheme.charcoal)

                        if unassigned.isEmpty {
                            Text("All hazards are sorted. Score the run below.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.charcoal.opacity(0.7))
                        } else {
                            LazyVGrid(columns: hazardColumns, spacing: 12) {
                                ForEach(unassigned) { hazard in
                                    RacHazardCard(hazard: hazard)
                                        .onDrag {
                                            NSItemProvider(object: hazard.id as NSString)
                                        }
                                }
                            }
                        }
                    }
                    .onDrop(of: [UTType.text]) { providers in
                        handleDrop(providers: providers, to: nil)
                    }
                }

                VStack(spacing: 12) {
                    ForEach(RacCategory.allCases) { category in
                        RacBucketView(
                            category: category,
                            hazards: buckets[category] ?? [],
                            tint: tint(for: category)
                        ) { providers in
                            handleDrop(providers: providers, to: category)
                        }
                    }
                }

                if isReadyToScore {
                    Button("Score Run") {
                        scoreRun()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                } else {
                    Text("\(unassigned.count) hazards remaining")
                        .font(AppFont.body(12))
                        .foregroundColor(Color.white.opacity(0.75))
                }
            }
            .padding(AppSpacing.screenPadding)
        }
        .scrollIndicators(.hidden)
    }

    private var resultsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.section) {
                Text("RAC Sort Complete")
                    .font(AppFont.title(24))
                    .foregroundColor(.white)

                Text("Score: \(score)/\(totalCount)")
                    .font(AppFont.body(14))
                    .foregroundColor(Color.white.opacity(0.85))

                if let rewardSummary {
                    RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Missed Hazards")
                            .font(AppFont.subtitle(16))
                            .foregroundColor(AppTheme.charcoal)

                        if mistakes.isEmpty {
                            Text("No misses this round.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.charcoal.opacity(0.7))
                        } else {
                            ForEach(mistakes) { mistake in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(mistake.hazard.title)
                                        .font(AppFont.body(13))
                                        .foregroundColor(AppTheme.charcoal)
                                    Text("Placed: \(mistake.selected.rawValue) • Correct: \(mistake.hazard.rac.rawValue)")
                                        .font(AppFont.body(12))
                                        .foregroundColor(AppTheme.charcoal.opacity(0.7))
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }

                Button("Play Again") {
                    resetGame()
                }
                .buttonStyle(PrimaryButtonStyle())

                Button("Back to Home") {
                    dismiss()
                }
                .buttonStyle(OutlineButtonStyle())
            }
            .padding(AppSpacing.screenPadding)
        }
        .scrollIndicators(.hidden)
    }

    private var totalCount: Int { PracticeContent.racHazards.count }
    private var sortedCount: Int { totalCount - unassigned.count }
    private var isReadyToScore: Bool { unassigned.isEmpty }

    private var hazardColumns: [GridItem] {
        [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    }

    private func tint(for category: RacCategory) -> Color {
        switch category {
        case .rac1:
            return AppTheme.heartRed
        case .rac2:
            return AppTheme.xpGold
        case .rac3:
            return AppTheme.blue
        case .rac4:
            return AppTheme.mint
        }
    }

    private func handleDrop(providers: [NSItemProvider], to category: RacCategory?) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadObject(ofClass: NSString.self) { object, _ in
            guard let idString = object as String? else { return }
            DispatchQueue.main.async {
                moveHazard(withId: idString, to: category)
            }
        }
        return true
    }

    private func moveHazard(withId id: String, to category: RacCategory?) {
        guard let hazard = removeHazard(withId: id) else { return }
        if let category {
            buckets[category, default: []].append(hazard)
        } else {
            unassigned.append(hazard)
        }
    }

    private func removeHazard(withId id: String) -> RacHazard? {
        if let index = unassigned.firstIndex(where: { $0.id == id }) {
            return unassigned.remove(at: index)
        }

        for category in RacCategory.allCases {
            if var list = buckets[category],
               let index = list.firstIndex(where: { $0.id == id }) {
                let hazard = list.remove(at: index)
                buckets[category] = list
                return hazard
            }
        }

        return nil
    }

    private func scoreRun() {
        var correct = 0
        var misses: [RacSortMistake] = []

        for category in RacCategory.allCases {
            let list = buckets[category] ?? []
            for hazard in list {
                if hazard.rac == category {
                    correct += 1
                } else {
                    misses.append(RacSortMistake(hazard: hazard, selected: category))
                }
            }
        }

        score = correct
        mistakes = misses
        rewardSummary = progress.completePractice(score: correct, total: totalCount)
        isComplete = true
    }

    private func resetGame() {
        unassigned = PracticeContent.racHazards.shuffled()
        buckets = Dictionary(uniqueKeysWithValues: RacCategory.allCases.map { ($0, []) })
        score = 0
        mistakes = []
        rewardSummary = nil
        isComplete = false
    }
}

private struct RacSortMistake: Identifiable {
    let id = UUID()
    let hazard: RacHazard
    let selected: RacCategory
}

private struct RacHazardCard: View {
    let hazard: RacHazard
    var compact: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(hazard.title)
                .font(AppFont.subtitle(13))
                .foregroundColor(AppTheme.charcoal)
            Text(hazard.detail)
                .font(AppFont.body(12))
                .foregroundColor(AppTheme.charcoal.opacity(0.7))
                .lineLimit(compact ? 2 : 3)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.92))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
        )
    }
}

private struct RacBucketView: View {
    let category: RacCategory
    let hazards: [RacHazard]
    let tint: Color
    let onDrop: ([NSItemProvider]) -> Bool
    @State private var isTargeted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text(category.rawValue)
                    .font(AppFont.subtitle(15))
                    .foregroundColor(AppTheme.charcoal)
                Text(category.severity)
                    .font(AppFont.mono(11))
                    .foregroundColor(tint)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(tint.opacity(0.15)))
            }

            Text(category.description)
                .font(AppFont.body(12))
                .foregroundColor(AppTheme.charcoal.opacity(0.65))

            if hazards.isEmpty {
                Text("Drop hazards here")
                    .font(AppFont.body(12))
                    .foregroundColor(AppTheme.charcoal.opacity(0.5))
                    .padding(.vertical, 4)
            } else {
                VStack(spacing: 8) {
                    ForEach(hazards) { hazard in
                        RacHazardCard(hazard: hazard, compact: true)
                            .onDrag {
                                NSItemProvider(object: hazard.id as NSString)
                            }
                    }
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.88))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(isTargeted ? tint.opacity(0.9) : Color.white.opacity(0.4), lineWidth: 1.5)
        )
        .onDrop(of: [UTType.text], isTargeted: $isTargeted, perform: onDrop)
    }
}

// MARK: - Sequence Builder

struct SequenceBuilderSelectionView: View {
    private let sequences = PracticeContent.sequenceSets

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text("Sequence Builder")
                        .font(AppFont.title(26))
                        .foregroundColor(.white)

                    Text("Reorder the steps until the sequence is correct.")
                        .font(AppFont.body(14))
                        .foregroundColor(Color.white.opacity(0.85))

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(sequences) { sequence in
                            NavigationLink {
                                SequenceBuilderView(sequence: sequence)
                            } label: {
                                SequenceCard(sequence: sequence)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Sequence Builder")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SequenceBuilderView: View {
    @EnvironmentObject private var progress: ProgressStore
    let sequence: SequenceSet

    @State private var steps: [SequenceStep] = []
    @State private var score: Int = 0
    @State private var showResults = false
    @State private var rewardSummary: RewardSummary? = nil

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text(sequence.title)
                        .font(AppFont.title(24))
                        .foregroundColor(.white)

                    Text(sequence.detail)
                        .font(AppFont.body(14))
                        .foregroundColor(Color.white.opacity(0.85))

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Drag to reorder")
                                .font(AppFont.subtitle(15))
                                .foregroundColor(AppTheme.charcoal)

                            List {
                                ForEach(steps) { step in
                                    SequenceRow(step: step, index: indexForStep(step), isCorrect: isCorrect(step: step))
                                        .listRowBackground(Color.clear)
                                        .listRowSeparator(.hidden)
                                }
                                .onMove(perform: move)
                            }
                            .frame(height: listHeight)
                            .scrollContentBackground(.hidden)
                            .environment(\.editMode, .constant(.active))
                            .listStyle(.plain)
                        }
                    }

                    if showResults {
                        Text("Correct positions: \(score)/\(steps.count)")
                            .font(AppFont.body(13))
                            .foregroundColor(Color.white.opacity(0.85))

                        if let rewardSummary {
                            RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                        }
                    }

                    Button(showResults ? "Shuffle & Retry" : "Check Sequence") {
                        if showResults {
                            resetSequence()
                        } else {
                            checkSequence()
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Sequence Builder")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            progress.refreshForNewDayIfNeeded()
            resetSequence()
        }
    }

    private var listHeight: CGFloat {
        let rowHeight: CGFloat = 66
        let maxHeight: CGFloat = 360
        return min(maxHeight, CGFloat(steps.count) * rowHeight)
    }

    private func resetSequence() {
        steps = sequence.steps.enumerated().map { index, text in
            SequenceStep(id: UUID(), text: text, correctIndex: index)
        }.shuffled()
        score = 0
        showResults = false
        rewardSummary = nil
    }

    private func move(from source: IndexSet, to destination: Int) {
        steps.move(fromOffsets: source, toOffset: destination)
    }

    private func checkSequence() {
        var correctPositions = 0
        for (index, step) in steps.enumerated() {
            if step.correctIndex == index {
                correctPositions += 1
            }
        }
        score = correctPositions
        rewardSummary = progress.completePractice(score: correctPositions, total: steps.count)
        showResults = true
    }

    private func indexForStep(_ step: SequenceStep) -> Int {
        steps.firstIndex(where: { $0.id == step.id }) ?? 0
    }

    private func isCorrect(step: SequenceStep) -> Bool? {
        guard showResults else { return nil }
        let index = indexForStep(step)
        return step.correctIndex == index
    }
}

private struct SequenceStep: Identifiable, Hashable {
    let id: UUID
    let text: String
    let correctIndex: Int
}

private struct SequenceRow: View {
    let step: SequenceStep
    let index: Int
    let isCorrect: Bool?

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(index + 1)")
                .font(AppFont.mono(12))
                .foregroundColor(AppTheme.blue)
                .frame(width: 24, alignment: .leading)

            Text(step.text)
                .font(AppFont.body(13))
                .foregroundColor(AppTheme.charcoal)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            if let isCorrect {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(isCorrect ? AppTheme.safetyGreen : Color.red.opacity(0.7))
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.9))
        )
    }
}

private struct SequenceCard: View {
    let sequence: SequenceSet

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 6) {
                Text(sequence.title)
                    .font(AppFont.subtitle(17))
                    .foregroundColor(AppTheme.charcoal)
                Text(sequence.detail)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
                Text("\(sequence.steps.count) steps")
                    .font(AppFont.mono(11))
                    .foregroundColor(AppTheme.blue)
            }
        }
    }
}

// MARK: - True/False Blitz

struct TrueFalseBlitzView: View {
    @EnvironmentObject private var progress: ProgressStore

    @State private var questions: [TrueFalseQuestion] = []
    @State private var index = 0
    @State private var selectedAnswer: Bool? = nil
    @State private var correctCount = 0
    @State private var showFeedback = false
    @State private var rewardSummary: RewardSummary? = nil
    @State private var isComplete = false
    @State private var timeLeft: Int = 8
    @State private var timerActive = true

    private let timeLimit = 8
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            BackgroundView()

            if isComplete {
                resultsView
            } else {
                gameplayView
            }
        }
        .navigationTitle("True/False Blitz")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            progress.refreshForNewDayIfNeeded()
            prepareQuestions()
        }
        .onReceive(timer) { _ in
            guard timerActive, selectedAnswer == nil, !isComplete else { return }
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                triggerTimeout()
            }
        }
    }

    private var gameplayView: some View {
        return ScrollView {
            GlassCard {
                VStack(alignment: .leading, spacing: AppSpacing.stack) {
                    if questions.isEmpty {
                        Text("No questions available.")
                            .font(AppFont.subtitle(18))
                            .foregroundColor(AppTheme.charcoal)
                        Text("Add more True/False questions to run a blitz.")
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.charcoal.opacity(0.7))
                    } else {
                        let question = questions[index]

                        HStack {
                            Text("Blitz")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.charcoal.opacity(0.6))
                            Spacer()
                            HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, compact: true, onDark: false)
                            Text("\(index + 1)/\(questions.count)")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.charcoal.opacity(0.6))
                        }

                        HStack {
                            Text("Time")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.charcoal.opacity(0.6))
                            Text("\(timeLeft)s")
                                .font(AppFont.subtitle(14))
                                .foregroundColor(timeLeft <= 3 ? Color.red.opacity(0.8) : AppTheme.charcoal)
                            Spacer()
                            Toggle("Time Pressure", isOn: $timerActive)
                                .labelsHidden()
                                .tint(AppTheme.blue)
                        }

                        Text(question.statement)
                            .font(AppFont.subtitle(18))
                            .foregroundColor(AppTheme.charcoal)

                        VStack(spacing: 10) {
                            OptionRow(
                                text: "True",
                                isSelected: selectedAnswer == true,
                                isCorrect: question.answer,
                                isLocked: selectedAnswer != nil,
                                revealCorrect: true
                            )
                            .onTapGesture {
                                answer(true)
                            }

                            OptionRow(
                                text: "False",
                                isSelected: selectedAnswer == false,
                                isCorrect: !question.answer,
                                isLocked: selectedAnswer != nil,
                                revealCorrect: true
                            )
                            .onTapGesture {
                                answer(false)
                            }
                        }

                        if showFeedback {
                            FeedbackView(
                                text: question.explanation,
                                isCorrect: selectedAnswer == question.answer
                            )

                            Button(index == questions.count - 1 ? "Finish Blitz" : "Next") {
                                advance()
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                    }
                }
            }
            .padding(AppSpacing.screenPadding)
        }
        .scrollIndicators(.hidden)
    }

    private var resultsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.section) {
                Text("Blitz Complete")
                    .font(AppFont.title(24))
                    .foregroundColor(.white)

                Text("Score: \(correctCount)/\(questions.count)")
                    .font(AppFont.body(14))
                    .foregroundColor(Color.white.opacity(0.85))

                if let rewardSummary {
                    RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                }

                Button("Run Another Blitz") {
                    prepareQuestions()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(AppSpacing.screenPadding)
        }
        .scrollIndicators(.hidden)
    }

    private func prepareQuestions() {
        let count = min(10, PracticeContent.trueFalseQuestions.count)
        questions = Array(PracticeContent.trueFalseQuestions.shuffled().prefix(count))
        index = 0
        selectedAnswer = nil
        correctCount = 0
        showFeedback = false
        rewardSummary = nil
        isComplete = false
        resetTimer()
    }

    private func answer(_ value: Bool) {
        guard selectedAnswer == nil else { return }
        selectedAnswer = value
        if value == questions[index].answer {
            correctCount += 1
            AppFeedback.correct()
        } else {
            AppFeedback.incorrect()
        }
        showFeedback = true
    }

    private func advance() {
        if index == questions.count - 1 {
            finish()
        } else {
            index += 1
            selectedAnswer = nil
            showFeedback = false
            resetTimer()
        }
    }

    private func finish() {
        rewardSummary = progress.completePractice(score: correctCount, total: questions.count)
        isComplete = true
    }

    private func triggerTimeout() {
        guard selectedAnswer == nil else { return }
        if !questions.isEmpty {
            selectedAnswer = !questions[index].answer
        }
        AppFeedback.incorrect()
        showFeedback = true
    }

    private func resetTimer() {
        timeLeft = timeLimit
    }
}

// MARK: - Micro Drills

struct MicroDrillSelectionView: View {
    @EnvironmentObject private var progress: ProgressStore

    private var topics: [MicroDrillTopic] { PracticeContent.microDrillTopics }
    private var modules: [TrainingModule] { TrainingContent.modules(for: progress.selectedRole) }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text("Micro-Drills")
                        .font(AppFont.title(26))
                        .foregroundColor(.white)

                    Text("Short, role-specific drills focused on a single topic.")
                        .font(AppFont.body(14))
                        .foregroundColor(Color.white.opacity(0.85))

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(topics) { topic in
                            NavigationLink {
                                MicroDrillSessionView(topic: topic)
                            } label: {
                                MicroDrillCard(topic: topic, questionCount: questionCount(for: topic))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Micro-Drills")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func questionCount(for topic: MicroDrillTopic) -> Int {
        modules
            .filter { topic.moduleIds.contains($0.id) }
            .flatMap { $0.quiz }
            .count
    }
}

struct MicroDrillSessionView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    let topic: MicroDrillTopic

    @State private var result: AssessmentResult? = nil
    @State private var rewardSummary: RewardSummary? = nil
    @State private var sessionId = UUID()

    private var questionPool: [QuizQuestion] {
        let modules = TrainingContent.modules(for: progress.selectedRole)
        return modules.filter { topic.moduleIds.contains($0.id) }.flatMap { $0.quiz }
    }

    var body: some View {
        ZStack {
            BackgroundView()

            if let result {
                ScrollView {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Micro-Drill Complete")
                                .font(AppFont.title(22))
                                .foregroundColor(AppTheme.charcoal)

                            Text("Score: \(result.score)/\(result.total)")
                                .font(AppFont.subtitle(16))
                                .foregroundColor(AppTheme.charcoal)

                            if let rewardSummary {
                                RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                            }

                            Button("Run Another Drill") {
                                resetSession()
                            }
                            .buttonStyle(PrimaryButtonStyle())

                            Button("Back") {
                                dismiss()
                            }
                            .buttonStyle(OutlineButtonStyle())
                        }
                    }
                    .padding(AppSpacing.screenPadding)
                }
                .scrollIndicators(.hidden)
            } else {
                if questionPool.isEmpty {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("No questions available")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)
                            Text("This drill needs more questions. Try another topic.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.charcoal.opacity(0.7))
                            Button("Back") {
                                dismiss()
                            }
                            .buttonStyle(OutlineButtonStyle())
                        }
                    }
                    .padding(AppSpacing.screenPadding)
                } else {
                    QuizFlowView(
                        questions: questionPool,
                        onComplete: { result, streak in
                            rewardSummary = progress.completePractice(score: result.score, total: result.total, streakMultiplier: streak.multiplier)
                            self.result = result
                        },
                        showsHearts: true,
                        shuffleQuestions: true,
                        maxQuestions: min(topic.maxQuestions, questionPool.count)
                    )
                    .id(sessionId)
                }
            }
        }
        .navigationTitle(topic.title)
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

private struct MicroDrillCard: View {
    let topic: MicroDrillTopic
    let questionCount: Int

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(topic.title)
                        .font(AppFont.subtitle(17))
                        .foregroundColor(AppTheme.charcoal)
                    Spacer()
                    TagPill(text: "\(questionCount) Qs")
                }
                Text(topic.detail)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
            }
        }
    }
}

// MARK: - Onboarding Path

struct OnboardingPathView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var rewardSummary: RewardSummary? = nil
    @State private var showRestartAlert = false

    private var days: [OnboardingDay] { PracticeContent.onboardingDays }
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
                    Text("Starter Program")
                        .font(AppFont.title(26))
                        .foregroundColor(.white)

                    if progress.onboardingStartDate == nil {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("7-Day Starter Path")
                                    .font(AppFont.subtitle(18))
                                    .foregroundColor(AppTheme.charcoal)
                                Text("Complete one short check-in each day to build momentum.")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
                                Button("Start Program") {
                                    progress.startOnboardingIfNeeded()
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            }
                        }
                    } else {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Progress")
                                    .font(AppFont.subtitle(18))
                                    .foregroundColor(AppTheme.charcoal)

                                ProgressView(value: progressValue)
                                    .tint(AppTheme.safetyGreen)

                                Text("\(completedCount)/\(totalDays) check-ins")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.charcoal.opacity(0.7))

                                if let dayNumber = currentDayNumber {
                                    Text("Day \(dayNumber) of \(totalDays)")
                                        .font(AppFont.subtitle(15))
                                        .foregroundColor(AppTheme.blue)
                                }

                                if canCheckIn, let dayNumber = currentDayNumber {
                                    Button("Check in for Day \(dayNumber)") {
                                        rewardSummary = progress.checkInOnboardingDay()
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                } else {
                                    Text("Check-in complete for today.")
                                        .font(AppFont.body(12))
                                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
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
                                        .foregroundColor(AppTheme.blue)
                                    if isComplete {
                                        Text("Complete")
                                            .font(AppFont.mono(11))
                                            .foregroundColor(AppTheme.safetyGreen)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Capsule().fill(AppTheme.mint.opacity(0.6)))
                                    } else if isCurrent {
                                        Text("Today")
                                            .font(AppFont.mono(11))
                                            .foregroundColor(AppTheme.xpGold)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Capsule().fill(AppTheme.xpGold.opacity(0.2)))
                                    }
                                    Spacer()
                                }

                                Text(day.title)
                                    .font(AppFont.subtitle(17))
                                    .foregroundColor(AppTheme.charcoal)

                                Text(day.summary)
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.charcoal.opacity(0.7))

                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(day.tasks, id: \.self) { task in
                                        Text("• \(task)")
                                            .font(AppFont.body(12))
                                            .foregroundColor(AppTheme.charcoal.opacity(0.7))
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
            PracticeSessionView(mode: .dailyFive)
        case .matchSprint:
            MatchingDeckSelectionView()
        case .racSort:
            RacSortView()
        case .sequenceBuilder:
            SequenceBuilderSelectionView()
        case .trueFalseBlitz:
            TrueFalseBlitzView()
        case .microDrill:
            MicroDrillSelectionView()
        }
    }

    private func actionLabel(for action: OnboardingAction) -> String {
        switch action {
        case .module(let id):
            let title = TrainingContent.modules(for: progress.selectedRole).first(where: { $0.id == id })?.title ?? "Module"
            return "Start \(title)"
        case .dailyFive:
            return "Run Daily 5"
        case .matchSprint:
            return "Start Match Sprint"
        case .racSort:
            return "Open RAC Sort"
        case .sequenceBuilder:
            return "Open Sequence Builder"
        case .trueFalseBlitz:
            return "Start True/False Blitz"
        case .microDrill:
            return "Start Micro-Drill"
        }
    }
}
