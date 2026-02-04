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
    @State private var mistakes: [MatchMistake] = []
    @State private var pairsSnapshot: [MatchPairSummary] = []

    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    private let timeLimit: TimeInterval = 30

    private var questionPool: [QuizQuestion] {
        TrainingContent.allQuizQuestions
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

    private var columnCount: Int {
        horizontalSizeClass == .regular ? 3 : 2
    }

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 12), count: columnCount)
    }

    var body: some View {
        ZStack {
            BackgroundView()

            if isComplete {
                resultsView
            } else {
                gameplayView
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            progress.refreshForNewDayIfNeeded()
            resetGame()
        }
        .onReceive(timer) { _ in
            updateTimer()
        }
    }

    private var gameplayView: some View {
        VStack(spacing: 16) {
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
            }
            .overlay(
                Text(formattedTime(timeRemaining))
                    .font(AppFont.mono(22))
                    .foregroundColor(timeRemaining <= 5 ? Color.red.opacity(0.9) : Color.white)
            )

            ScrollView {
                matchGrid
                    .padding(.top, 4)
            }
            .scrollIndicators(.hidden)
        }
        .padding(AppSpacing.screenPadding)
    }

    private var matchGrid: some View {
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

    private var resultsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.section) {
                Text(timedOut ? "Time's Up" : "Sprint Complete")
                    .font(AppFont.title(24))
                    .foregroundColor(.white)

                Text("Time left: \(formattedTime(timeRemaining))")
                    .font(AppFont.body(15))
                    .foregroundColor(Color.white.opacity(0.85))

                Text("Pairs matched: \(pairsMatched)/\(totalPairs)")
                    .font(AppFont.body(14))
                    .foregroundColor(Color.white.opacity(0.85))

                Text("Mistakes: \(mistakeCount)")
                    .font(AppFont.body(14))
                    .foregroundColor(Color.white.opacity(0.85))

                if let rewardSummary {
                    RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Pairs")
                            .font(AppFont.subtitle(16))
                            .foregroundColor(AppTheme.charcoal)

                        ForEach(pairsSnapshot) { pair in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(pair.term)
                                    .font(AppFont.body(14))
                                    .foregroundColor(AppTheme.charcoal)
                                Text(pair.definition)
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Mistakes")
                            .font(AppFont.subtitle(16))
                            .foregroundColor(AppTheme.charcoal)

                        if mistakes.isEmpty {
                            Text("No mistakes this round.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.charcoal.opacity(0.7))
                        } else {
                            ForEach(mistakes) { mistake in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(mistake.firstKind.label): \(mistake.firstText)")
                                        .font(AppFont.body(13))
                                        .foregroundColor(AppTheme.charcoal)
                                    Text("\(mistake.secondKind.label): \(mistake.secondText)")
                                        .font(AppFont.body(13))
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
                mistakes.append(
                    MatchMistake(
                        firstText: first.text,
                        firstKind: first.kind,
                        secondText: card.text,
                        secondKind: card.kind
                    )
                )
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
        let newCards = buildCards()
        cards = newCards
        selectedCardId = nil
        matchedPairIds = []
        mismatchCardIds = []
        isResolvingMismatch = false
        mistakeCount = 0
        mistakes = []
        timeRemaining = timeLimit
        startTime = nil
        timerRunning = false
        rewardSummary = nil
        isComplete = false
        timedOut = false
        pairsSnapshot = buildPairSummaries(from: newCards)
    }

    private func buildCards() -> [MatchCard] {
        let pairs = buildPairs(from: selectedQuestions, count: desiredPairCount)
        let cards = pairs.flatMap { pair in
            [
                MatchCard(id: UUID(), pairId: pair.id, text: pair.term, kind: .term),
                MatchCard(id: UUID(), pairId: pair.id, text: pair.definition, kind: .definition)
            ]
        }
        return arrangeCardsAvoidingAdjacentPairs(cards, columns: columnCount)
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

    private func arrangeCardsAvoidingAdjacentPairs(_ cards: [MatchCard], columns: Int) -> [MatchCard] {
        guard cards.count > 2, columns > 0 else { return cards.shuffled() }
        var best = cards
        var bestScore = Int.max

        for _ in 0..<300 {
            let shuffled = cards.shuffled()
            let score = adjacentPairCount(in: shuffled, columns: columns)
            if score == 0 {
                return shuffled
            }
            if score < bestScore {
                bestScore = score
                best = shuffled
            }
        }

        return best
    }

    private func adjacentPairCount(in cards: [MatchCard], columns: Int) -> Int {
        var indices: [UUID: [Int]] = [:]
        for (index, card) in cards.enumerated() {
            indices[card.pairId, default: []].append(index)
        }
        var count = 0
        for (_, pairIndices) in indices {
            guard pairIndices.count == 2 else { continue }
            if areAdjacent(pairIndices[0], pairIndices[1], columns: columns) {
                count += 1
            }
        }
        return count
    }

    private func areAdjacent(_ first: Int, _ second: Int, columns: Int) -> Bool {
        let rowA = first / columns
        let colA = first % columns
        let rowB = second / columns
        let colB = second % columns
        if rowA == rowB && abs(colA - colB) == 1 {
            return true
        }
        if colA == colB && abs(rowA - rowB) == 1 {
            return true
        }
        return false
    }

    private func buildPairSummaries(from cards: [MatchCard]) -> [MatchPairSummary] {
        let grouped = Dictionary(grouping: cards, by: { $0.pairId })
        return grouped.compactMap { pairId, cards in
            guard let term = cards.first(where: { $0.kind == .term })?.text,
                  let definition = cards.first(where: { $0.kind == .definition })?.text else {
                return nil
            }
            return MatchPairSummary(id: pairId, term: term, definition: definition)
        }
        .sorted { $0.term.localizedCaseInsensitiveCompare($1.term) == .orderedAscending }
    }
}

struct MatchingDeckSelectionView: View {
    private let deckOptions: [MatchDeckOption] = {
        let allCount = TrainingContent.allQuizQuestions.count
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
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
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

private struct MatchPairSummary: Identifiable {
    let id: UUID
    let term: String
    let definition: String
}

private struct MatchMistake: Identifiable {
    let id = UUID()
    let firstText: String
    let firstKind: MatchCardKind
    let secondText: String
    let secondKind: MatchCardKind
}

private extension MatchCardKind {
    var label: String {
        switch self {
        case .term:
            return "Prompt"
        case .definition:
            return "Answer"
        }
    }
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
