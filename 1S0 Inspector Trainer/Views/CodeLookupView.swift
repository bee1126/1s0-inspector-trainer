import SwiftUI
import Combine

struct CodeLookupView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - State

    @State private var phase: GamePhase = .ready
    @State private var difficulty: CodeLookupDifficulty = .standard

    // Playing state
    @State private var questions: [CodeLookupQuestion] = []
    @State private var currentIndex: Int = 0
    @State private var score: Int = 0
    @State private var streak: Int = 0
    @State private var bestStreak: Int = 0
    @State private var correctCount: Int = 0
    @State private var timeRemaining: TimeInterval = 0
    @State private var timerCancellable: AnyCancellable? = nil
    @State private var shuffledAnswers: [String] = []

    // Answered state
    @State private var selectedAnswer: String? = nil
    @State private var wasCorrect: Bool = false
    @State private var pointsEarned: Int = 0
    @State private var showingFeedback: Bool = false
    @State private var advanceWorkItem: DispatchWorkItem? = nil

    // Results state
    @State private var missedQuestions: [(question: CodeLookupQuestion, picked: String?)] = []
    @State private var categoryStats: [String: (correct: Int, total: Int)] = [:]
    @State private var rewardSummary: RewardSummary? = nil
    @State private var animatedScore: Int = 0

    private enum GamePhase {
        case ready
        case playing
        case answered
        case results
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(spacing: AppSpacing.section) {
                    header

                    switch phase {
                    case .ready:
                        readyView
                    case .playing:
                        playingView
                    case .answered:
                        answeredView
                    case .results:
                        resultsView
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Code Lookup")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(phase != .ready)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if phase != .ready {
                    Button {
                        goBack()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Back")
                                .font(AppFont.body(14))
                        }
                        .foregroundColor(AppTheme.primary)
                    }
                }
            }
        }
        .onDisappear {
            stopTimer()
            advanceWorkItem?.cancel()
        }
    }

    // MARK: - Navigation

    private func goBack() {
        stopTimer()
        advanceWorkItem?.cancel()
        switch phase {
        case .ready:
            dismiss()
        case .playing, .answered:
            transition(to: .ready)
            resetGame()
        case .results:
            transition(to: .ready)
            resetGame()
        }
    }

    private func transition(to destination: GamePhase) {
        if reduceMotion {
            phase = destination
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                phase = destination
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("FIELD EXERCISE")
                .font(AppFont.mono(11))
                .foregroundColor(AppTheme.muted)
                .tracking(1.5)
            Spacer()
        }
    }

    // MARK: - Ready Screen

    private var readyView: some View {
        VStack(spacing: AppSpacing.section) {
            GlassCard(glow: AppTheme.primary.opacity(0.3)) {
                VStack(spacing: 16) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 36, weight: .light))
                        .foregroundColor(AppTheme.primary)

                    Text("CODE LOOKUP CHALLENGE")
                        .font(AppFont.title(18))
                        .foregroundColor(AppTheme.text)

                    Text("Match each violation to its correct OSHA or DAFMAN citation. Build your regulation recall under time pressure.")
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.muted)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }

            // Difficulty picker
            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("DIFFICULTY")
                        .font(AppFont.mono(11))
                        .foregroundColor(AppTheme.muted)
                        .tracking(1.2)

                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(CodeLookupDifficulty.allCases, id: \.self) { diff in
                            Text(diff.rawValue).tag(diff)
                        }
                    }
                    .pickerStyle(.segmented)

                    HStack {
                        Label("\(difficulty.questionCount) questions", systemImage: "list.number")
                        Spacer()
                        Label("\(Int(difficulty.timePerQuestion))s each", systemImage: "timer")
                    }
                    .font(AppFont.mono(12))
                    .foregroundColor(AppTheme.muted)
                }
            }

            // Best score
            if progress.bestCodeLookupScore > 0 {
                GlassCard {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("BEST SCORE")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                                .tracking(1.2)
                            Text("\(progress.bestCodeLookupScore)")
                                .font(AppFont.title(22))
                                .foregroundColor(AppTheme.primary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("BEST STREAK")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                                .tracking(1.2)
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(AppTheme.accent)
                                Text("\(progress.codeLookupBestStreak)")
                                    .font(AppFont.title(22))
                                    .foregroundColor(AppTheme.accent)
                            }
                        }
                    }
                }
            }

            Button {
                startGame()
            } label: {
                HStack {
                    Text("Start Challenge")
                    Spacer()
                    Image(systemName: "play.fill")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    // MARK: - Playing Screen

    private var playingView: some View {
        let currentQuestion = questions[currentIndex]
        let timeLimit = difficulty.timePerQuestion
        let timerProgress = timeRemaining / timeLimit
        let timerColor: Color = {
            if timeRemaining > timeLimit * 0.6 { return AppTheme.primary }
            if timeRemaining > timeLimit * 0.3 { return AppTheme.accent }
            return AppTheme.danger
        }()

        return VStack(spacing: AppSpacing.section) {
            // HUD
            HStack {
                Text("Q \(currentIndex + 1)/\(questions.count)")
                    .font(AppFont.mono(13))
                    .foregroundColor(AppTheme.text)

                Spacer()

                if streak >= 3 {
                    HStack(spacing: 2) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(AppTheme.accent)
                        Text("×\(streak)")
                            .foregroundColor(AppTheme.accent)
                    }
                    .font(AppFont.mono(13))
                }

                Spacer()

                Text("\(score) pts")
                    .font(AppFont.mono(13))
                    .foregroundColor(AppTheme.primary)
            }

            // Timer bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(AppTheme.border)
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(timerColor)
                        .frame(width: geo.size.width * max(timerProgress, 0), height: 6)
                        .animation(.linear(duration: 0.3), value: timeRemaining)
                }
            }
            .frame(height: 6)

            // Question card
            GlassCard(glow: timerColor.opacity(0.2)) {
                VStack(alignment: .leading, spacing: 12) {
                    TagPill(text: currentQuestion.category)

                    Text(currentQuestion.violationDescription)
                        .font(AppFont.body(15))
                        .foregroundColor(AppTheme.text)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Which regulation applies?")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.muted)
                        .italic()
                }
            }

            // Answer buttons
            VStack(spacing: 10) {
                ForEach(shuffledAnswers, id: \.self) { citation in
                    Button {
                        handleAnswer(citation)
                    } label: {
                        Text(citation)
                            .font(AppFont.mono(14))
                            .foregroundColor(AppTheme.text)
                            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(AppTheme.surface)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(AppTheme.border, lineWidth: 1)
                            )
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Answered Screen

    private var answeredView: some View {
        let currentQuestion = questions[currentIndex]

        return VStack(spacing: AppSpacing.section) {
            // HUD (same as playing)
            HStack {
                Text("Q \(currentIndex + 1)/\(questions.count)")
                    .font(AppFont.mono(13))
                    .foregroundColor(AppTheme.text)
                Spacer()
                Text("\(score) pts")
                    .font(AppFont.mono(13))
                    .foregroundColor(AppTheme.primary)
            }

            // Feedback banner
            GlassCard(glow: wasCorrect ? AppTheme.primary.opacity(0.4) : AppTheme.danger.opacity(0.4)) {
                HStack(spacing: 10) {
                    Image(systemName: wasCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(wasCorrect ? AppTheme.primary : AppTheme.danger)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(wasCorrect ? "Correct!" : "Incorrect")
                            .font(AppFont.subtitle(15))
                            .foregroundColor(wasCorrect ? AppTheme.primary : AppTheme.danger)
                        if wasCorrect {
                            Text("+\(pointsEarned) pts")
                                .font(AppFont.mono(13))
                                .foregroundColor(AppTheme.primary)
                        }
                    }

                    Spacer()

                    if streak >= 3 {
                        HStack(spacing: 2) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(AppTheme.accent)
                            Text("×\(streak)")
                                .foregroundColor(AppTheme.accent)
                        }
                        .font(AppFont.mono(14))
                    }
                }
            }

            // Question card with answer highlight
            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    TagPill(text: currentQuestion.category)

                    Text(currentQuestion.violationDescription)
                        .font(AppFont.body(14))
                        .foregroundColor(AppTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            // Answer buttons with highlights
            VStack(spacing: 10) {
                ForEach(shuffledAnswers, id: \.self) { citation in
                    let isCorrectAnswer = citation == currentQuestion.correctCitation
                    let isSelectedAnswer = citation == selectedAnswer
                    let borderColor: Color = {
                        if isCorrectAnswer { return AppTheme.primary }
                        if isSelectedAnswer && !wasCorrect { return AppTheme.danger }
                        return AppTheme.border
                    }()
                    let bgColor: Color = {
                        if isCorrectAnswer { return AppTheme.primary.opacity(0.15) }
                        if isSelectedAnswer && !wasCorrect { return AppTheme.danger.opacity(0.1) }
                        return AppTheme.surface
                    }()

                    HStack {
                        if isCorrectAnswer {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppTheme.primary)
                                .font(.system(size: 16))
                        } else if isSelectedAnswer && !wasCorrect {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AppTheme.danger)
                                .font(.system(size: 16))
                        }

                        Text(citation)
                            .font(AppFont.mono(14))
                            .foregroundColor(isCorrectAnswer ? AppTheme.primary : (isSelectedAnswer && !wasCorrect ? AppTheme.danger : AppTheme.muted))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(bgColor)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(borderColor, lineWidth: isCorrectAnswer || (isSelectedAnswer && !wasCorrect) ? 2 : 1)
                    )
                }
            }

            // Explanation
            GlassCard {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "info.circle")
                            .foregroundColor(AppTheme.info)
                        Text(currentQuestion.correctTitle)
                            .font(AppFont.subtitle(13))
                            .foregroundColor(AppTheme.info)
                    }
                    Text(currentQuestion.explanation)
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    // MARK: - Results Screen

    private var resultsView: some View {
        let totalQuestions = questions.count
        let accuracy = totalQuestions > 0 ? Double(correctCount) / Double(totalQuestions) : 0
        let accuracyPercent = Int(accuracy * 100)

        return VStack(spacing: AppSpacing.section) {
            // Score
            GlassCard(glow: AppTheme.primary.opacity(0.3)) {
                VStack(spacing: 12) {
                    Text("FINAL SCORE")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.muted)
                        .tracking(1.5)

                    Text("\(animatedScore)")
                        .font(AppFont.title(42))
                        .foregroundColor(AppTheme.primary)

                    if score == progress.bestCodeLookupScore && score > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(AppTheme.accent)
                            Text("NEW BEST!")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.accent)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .onAppear {
                animateScore()
            }

            // Stats grid
            GlassCard {
                VStack(spacing: 12) {
                    HStack {
                        statItem(label: "CORRECT", value: "\(correctCount)/\(totalQuestions)", color: AppTheme.primary)
                        Spacer()
                        statItem(label: "ACCURACY", value: "\(accuracyPercent)%", color: accuracyPercent >= 80 ? AppTheme.primary : AppTheme.accent)
                        Spacer()
                        statItem(label: "BEST STREAK", value: "\(bestStreak)", color: AppTheme.accent, icon: "flame.fill")
                    }
                }
            }

            // Category breakdown
            if !categoryStats.isEmpty {
                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("CATEGORY BREAKDOWN")
                            .font(AppFont.mono(11))
                            .foregroundColor(AppTheme.muted)
                            .tracking(1.2)

                        ForEach(categoryStats.sorted(by: { $0.key < $1.key }), id: \.key) { cat, stats in
                            HStack {
                                Text(cat)
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.text)
                                Spacer()
                                Text("\(stats.correct)/\(stats.total)")
                                    .font(AppFont.mono(13))
                                    .foregroundColor(stats.correct == stats.total ? AppTheme.primary : AppTheme.muted)

                                // Mini bar
                                GeometryReader { geo in
                                    let pct = stats.total > 0 ? CGFloat(stats.correct) / CGFloat(stats.total) : 0
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(AppTheme.border)
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(stats.correct == stats.total ? AppTheme.primary : AppTheme.accent)
                                            .frame(width: geo.size.width * pct)
                                    }
                                }
                                .frame(width: 60, height: 6)
                            }
                        }
                    }
                }
            }

            // Reward
            if let summary = rewardSummary {
                RewardSummaryCard(summary: summary, xpToNextLevel: progress.xpToNextLevel)
            }

            // Missed questions
            if !missedQuestions.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("REVIEW: MISSED QUESTIONS")
                        .font(AppFont.mono(11))
                        .foregroundColor(AppTheme.muted)
                        .tracking(1.2)

                    ForEach(Array(missedQuestions.enumerated()), id: \.offset) { _, item in
                        GlassCard(glow: AppTheme.danger.opacity(0.2)) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(AppTheme.danger)
                                        .font(.system(size: 14))
                                        .padding(.top, 2)
                                    Text(item.question.violationDescription)
                                        .font(AppFont.body(13))
                                        .foregroundColor(AppTheme.text)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                if let picked = item.picked {
                                    HStack(spacing: 6) {
                                        Text("You picked:")
                                            .font(AppFont.mono(11))
                                            .foregroundColor(AppTheme.muted)
                                        Text(picked)
                                            .font(AppFont.mono(12))
                                            .foregroundColor(AppTheme.danger)
                                    }
                                } else {
                                    Text("Time expired")
                                        .font(AppFont.mono(11))
                                        .foregroundColor(AppTheme.danger)
                                        .italic()
                                }

                                HStack(spacing: 6) {
                                    Text("Correct:")
                                        .font(AppFont.mono(11))
                                        .foregroundColor(AppTheme.muted)
                                    Text(item.question.correctCitation)
                                        .font(AppFont.mono(12))
                                        .foregroundColor(AppTheme.primary)
                                }

                                Text(item.question.explanation)
                                    .font(AppFont.body(12))
                                    .foregroundColor(AppTheme.muted)
                                    .italic()
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }

            // Buttons
            VStack(spacing: 10) {
                Button {
                    resetGame()
                    startGame()
                } label: {
                    HStack {
                        Text("Play Again")
                        Spacer()
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())

                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Done")
                        Spacer()
                        Image(systemName: "checkmark.circle")
                    }
                }
                .buttonStyle(OutlineButtonStyle())
            }
        }
    }

    private func statItem(label: String, value: String, color: Color, icon: String? = nil) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(AppFont.mono(10))
                .foregroundColor(AppTheme.muted)
                .tracking(1.0)
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 14))
                }
                Text(value)
                    .font(AppFont.title(20))
                    .foregroundColor(color)
            }
        }
    }

    // MARK: - Game Logic

    private func startGame() {
        // Shuffle and take the required number
        questions = Array(CodeLookupContent.questions.shuffled().prefix(difficulty.questionCount))
        currentIndex = 0
        score = 0
        streak = 0
        bestStreak = 0
        correctCount = 0
        missedQuestions = []
        categoryStats = [:]
        selectedAnswer = nil
        rewardSummary = nil
        animatedScore = 0

        prepareQuestion()
        transition(to: .playing)
        startTimer()
    }

    private func resetGame() {
        stopTimer()
        advanceWorkItem?.cancel()
        questions = []
        currentIndex = 0
        score = 0
        streak = 0
        bestStreak = 0
        correctCount = 0
        missedQuestions = []
        categoryStats = [:]
        selectedAnswer = nil
        wasCorrect = false
        pointsEarned = 0
        showingFeedback = false
        rewardSummary = nil
        animatedScore = 0
    }

    private func prepareQuestion() {
        guard currentIndex < questions.count else { return }
        let q = questions[currentIndex]
        shuffledAnswers = ([q.correctCitation] + q.distractors).shuffled()
        selectedAnswer = nil
        wasCorrect = false
        pointsEarned = 0
    }

    private func handleAnswer(_ citation: String) {
        guard phase == .playing else { return }
        stopTimer()

        let q = questions[currentIndex]
        selectedAnswer = citation
        let correct = citation == q.correctCitation

        // Track category stats
        var stats = categoryStats[q.category] ?? (correct: 0, total: 0)
        stats.total += 1

        if correct {
            wasCorrect = true
            streak += 1
            if streak > bestStreak { bestStreak = streak }
            correctCount += 1
            stats.correct += 1

            // Calculate points
            let timeLimit = difficulty.timePerQuestion
            let speedBonus = Int((timeRemaining / timeLimit) * 50)
            let streakMultiplier: Double = {
                if streak >= 10 { return 3.0 }
                if streak >= 5 { return 2.0 }
                if streak >= 3 { return 1.5 }
                return 1.0
            }()
            pointsEarned = Int(Double(100 + speedBonus) * streakMultiplier)
            score += pointsEarned

            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } else {
            wasCorrect = false
            streak = 0
            pointsEarned = 0
            missedQuestions.append((question: q, picked: citation))

            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

        categoryStats[q.category] = stats
        transition(to: .answered)

        // Auto-advance after delay
        let work = DispatchWorkItem { [currentIndex] in
            guard self.currentIndex == currentIndex else { return }
            advanceToNext()
        }
        advanceWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: work)
    }

    private func handleTimeout() {
        guard phase == .playing else { return }
        let q = questions[currentIndex]
        selectedAnswer = nil
        wasCorrect = false
        streak = 0
        pointsEarned = 0

        var stats = categoryStats[q.category] ?? (correct: 0, total: 0)
        stats.total += 1
        categoryStats[q.category] = stats

        missedQuestions.append((question: q, picked: nil))

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        transition(to: .answered)

        let work = DispatchWorkItem { [currentIndex] in
            guard self.currentIndex == currentIndex else { return }
            advanceToNext()
        }
        advanceWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: work)
    }

    private func advanceToNext() {
        advanceWorkItem?.cancel()

        if currentIndex + 1 >= questions.count {
            finishGame()
        } else {
            currentIndex += 1
            prepareQuestion()
            timeRemaining = difficulty.timePerQuestion
            transition(to: .playing)
            startTimer()
        }
    }

    private func finishGame() {
        stopTimer()
        let totalQuestions = questions.count
        let accuracy = totalQuestions > 0 ? Double(correctCount) / Double(totalQuestions) : 0

        rewardSummary = progress.completeCodeLookup(
            score: score,
            total: totalQuestions,
            accuracy: accuracy,
            bestStreak: bestStreak
        )

        transition(to: .results)
    }

    private func animateScore() {
        animatedScore = 0
        let target = score
        guard target > 0 else { return }

        let steps = min(target, 30)
        let increment = max(target / steps, 1)
        var current = 0

        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            current += increment
            if current >= target {
                animatedScore = target
                timer.invalidate()
            } else {
                animatedScore = current
            }
        }
    }

    // MARK: - Timer

    private func startTimer() {
        timeRemaining = difficulty.timePerQuestion
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard phase == .playing else { return }
                timeRemaining -= 0.1
                if timeRemaining <= 0 {
                    timeRemaining = 0
                    stopTimer()
                    handleTimeout()
                }
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
