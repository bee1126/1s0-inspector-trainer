import SwiftUI

struct MatchingGameView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let deckId: String
    let deckTitle: String

    @State private var termCards: [MatchCard] = []
    @State private var definitionCards: [MatchCard] = []
    @State private var selectedTermId: UUID? = nil
    @State private var selectedDefinitionId: UUID? = nil
    @State private var matchedPairIds: Set<UUID> = []
    @State private var mismatchCardIds: Set<UUID> = []
    @State private var isResolvingMismatch = false
    @State private var mistakeCount = 0
    @State private var rewardSummary: RewardSummary? = nil
    @State private var isComplete = false
    @State private var mistakes: [MatchMistake] = []
    @State private var pairsSnapshot: [MatchPairSummary] = []
    @State private var cardFrames: [UUID: CGRect] = [:]
    @State private var dragState: DragMatchState? = nil

    private var questionPool: [QuizQuestion] {
        TrainingContent.allQuizQuestions(for: progress.selectedRole)
    }

    private var selectedQuestions: [QuizQuestion] {
        if deckId == "all" {
            return questionPool
        }
        return TrainingContent.modules(for: progress.selectedRole).first(where: { $0.id == deckId })?.quiz ?? questionPool
    }

    private var totalPairs: Int {
        pairsSnapshot.count
    }

    private var pairsMatched: Int {
        matchedPairIds.count
    }

    private var desiredPairCount: Int {
        horizontalSizeClass == .regular ? 8 : 6
    }

    private var columnSpacing: CGFloat {
        horizontalSizeClass == .regular ? 20 : 14
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
                Text("\(pairsMatched)/\(totalPairs) matched")
                    .font(AppFont.mono(12))
                    .foregroundColor(Color.white.opacity(0.8))
            }

            Text(deckTitle)
                .font(AppFont.subtitle(18))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Match each prompt to the correct answer. Tap or drag to connect.")
                .font(AppFont.body(13))
                .foregroundColor(Color.white.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollView {
                matchColumns
                    .padding(.top, 4)
            }
            .scrollIndicators(.hidden)
        }
        .padding(AppSpacing.screenPadding)
    }

    private var matchColumns: some View {
        ZStack {
            matchLines

            HStack(alignment: .top, spacing: columnSpacing) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Prompts")
                        .font(AppFont.mono(12))
                        .foregroundColor(Color.white.opacity(0.7))
                    ForEach(termCards) { card in
                        MatchCardView(
                            card: card,
                            isSelected: selectedTermId == card.id,
                            isMatched: matchedPairIds.contains(card.pairId),
                            isMismatched: mismatchCardIds.contains(card.id)
                        )
                        .onTapGesture {
                            handleTap(card)
                        }
                        .gesture(
                            DragGesture(minimumDistance: 8, coordinateSpace: .named("matchGrid"))
                                .onChanged { value in
                                    handleDragChanged(card: card, location: value.location)
                                }
                                .onEnded { value in
                                    handleDragEnded(card: card, location: value.location)
                                }
                        )
                        .animation(.spring(response: 0.25, dampingFraction: 0.8), value: matchedPairIds)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Answers")
                        .font(AppFont.mono(12))
                        .foregroundColor(Color.white.opacity(0.7))
                    ForEach(definitionCards) { card in
                        MatchCardView(
                            card: card,
                            isSelected: selectedDefinitionId == card.id,
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
        .coordinateSpace(name: "matchGrid")
        .onPreferenceChange(CardFramePreferenceKey.self) { value in
            cardFrames = value
        }
    }

    private var matchLines: some View {
        Canvas { context, _ in
            for pairId in matchedPairIds {
                guard let termFrame = frameForTerm(pairId: pairId),
                      let definitionFrame = frameForDefinition(pairId: pairId) else {
                    continue
                }
                let start = CGPoint(x: termFrame.maxX, y: termFrame.midY)
                let end = CGPoint(x: definitionFrame.minX, y: definitionFrame.midY)
                var path = Path()
                path.move(to: start)
                path.addCurve(
                    to: end,
                    control1: CGPoint(x: start.x + 40, y: start.y),
                    control2: CGPoint(x: end.x - 40, y: end.y)
                )
                context.stroke(path, with: .color(AppTheme.safetyGreen.opacity(0.8)), lineWidth: 3)
            }

            if let dragState,
               let termFrame = cardFrames[dragState.termId] {
                let start = CGPoint(x: termFrame.maxX, y: termFrame.midY)
                let end = dragState.location
                var path = Path()
                path.move(to: start)
                path.addCurve(
                    to: end,
                    control1: CGPoint(x: start.x + 40, y: start.y),
                    control2: CGPoint(x: end.x - 20, y: end.y)
                )
                context.stroke(path, with: .color(AppTheme.blue.opacity(0.6)), lineWidth: 2)
            }
        }
    }

    private var resultsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.section) {
                Text("Sprint Complete")
                    .font(AppFont.title(24))
                    .foregroundColor(.white)

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
        if card.kind == .term {
            selectTerm(card)
        } else {
            selectDefinition(card)
        }
    }

    private func selectTerm(_ card: MatchCard) {
        if selectedTermId == card.id {
            selectedTermId = nil
            return
        }
        selectedTermId = card.id
        if let selectedDefinitionId {
            attemptMatch(termId: card.id, definitionId: selectedDefinitionId)
        }
    }

    private func selectDefinition(_ card: MatchCard) {
        if selectedDefinitionId == card.id {
            selectedDefinitionId = nil
            return
        }
        selectedDefinitionId = card.id
        if let selectedTermId {
            attemptMatch(termId: selectedTermId, definitionId: card.id)
        }
    }

    private func handleDragChanged(card: MatchCard, location: CGPoint) {
        guard card.kind == .term else { return }
        guard !isComplete else { return }
        guard !matchedPairIds.contains(card.pairId) else { return }
        guard !isResolvingMismatch else { return }
        selectedTermId = card.id
        dragState = DragMatchState(termId: card.id, location: location)
    }

    private func handleDragEnded(card: MatchCard, location: CGPoint) {
        guard card.kind == .term else { return }
        guard !isComplete else { return }
        dragState = nil
        attemptMatch(termId: card.id, dropLocation: location)
    }

    private func attemptMatch(termId: UUID, dropLocation: CGPoint) {
        guard let target = definitionCards.first(where: { card in
            guard let frame = cardFrames[card.id] else { return false }
            return frame.contains(dropLocation)
        }) else {
            selectedTermId = nil
            return
        }
        attemptMatch(termId: termId, definitionId: target.id)
    }

    private func attemptMatch(termId: UUID, definitionId: UUID) {
        guard let term = termCards.first(where: { $0.id == termId }),
              let definition = definitionCards.first(where: { $0.id == definitionId }) else {
            return
        }
        guard !matchedPairIds.contains(term.pairId),
              !matchedPairIds.contains(definition.pairId) else {
            return
        }

        selectedTermId = nil
        selectedDefinitionId = nil

        if term.pairId == definition.pairId {
            matchedPairIds.insert(term.pairId)
            AppFeedback.correct()
            if pairsMatched == totalPairs {
                finishGame()
            }
        } else {
            mistakeCount += 1
            AppFeedback.incorrect()
            mistakes.append(
                MatchMistake(
                    firstText: term.text,
                    firstKind: term.kind,
                    secondText: definition.text,
                    secondKind: definition.kind
                )
            )
            mismatchCardIds = [term.id, definition.id]
            isResolvingMismatch = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                mismatchCardIds.removeAll()
                isResolvingMismatch = false
            }
        }
    }

    private func finishGame() {
        let score = max(0, pairsMatched - mistakeCount)
        rewardSummary = progress.completePractice(score: score, total: totalPairs)
        isComplete = true
    }

    private func frameForTerm(pairId: UUID) -> CGRect? {
        guard let term = termCards.first(where: { $0.pairId == pairId }) else { return nil }
        return cardFrames[term.id]
    }

    private func frameForDefinition(pairId: UUID) -> CGRect? {
        guard let definition = definitionCards.first(where: { $0.pairId == pairId }) else { return nil }
        return cardFrames[definition.id]
    }

    private func resetGame() {
        let newCards = buildCardSets()
        termCards = newCards.terms
        definitionCards = newCards.definitions
        selectedTermId = nil
        selectedDefinitionId = nil
        matchedPairIds = []
        mismatchCardIds = []
        isResolvingMismatch = false
        mistakeCount = 0
        mistakes = []
        rewardSummary = nil
        isComplete = false
        pairsSnapshot = buildPairSummaries(from: newCards.pairs)
        cardFrames = [:]
        dragState = nil
    }

    private func buildCardSets() -> (terms: [MatchCard], definitions: [MatchCard], pairs: [MatchPair]) {
        let pairs = buildPairs(from: selectedQuestions, count: desiredPairCount)
        let terms = pairs.map { pair in
            MatchCard(id: UUID(), pairId: pair.id, text: pair.term, kind: .term)
        }
        let definitions = pairs.map { pair in
            MatchCard(id: UUID(), pairId: pair.id, text: pair.definition, kind: .definition)
        }
        return (terms.shuffled(), definitions.shuffled(), pairs)
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

    private func buildPairSummaries(from pairs: [MatchPair]) -> [MatchPairSummary] {
        pairs
            .map { MatchPairSummary(id: $0.id, term: $0.term, definition: $0.definition) }
            .sorted { $0.term.localizedCaseInsensitiveCompare($1.term) == .orderedAscending }
    }
}

struct MatchingDeckSelectionView: View {
    @EnvironmentObject private var progress: ProgressStore

    private var modules: [TrainingModule] {
        TrainingContent.modules(for: progress.selectedRole)
    }

    private var deckOptions: [MatchDeckOption] {
        let allCount = TrainingContent.allQuizQuestions(for: progress.selectedRole).count
        var options: [MatchDeckOption] = [
            MatchDeckOption(
                id: "all",
                title: "All Modules",
                detail: "Mix every topic into one sprint.",
                questionCount: allCount
            )
        ]
        options.append(contentsOf: modules.map { module in
            MatchDeckOption(
                id: module.id,
                title: module.title,
                detail: module.subtitle,
                questionCount: module.quiz.count
            )
        })
        return options
    }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text("Match Sprint")
                        .font(AppFont.title(26))
                        .foregroundColor(.white)

                    Text("Choose a module to start a matching sprint.")
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

private struct DragMatchState {
    let termId: UUID
    let location: CGPoint
}

private struct CardFramePreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGRect] = [:]

    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
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
        .background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: CardFramePreferenceKey.self, value: [card.id: proxy.frame(in: .named("matchGrid"))])
            }
        )
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
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
