import SwiftUI

struct MatchingGameView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let deckId: String
    let deckTitle: String

    @State private var cards: [MatchCard] = []
    @State private var selectedCardId: UUID? = nil
    @State private var matchedPairIds: Set<UUID> = []
    @State private var mismatchCardIds: Set<UUID> = []
    @State private var isResolvingMismatch = false
    @State private var mistakeCount = 0
    @State private var timeRemaining: TimeInterval = 0
    @State private var startTime: Date? = nil
    @State private var timerRunning = false
    @State private var rewardSummary: RewardSummary? = nil
    @State private var isComplete = false
    @State private var timedOut = false

    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    private let timeLimit: TimeInterval = 30

    private var questionPool: [QuizQuestion] {
        TrainingContent.modules.flatMap { $0.quiz }
    }

    private var selectedQuestions: [QuizQuestion] {
        if deckId == "all" {
            return questionPool
        }
        return TrainingContent.modules.first(where: { $0.id == deckId })?.quiz ?? questionPool
    }

    private var totalPairs: Int {
        Set(cards.map { $0.pairId }).count
    }

    private var pairsMatched: Int {
        matchedPairIds.count
    }

    private var desiredPairCount: Int {
        horizontalSizeClass == .regular ? 8 : 6
    }

    private var columns: [GridItem] {
        let count = horizontalSizeClass == .regular ? 3 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: count)
    }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.section) {
                    headerCard
                    matchGrid
                    helperCopy
                }
                .padding(AppSpacing.screenPadding)
            }

            if isComplete {
                completionOverlay
            }
        }
        .navigationTitle("Match Sprint")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            progress.refreshForNewDayIfNeeded()
            resetGame()
        }
        .onReceive(timer) { _ in
            updateTimer()
        }
    }

    private var headerCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Match Sprint")
                            .font(AppFont.title(22))
                            .foregroundColor(AppTheme.charcoal)
                        Text("Race the clock by pairing prompts with their best answers.")
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.charcoal.opacity(0.7))
                    }
                    Spacer()
                    HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, compact: true, onDark: false)
                }

                HStack(spacing: 10) {
                    StatPill(title: "Time", value: formattedTime(timeRemaining), tint: timeRemaining <= 5 ? Color.red.opacity(0.7) : AppTheme.xpGold)
                    StatPill(title: "Pairs", value: "\(pairsMatched)/\(totalPairs)", tint: AppTheme.safetyGreen)
                    StatPill(title: "Mistakes", value: "\(mistakeCount)", tint: Color.red.opacity(0.7))
                }

                TagPill(text: deckTitle)

                Button("Shuffle & Restart") {
                    resetGame()
                }
                .buttonStyle(OutlineButtonStyle())
            }
        }
    }

    private var matchGrid: some View {
        GlassCard {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(cards) { card in
                    MatchCardView(
                        card: card,
                        isSelected: selectedCardId == card.id,
                        isMatched: matchedPairIds.contains(card.pairId),
                        isMismatched: mismatchCardIds.contains(card.id)
                    )
                    .onTapGesture {
                        handleTap(card)
                    }
                    .animation(.spring(response: 0.25, dampingFraction: 0.8), value: matchedPairIds)
                }
            }
        }
    }

    private var helperCopy: some View {
        Group {
            if !isComplete {
                Text(startTime == nil ? "Tap any card to start the 30-second timer." : "Match every pair before time runs out.")
                    .font(AppFont.body(13))
                    .foregroundColor(Color.white.opacity(0.85))
            }
        }
    }

    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text(timedOut ? "Time's Up" : "Sprint Complete")
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.charcoal)

                    Text("Time left: \(formattedTime(timeRemaining))")
                        .font(AppFont.subtitle(16))
                        .foregroundColor(AppTheme.charcoal)

                    Text("Pairs matched: \(pairsMatched)/\(totalPairs)")
                        .font(AppFont.body(14))
                        .foregroundColor(AppTheme.charcoal.opacity(0.75))

                    Text("Mistakes: \(mistakeCount)")
                        .font(AppFont.body(14))
                        .foregroundColor(AppTheme.charcoal.opacity(0.75))

                    if let rewardSummary {
                        RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
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
            }
            .padding(AppSpacing.screenPadding)
        }
    }

    private func handleTap(_ card: MatchCard) {
        guard !isComplete else { return }
        guard !matchedPairIds.contains(card.pairId) else { return }
        guard !isResolvingMismatch else { return }

        if startTime == nil {
            startTime = Date()
            timerRunning = true
        }

        if let selectedId = selectedCardId {
            if selectedId == card.id {
                selectedCardId = nil
                return
            }

            let first = cards.first { $0.id == selectedId }
            selectedCardId = nil

            guard let first else { return }
            if first.pairId == card.pairId {
                matchedPairIds.insert(card.pairId)
                if pairsMatched == totalPairs {
                    finishGame()
                }
            } else {
                mistakeCount += 1
                mismatchCardIds = [first.id, card.id]
                isResolvingMismatch = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                    mismatchCardIds.removeAll()
                    isResolvingMismatch = false
                }
            }
        } else {
            selectedCardId = card.id
        }
    }

    private func finishGame() {
        if let startTime {
            let elapsed = Date().timeIntervalSince(startTime)
            timeRemaining = max(0, timeLimit - elapsed)
        }
        timerRunning = false
        let score = max(0, pairsMatched - mistakeCount)
        rewardSummary = progress.completePractice(score: score, total: totalPairs)
        isComplete = true
    }

    private func updateTimer() {
        guard timerRunning, let startTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        timeRemaining = max(0, timeLimit - elapsed)
        if timeRemaining <= 0 {
            timedOut = true
            finishGame()
        }
    }

    private func resetGame() {
        cards = buildCards()
        selectedCardId = nil
        matchedPairIds = []
        mismatchCardIds = []
        isResolvingMismatch = false
        mistakeCount = 0
        timeRemaining = timeLimit
        startTime = nil
        timerRunning = false
        rewardSummary = nil
        isComplete = false
        timedOut = false
    }

    private func buildCards() -> [MatchCard] {
        let pairs = buildPairs(from: selectedQuestions, count: desiredPairCount)
        let cards = pairs.flatMap { pair in
            [
                MatchCard(id: UUID(), pairId: pair.id, text: pair.term, kind: .term),
                MatchCard(id: UUID(), pairId: pair.id, text: pair.definition, kind: .definition)
            ]
        }
        return cards.shuffled()
    }

    private func buildPairs(from questions: [QuizQuestion], count: Int) -> [MatchPair] {
        var pairs: [MatchPair] = []
        var seen: Set<String> = []
        let target = max(2, min(count, questions.count))

        for question in questions.shuffled() {
            guard let correct = question.choices.first(where: { $0.isCorrect }) else { continue }
            let term = question.prompt.trimmingCharacters(in: .whitespacesAndNewlines)
            let definition = correct.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !term.isEmpty, !definition.isEmpty else { continue }

            let key = "\(term.lowercased())|\(definition.lowercased())"
            guard !seen.contains(key) else { continue }
            seen.insert(key)

            pairs.append(MatchPair(id: UUID(), term: term, definition: definition))
            if pairs.count == target {
                break
            }
        }

        return pairs
    }

    private func formattedTime(_ interval: TimeInterval) -> String {
        let clamped = max(0, interval)
        let totalSeconds = Int(clamped)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        let tenths = Int((clamped - Double(totalSeconds)) * 10)
        return String(format: "%02d:%02d.%d", minutes, seconds, tenths)
    }
}

