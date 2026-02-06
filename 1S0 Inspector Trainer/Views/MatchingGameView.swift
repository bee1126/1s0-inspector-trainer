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
                    .foregroundColor(AppTheme.text)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(AppTheme.surface)
                    )
                    .overlay(
                        Capsule().stroke(AppTheme.border, lineWidth: 1)
                    )
                }

                Spacer()
                Text("\(pairsMatched)/\(totalPairs) matched")
                    .font(AppFont.mono(12))
                    .foregroundColor(AppTheme.muted)
            }

            Text(deckTitle)
                .font(AppFont.subtitle(18))
                .foregroundColor(AppTheme.text)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Match each prompt to the correct answer. Tap a prompt, then tap its answer.")
                .font(AppFont.body(13))
                .foregroundColor(AppTheme.muted)
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
                    Text("PROMPTS")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.muted)
                    ForEach(termCards) { card in
                        Button {
                            handleTap(card)
                        } label: {
                            MatchCardView(
                                card: card,
                                isSelected: selectedTermId == card.id,
                                isMatched: matchedPairIds.contains(card.pairId),
                                isMismatched: mismatchCardIds.contains(card.id)
                            )
                        }
                        .buttonStyle(.plain)
                        .animation(.spring(response: 0.25, dampingFraction: 0.8), value: matchedPairIds)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("ANSWERS")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.muted)
                    ForEach(definitionCards) { card in
                        Button {
                            handleTap(card)
                        } label: {
                            MatchCardView(
                                card: card,
                                isSelected: selectedDefinitionId == card.id,
                                isMatched: matchedPairIds.contains(card.pairId),
                                isMismatched: mismatchCardIds.contains(card.id)
                            )
                        }
                        .buttonStyle(.plain)
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
                context.stroke(path, with: .color(AppTheme.primary.opacity(0.8)), lineWidth: 3)
            }

        }
    }

    private var resultsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.section) {
                Text("Sprint Complete")
                    .font(AppFont.title(24))
                    .foregroundColor(AppTheme.text)

                Text("Pairs matched: \(pairsMatched)/\(totalPairs)")
                    .font(AppFont.body(14))
                    .foregroundColor(AppTheme.muted)

                Text("Mistakes: \(mistakeCount)")
                    .font(AppFont.body(14))
                    .foregroundColor(AppTheme.muted)

                if let rewardSummary {
                    RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("PAIRS")
                            .font(AppFont.mono(11))
                            .foregroundColor(AppTheme.muted)

                        ForEach(pairsSnapshot) { pair in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(pair.term)
                                    .font(AppFont.body(14))
                                    .foregroundColor(AppTheme.text)
                                Text(pair.definition)
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("MISTAKES")
                            .font(AppFont.mono(11))
                            .foregroundColor(AppTheme.muted)

                        if mistakes.isEmpty {
                            Text("No mistakes this round.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.muted)
                        } else {
                            ForEach(mistakes) { mistake in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(mistake.firstKind.label): \(mistake.firstText)")
                                        .font(AppFont.body(13))
                                        .foregroundColor(AppTheme.text)
                                    Text("\(mistake.secondKind.label): \(mistake.secondText)")
                                        .font(AppFont.body(13))
                                        .foregroundColor(AppTheme.muted)
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
                    Text("MATCH SPRINT")
                        .font(AppFont.title(26))
                        .foregroundColor(AppTheme.text)

                    Text("Choose a module to start a matching sprint.")
                        .font(AppFont.body(14))
                        .foregroundColor(AppTheme.muted)

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
                        .foregroundColor(AppTheme.text)
                    Spacer()
                    TagPill(text: "\(option.questionCount) Qs")
                }

                Text(option.detail)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.muted)
            }
        }
    }
}

private struct MatchPair: Hashable {
    let id: UUID
    let term: String
    let definition: String
}

// Internal (non-private) so MatchCardView in Components.swift can reference them
struct MatchCard: Identifiable, Hashable {
    let id: UUID
    let pairId: UUID
    let text: String
    let kind: MatchCardKind
}

enum MatchCardKind {
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

// CardFramePreferenceKey is defined in Components.swift

extension MatchCardKind {
    var label: String {
        switch self {
        case .term:
            return "Prompt"
        case .definition:
            return "Answer"
        }
    }
}