struct MatchingDeckSelectionView: View {
    private let deckOptions: [MatchDeckOption] = {
        let allCount = TrainingContent.modules.flatMap { $0.quiz }.count
        var options: [MatchDeckOption] = [
            MatchDeckOption(
                id: "all",
                title: "All Modules",
                detail: "Mix every topic into one sprint.",
                questionCount: allCount
            )
        ]
        options.append(contentsOf: TrainingContent.modules.map { module in
            MatchDeckOption(
                id: module.id,
                title: module.title,
                detail: module.subtitle,
                questionCount: module.quiz.count
            )
        })
        return options
    }()

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text("Match Sprint")
                        .font(AppFont.title(26))
                        .foregroundColor(.white)

                    Text("Choose a module to start a 30-second sprint.")
                        .font(AppFont.body(14))
                        .foregroundColor(Color.white.opacity(0.85))

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(deckOptions) { option in
                            NavigationLink {
                                MatchingGameView(deckId: option.id, deckTitle: option.title)
                            } label: {
                                MatchDeckCard(option: option)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Match Sprint")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct MatchDeckOption: Identifiable {
    let id: String
    let title: String
    let detail: String
    let questionCount: Int
}

private struct MatchDeckCard: View {
    let option: MatchDeckOption

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 10) {
                    Text(option.title)
                        .font(AppFont.subtitle(17))
                        .foregroundColor(AppTheme.charcoal)
                    Spacer()
                    TagPill(text: "\(option.questionCount) Qs")
                }

                Text(option.detail)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
            }
        }
    }
}

private struct MatchPair: Hashable {
    let id: UUID
    let term: String
    let definition: String
}

private struct MatchCard: Identifiable, Hashable {
    let id: UUID
    let pairId: UUID
    let text: String
    let kind: MatchCardKind
}

private enum MatchCardKind {
    case term
    case definition
}

private struct MatchCardView: View {
    let card: MatchCard
    let isSelected: Bool
    let isMatched: Bool
    let isMismatched: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 6) {
                Text(card.kind == .term ? "Prompt" : "Answer")
                    .font(AppFont.mono(10))
                    .foregroundColor(labelColor)

                Text(card.text)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.charcoal)
                    .lineLimit(4)
                    .minimumScaleFactor(0.85)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 84, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
            .opacity(isMatched ? 0.55 : 1.0)

            if isMatched {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppTheme.safetyGreen)
                    .padding(10)
            }
        }
    }

    private var backgroundColor: Color {
        if isMatched {
            return AppTheme.mint.opacity(0.7)
        }
        if isMismatched {
            return Color.red.opacity(0.12)
        }
        if isSelected {
            return AppTheme.sky.opacity(0.35)
        }
        return Color.white.opacity(0.92)
    }

    private var borderColor: Color {
        if isMatched {
            return AppTheme.safetyGreen.opacity(0.8)
        }
        if isMismatched {
            return Color.red.opacity(0.6)
        }
        if isSelected {
            return AppTheme.blue.opacity(0.6)
        }
        return Color.white.opacity(0.4)
    }

    private var labelColor: Color {
        if isMatched {
            return AppTheme.safetyGreen
        }
        if isSelected {
            return AppTheme.blue
        }
        return AppTheme.charcoal.opacity(0.5)
    }
}
