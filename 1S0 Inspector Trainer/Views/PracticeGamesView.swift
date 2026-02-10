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
                    Text("\(sortedCount)/\(totalCount) sorted")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.muted)
                }

                Text("RAC SORT")
                    .font(AppFont.title(26))
                    .foregroundColor(AppTheme.text)

                Text("Drag hazards into the correct Risk Assessment Code bucket.")
                    .font(AppFont.body(14))
                    .foregroundColor(AppTheme.muted)

                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("UNSORTED HAZARDS")
                            .font(AppFont.mono(11))
                            .foregroundColor(AppTheme.muted)

                        if unassigned.isEmpty {
                            Text("All hazards are sorted. Score the run below.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.muted)
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
                    .onDrop(of: [UTType.text], isTargeted: .constant(false)) { providers in
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
                        .foregroundColor(AppTheme.muted)
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
                    .foregroundColor(AppTheme.text)

                Text("Score: \(score)/\(totalCount)")
                    .font(AppFont.body(14))
                    .foregroundColor(AppTheme.muted)

                if let rewardSummary {
                    RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("MISSED HAZARDS")
                            .font(AppFont.mono(11))
                            .foregroundColor(AppTheme.muted)

                        if mistakes.isEmpty {
                            Text("No misses this round.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.muted)
                        } else {
                            ForEach(mistakes) { mistake in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(mistake.hazard.title)
                                        .font(AppFont.body(13))
                                        .foregroundColor(AppTheme.text)
                                    Text("Placed: \(mistake.selected.rawValue) • Correct: \(mistake.hazard.rac.rawValue)")
                                        .font(AppFont.body(12))
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

    private var totalCount: Int { PracticeContent.racHazards.count }
    private var sortedCount: Int { totalCount - unassigned.count }
    private var isReadyToScore: Bool { unassigned.isEmpty }

    private var hazardColumns: [GridItem] {
        [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    }

    private func tint(for category: RacCategory) -> Color {
        switch category {
        case .rac1:
            return AppTheme.danger
        case .rac2:
            return AppTheme.accent
        case .rac3:
            return AppTheme.info
        case .rac4:
            return AppTheme.primary.opacity(0.3)
        }
    }

    private func handleDrop(providers: [NSItemProvider], to category: RacCategory?) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadObject(ofClass: NSString.self) { object, _ in
            guard let idString = object as? NSString else { return }
            DispatchQueue.main.async {
                moveHazard(withId: idString as String, to: category)
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
                .foregroundColor(AppTheme.text)
            Text(hazard.detail)
                .font(AppFont.body(12))
                .foregroundColor(AppTheme.muted)
                .lineLimit(compact ? 2 : 3)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(AppTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(AppTheme.border, lineWidth: 1)
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
                    .foregroundColor(AppTheme.text)
                Text(category.severity)
                    .font(AppFont.mono(11))
                    .foregroundColor(tint)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(tint.opacity(0.15)))
            }

            Text(category.description)
                .font(AppFont.body(12))
                .foregroundColor(AppTheme.muted)

            if hazards.isEmpty {
                Text("Drop hazards here")
                    .font(AppFont.body(12))
                    .foregroundColor(AppTheme.muted)
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
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(AppTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(isTargeted ? tint.opacity(0.9) : AppTheme.border, lineWidth: isTargeted ? 2 : 1)
        )
        .onDrop(of: [UTType.text], isTargeted: $isTargeted, perform: onDrop)
    }
}

// MARK: - Procedure Drill

struct ProcedureDrillLobbyView: View {
    @EnvironmentObject private var progress: ProgressStore

    @State private var resumableRun: ProcedureDrillRunState? = nil
    @State private var launchRun: ProcedureDrillRunState? = nil
    @State private var navigateToRun = false

    private var procedures: [ProcedureSet] { PracticeContent.procedureSets(for: progress.selectedRole) }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text("PROCEDURE DRILL")
                        .font(AppFont.title(26))
                        .foregroundColor(AppTheme.text)

                    Text("Run a 3-round mission. Use checkpoints for hints, then submit each round for final scoring.")
                        .font(AppFont.body(14))
                        .foregroundColor(AppTheme.muted)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("MISSION BRIEF")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                            Text("Each run pulls 3 random procedures for your role. You get up to 3 checkpoints per round before auto-submit.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.text)
                            Text("Scoring: exact placements minus failed checkpoints.")
                                .font(AppFont.body(12))
                                .foregroundColor(AppTheme.muted)
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(procedures) { procedure in
                            ProcedureSetCard(procedure: procedure)
                        }
                    }

                    Button("Start 3-Round Run") {
                        startNewRun()
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    if let resumableRun {
                        Button("Resume Run (Round \(resumableRun.currentRoundIndex + 1))") {
                            launchRun = resumableRun
                            navigateToRun = true
                        }
                        .buttonStyle(OutlineButtonStyle())

                        Button("Restart Run") {
                            startNewRun()
                        }
                        .buttonStyle(OutlineButtonStyle())
                    }

                    if procedures.count < 3 {
                        Text("Add at least 3 procedure sets to run this mode.")
                            .font(AppFont.body(12))
                            .foregroundColor(AppTheme.muted)
                    }
                }
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)

        }
        .navigationTitle("Procedure Drill")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToRun) {
            if let launchRun {
                ProcedureDrillRunView(initialRun: launchRun)
            }
        }
        .onAppear {
            progress.refreshForNewDayIfNeeded()
            refreshResumableRun()
        }
        .onChange(of: progress.selectedRole) { _ in
            refreshResumableRun()
        }
    }

    private func refreshResumableRun() {
        guard var saved = progress.procedureDrillRun(for: progress.selectedRole) else {
            resumableRun = nil
            return
        }

        guard let firstIncomplete = saved.rounds.firstIndex(where: { !$0.isComplete }) else {
            progress.clearProcedureDrillRun(for: progress.selectedRole)
            resumableRun = nil
            return
        }

        if saved.currentRoundIndex != firstIncomplete {
            saved.currentRoundIndex = firstIncomplete
            progress.saveProcedureDrillRun(saved, for: progress.selectedRole)
        }
        resumableRun = saved
    }

    private func startNewRun() {
        guard let run = buildRun() else { return }
        progress.saveProcedureDrillRun(run, for: progress.selectedRole)
        resumableRun = run
        launchRun = run
        navigateToRun = true
    }

    private func buildRun() -> ProcedureDrillRunState? {
        guard procedures.count >= 3 else { return nil }
        let selectedSets = Array(procedures.shuffled().prefix(3))
        let now = Date()
        let rounds = selectedSets.map { procedure in
            ProcedureDrillRoundState(
                setId: procedure.id,
                currentOrder: Array(procedure.steps.indices).shuffled(),
                failedChecks: 0,
                finalCorrectPlacements: nil,
                finalScore: nil,
                didAutoSubmit: false,
                isComplete: false
            )
        }
        return ProcedureDrillRunState(
            roundSetIds: selectedSets.map(\.id),
            rounds: rounds,
            currentRoundIndex: 0,
            startedAt: now,
            updatedAt: now
        )
    }
}

struct ProcedureDrillRunView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss

    let initialRun: ProcedureDrillRunState

    @State private var run: ProcedureDrillRunState
    @State private var checkpointCorrectPositions: Set<Int> = []
    @State private var checkpointIncorrectPositions: Set<Int> = []
    @State private var checkpointMessage: String? = nil
    @State private var replayRoundIndex: Int? = nil
    @State private var replayHighlightIndex: Int = -1
    @State private var replayComplete = false
    @State private var replayTask: Task<Void, Never>? = nil
    @State private var rewardSummary: RewardSummary? = nil
    @State private var runResult: AssessmentResult? = nil

    private let maxChecks = 3

    init(initialRun: ProcedureDrillRunState) {
        self.initialRun = initialRun
        _run = State(initialValue: initialRun)
    }

    private var procedureLookup: [String: ProcedureSet] {
        Dictionary(uniqueKeysWithValues: PracticeContent.procedureSets(for: progress.selectedRole).map { ($0.id, $0) })
    }

    private var currentRound: ProcedureDrillRoundState? {
        guard run.currentRoundIndex >= 0, run.currentRoundIndex < run.rounds.count else { return nil }
        return run.rounds[run.currentRoundIndex]
    }

    private var currentProcedure: ProcedureSet? {
        guard let currentRound else { return nil }
        return procedureLookup[currentRound.setId]
    }

    var body: some View {
        ZStack {
            BackgroundView()

            if let runResult {
                resultsView(result: runResult)
            } else if let replayRoundIndex,
                      replayRoundIndex < run.rounds.count,
                      let procedure = procedureLookup[run.rounds[replayRoundIndex].setId] {
                replayView(
                    round: run.rounds[replayRoundIndex],
                    procedure: procedure,
                    roundNumber: replayRoundIndex + 1
                )
            } else if let currentRound,
                      let currentProcedure {
                activeRoundView(round: currentRound, procedure: currentProcedure)
            } else {
                unavailableView
            }
        }
        .navigationTitle("Procedure Drill")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            bootstrapRun()
        }
        .onDisappear {
            replayTask?.cancel()
            replayTask = nil
        }
    }

    private func bootstrapRun() {
        progress.refreshForNewDayIfNeeded()
        let source = progress.procedureDrillRun(for: progress.selectedRole) ?? initialRun
        let normalized = normalizeRun(source)
        run = normalized

        if let firstIncomplete = normalized.rounds.firstIndex(where: { !$0.isComplete }) {
            if normalized.currentRoundIndex != firstIncomplete {
                run.currentRoundIndex = firstIncomplete
            }
            progress.saveProcedureDrillRun(run, for: progress.selectedRole)
            clearCheckpointFeedback()
            return
        }

        runResult = aggregateResult(for: normalized)
        progress.clearProcedureDrillRun(for: progress.selectedRole)
    }

    private func normalizeRun(_ source: ProcedureDrillRunState) -> ProcedureDrillRunState {
        var normalized = source

        for index in normalized.rounds.indices {
            guard let procedure = procedureLookup[normalized.rounds[index].setId] else { continue }
            let expectedOrder = Array(procedure.steps.indices)
            if normalized.rounds[index].currentOrder.sorted() != expectedOrder {
                normalized.rounds[index].currentOrder = expectedOrder.shuffled()
                normalized.rounds[index].failedChecks = 0
                normalized.rounds[index].finalCorrectPlacements = nil
                normalized.rounds[index].finalScore = nil
                normalized.rounds[index].didAutoSubmit = false
                normalized.rounds[index].isComplete = false
            }
        }

        if let firstIncomplete = normalized.rounds.firstIndex(where: { !$0.isComplete }) {
            normalized.currentRoundIndex = firstIncomplete
        } else {
            normalized.currentRoundIndex = normalized.rounds.count
        }
        return normalized
    }

    private func activeRoundView(round: ProcedureDrillRoundState, procedure: ProcedureSet) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.section) {
                HStack {
                    Text("ROUND \(run.currentRoundIndex + 1)/\(run.rounds.count)")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.info)
                    Spacer()
                    HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, compact: true, onDark: true)
                }

                Text(procedure.title)
                    .font(AppFont.title(24))
                    .foregroundColor(AppTheme.text)

                Text(procedure.detail)
                    .font(AppFont.body(14))
                    .foregroundColor(AppTheme.muted)

                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("DRAG TO REORDER")
                            .font(AppFont.mono(11))
                            .foregroundColor(AppTheme.muted)

                        List {
                            ForEach(Array(round.currentOrder.enumerated()), id: \.element) { position, stepIndex in
                                ProcedureDrillRow(
                                    index: position,
                                    text: procedure.steps[stepIndex],
                                    marker: markerForCheckpoint(position: position)
                                )
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            .onMove(perform: moveCurrentRound)
                        }
                        .frame(height: listHeight(for: procedure.steps.count))
                        .scrollContentBackground(.hidden)
                        .environment(\.editMode, .constant(.active))
                        .listStyle(.plain)
                    }
                }

                Text("Checkpoint attempts used: \(round.failedChecks)/\(maxChecks)")
                    .font(AppFont.body(12))
                    .foregroundColor(AppTheme.muted)

                if let checkpointMessage {
                    Text(checkpointMessage)
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.text)
                }

                Button("Checkpoint (\(max(0, maxChecks - round.failedChecks)) left)") {
                    runCheckpoint(round: round, procedure: procedure)
                }
                .buttonStyle(OutlineButtonStyle())
                .disabled(round.failedChecks >= maxChecks)

                Button("Submit Round") {
                    finalizeCurrentRound(autoSubmitted: false, procedure: procedure)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(AppSpacing.screenPadding)
        }
        .scrollIndicators(.hidden)
    }

    private func replayView(round: ProcedureDrillRoundState, procedure: ProcedureSet, roundNumber: Int) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.section) {
                Text("Round \(roundNumber) Replay")
                    .font(AppFont.title(24))
                    .foregroundColor(AppTheme.text)

                Text("Review the correct order. Positions highlight one at a time.")
                    .font(AppFont.body(14))
                    .foregroundColor(AppTheme.muted)

                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        List {
                            ForEach(Array(round.currentOrder.enumerated()), id: \.element) { position, stepIndex in
                                ProcedureDrillRow(
                                    index: position,
                                    text: procedure.steps[stepIndex],
                                    marker: markerForReplay(position: position)
                                )
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                        }
                        .frame(height: listHeight(for: procedure.steps.count))
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)

                        if replayHighlightIndex >= 0, replayHighlightIndex < procedure.steps.count {
                            Text("Position \(replayHighlightIndex + 1): \(procedure.steps[replayHighlightIndex])")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.info)
                        }
                    }
                }

                if replayComplete {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ROUND SUMMARY")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)

                            Text("Correct placements: \(round.finalCorrectPlacements ?? 0)/\(procedure.steps.count)")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.text)

                            Text("Failed checkpoints: \(round.failedChecks)")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.text)

                            Text("Round score: \(round.finalScore ?? 0)/\(procedure.steps.count)")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.text)

                            if round.didAutoSubmit {
                                Text("Auto-submitted after 3 failed checkpoints.")
                                    .font(AppFont.body(12))
                                    .foregroundColor(AppTheme.muted)
                            }
                        }
                    }

                    Button(roundNumber == run.rounds.count ? "Finish Run" : "Continue to Round \(roundNumber + 1)") {
                        advanceAfterReplay()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                } else {
                    Button("Skip Replay") {
                        skipReplay(stepCount: procedure.steps.count)
                    }
                    .buttonStyle(OutlineButtonStyle())
                }
            }
            .padding(AppSpacing.screenPadding)
        }
        .scrollIndicators(.hidden)
    }

    private func resultsView(result: AssessmentResult) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.section) {
                Text("Procedure Drill Complete")
                    .font(AppFont.title(24))
                    .foregroundColor(AppTheme.text)

                Text("Mission score: \(result.score)/\(result.total)")
                    .font(AppFont.body(14))
                    .foregroundColor(AppTheme.muted)

                if let rewardSummary {
                    RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ROUND BREAKDOWN")
                            .font(AppFont.mono(11))
                            .foregroundColor(AppTheme.muted)

                        ForEach(Array(run.rounds.enumerated()), id: \.offset) { roundIndex, round in
                            if let procedure = procedureLookup[round.setId] {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Round \(roundIndex + 1): \(procedure.title)")
                                        .font(AppFont.body(13))
                                        .foregroundColor(AppTheme.text)
                                    Text("Score \(round.finalScore ?? 0)/\(procedure.steps.count) • \(round.failedChecks) failed checkpoints")
                                        .font(AppFont.body(12))
                                        .foregroundColor(AppTheme.muted)
                                }
                            }
                        }
                    }
                }

                Button("Back to Procedure Drill") {
                    dismiss()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(AppSpacing.screenPadding)
        }
        .scrollIndicators(.hidden)
    }

    private var unavailableView: some View {
        ScrollView {
            GlassCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Run unavailable")
                        .font(AppFont.subtitle(18))
                        .foregroundColor(AppTheme.text)
                    Text("Procedure data changed. Start a new run from the briefing.")
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.muted)
                    Button("Back") {
                        dismiss()
                    }
                    .buttonStyle(OutlineButtonStyle())
                }
            }
            .padding(AppSpacing.screenPadding)
        }
        .scrollIndicators(.hidden)
    }

    private func listHeight(for stepCount: Int) -> CGFloat {
        let rowHeight: CGFloat = 70
        let maxHeight: CGFloat = 420
        return min(maxHeight, CGFloat(stepCount) * rowHeight)
    }

    private func markerForCheckpoint(position: Int) -> ProcedureRowMarker {
        if checkpointIncorrectPositions.contains(position) { return .incorrect }
        if checkpointCorrectPositions.contains(position) { return .correct }
        return .neutral
    }

    private func markerForReplay(position: Int) -> ProcedureRowMarker {
        guard replayHighlightIndex >= 0, position <= replayHighlightIndex else { return .neutral }
        return .replay
    }

    private func moveCurrentRound(from source: IndexSet, to destination: Int) {
        guard let _ = currentRound else { return }
        run.rounds[run.currentRoundIndex].currentOrder.move(fromOffsets: source, toOffset: destination)
        clearCheckpointFeedback()
        progress.saveProcedureDrillRun(run, for: progress.selectedRole)
    }

    private func runCheckpoint(round: ProcedureDrillRoundState, procedure: ProcedureSet) {
        let correctPositions = correctPositions(for: round.currentOrder)
        let totalSteps = procedure.steps.count
        checkpointCorrectPositions = correctPositions
        checkpointIncorrectPositions = Set(0..<totalSteps).subtracting(correctPositions)

        if correctPositions.count == totalSteps {
            checkpointMessage = "All positions are correct. Submit round when ready."
            AppFeedback.correct()
            return
        }

        run.rounds[run.currentRoundIndex].failedChecks += 1
        let failedChecks = run.rounds[run.currentRoundIndex].failedChecks
        checkpointMessage = "\(correctPositions.count)/\(totalSteps) positions correct."
        AppFeedback.incorrect()

        if failedChecks >= maxChecks {
            checkpointMessage = "Checkpoint limit reached. Auto-submitting round."
            finalizeCurrentRound(autoSubmitted: true, procedure: procedure)
            return
        }

        progress.saveProcedureDrillRun(run, for: progress.selectedRole)
    }

    private func finalizeCurrentRound(autoSubmitted: Bool, procedure: ProcedureSet) {
        guard var round = currentRound else { return }
        let correctCount = correctPositions(for: round.currentOrder).count
        let finalScore = ProcedureDrillScoring.roundScore(
            correctPlacements: correctCount,
            failedChecks: round.failedChecks,
            totalSteps: procedure.steps.count
        )

        round.finalCorrectPlacements = correctCount
        round.finalScore = finalScore
        round.didAutoSubmit = autoSubmitted
        round.isComplete = true

        run.rounds[run.currentRoundIndex] = round
        progress.saveProcedureDrillRun(run, for: progress.selectedRole)

        startReplay(roundIndex: run.currentRoundIndex, stepCount: procedure.steps.count)
    }

    private func correctPositions(for order: [Int]) -> Set<Int> {
        Set(order.enumerated().compactMap { index, stepIndex in
            stepIndex == index ? index : nil
        })
    }

    private func startReplay(roundIndex: Int, stepCount: Int) {
        replayTask?.cancel()
        replayRoundIndex = roundIndex
        replayHighlightIndex = -1
        replayComplete = false
        clearCheckpointFeedback()

        replayTask = Task {
            for index in 0..<stepCount {
                if Task.isCancelled { return }
                try? await Task.sleep(nanoseconds: 600_000_000)
                await MainActor.run {
                    replayHighlightIndex = index
                }
            }
            await MainActor.run {
                replayComplete = true
                replayTask = nil
            }
        }
    }

    private func skipReplay(stepCount: Int) {
        replayTask?.cancel()
        replayTask = nil
        replayHighlightIndex = stepCount > 0 ? stepCount - 1 : -1
        replayComplete = true
    }

    private func advanceAfterReplay() {
        replayTask?.cancel()
        replayTask = nil
        replayRoundIndex = nil
        replayHighlightIndex = -1
        replayComplete = false
        clearCheckpointFeedback()

        if run.currentRoundIndex < run.rounds.count - 1 {
            run.currentRoundIndex += 1
            progress.saveProcedureDrillRun(run, for: progress.selectedRole)
            return
        }

        let result = aggregateResult(for: run)
        runResult = result
        rewardSummary = progress.completePractice(score: result.score, total: result.total)
        progress.clearProcedureDrillRun(for: progress.selectedRole)
    }

    private func aggregateResult(for run: ProcedureDrillRunState) -> AssessmentResult {
        let outcomes = run.rounds.compactMap { round -> ProcedureDrillRoundOutcome? in
            guard let procedure = procedureLookup[round.setId] else { return nil }
            let correct = round.finalCorrectPlacements ?? correctPositions(for: round.currentOrder).count
            return ProcedureDrillRoundOutcome(
                correctPlacements: correct,
                failedChecks: round.failedChecks,
                totalSteps: procedure.steps.count
            )
        }
        return ProcedureDrillScoring.aggregateScore(rounds: outcomes)
    }

    private func clearCheckpointFeedback() {
        checkpointCorrectPositions = []
        checkpointIncorrectPositions = []
        checkpointMessage = nil
    }
}

private enum ProcedureRowMarker {
    case neutral
    case correct
    case incorrect
    case replay
}

private struct ProcedureDrillRow: View {
    let index: Int
    let text: String
    let marker: ProcedureRowMarker

    private var markerColor: Color {
        switch marker {
        case .neutral:
            return AppTheme.border
        case .correct:
            return AppTheme.primary
        case .incorrect:
            return AppTheme.danger
        case .replay:
            return AppTheme.info
        }
    }

    private var markerIcon: String? {
        switch marker {
        case .neutral:
            return nil
        case .correct:
            return "checkmark.circle.fill"
        case .incorrect:
            return "xmark.circle.fill"
        case .replay:
            return "play.circle.fill"
        }
    }

    private var borderWidth: CGFloat {
        switch marker {
        case .neutral:
            return 1
        case .correct, .incorrect, .replay:
            return 2
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(index + 1)")
                .font(AppFont.mono(12))
                .foregroundColor(AppTheme.info)
                .frame(width: 24, alignment: .leading)

            Text(text)
                .font(AppFont.body(13))
                .foregroundColor(AppTheme.text)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            if let markerIcon {
                Image(systemName: markerIcon)
                    .foregroundColor(markerColor)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(AppTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(markerColor, lineWidth: borderWidth)
        )
    }
}

private struct ProcedureSetCard: View {
    let procedure: ProcedureSet

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 6) {
                Text(procedure.title)
                    .font(AppFont.subtitle(17))
                    .foregroundColor(AppTheme.text)
                Text(procedure.detail)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.muted)
                Text("\(procedure.steps.count) steps")
                    .font(AppFont.mono(11))
                    .foregroundColor(AppTheme.info)
            }
        }
    }
}

// MARK: - True/False Blitz

struct TrueFalseBlitzView: View {
    @EnvironmentObject private var progress: ProgressStore
    @EnvironmentObject private var adaptiveManager: AdaptiveDifficultyManager

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
                            .foregroundColor(AppTheme.text)
                        Text("Add more True/False questions to run a blitz.")
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.muted)
                    } else {
                        let question = questions[index]

                        HStack {
                            Text("BLITZ")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.muted)
                            Spacer()
                            HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, compact: true, onDark: true)
                            Text("\(index + 1)/\(questions.count)")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.muted)
                        }

                        HStack {
                            Text("TIME")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.muted)
                            Text("\(timeLeft)s")
                                .font(AppFont.subtitle(14))
                                .foregroundColor(timeLeft <= 3 ? AppTheme.danger : AppTheme.text)
                            Spacer()
                            Toggle("Time Pressure", isOn: $timerActive)
                                .labelsHidden()
                                .tint(AppTheme.info)
                        }

                        Text(question.statement)
                            .font(AppFont.subtitle(18))
                            .foregroundColor(AppTheme.text)

                        VStack(spacing: 10) {
                            Button {
                                answer(true)
                            } label: {
                                OptionRow(
                                    text: "True",
                                    isSelected: selectedAnswer == true,
                                    isCorrect: question.answer,
                                    isLocked: selectedAnswer != nil,
                                    revealCorrect: true
                                )
                            }
                            .buttonStyle(.plain)

                            Button {
                                answer(false)
                            } label: {
                                OptionRow(
                                    text: "False",
                                    isSelected: selectedAnswer == false,
                                    isCorrect: !question.answer,
                                    isLocked: selectedAnswer != nil,
                                    revealCorrect: true
                                )
                            }
                            .buttonStyle(.plain)
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
                    .foregroundColor(AppTheme.text)

                Text("Score: \(correctCount)/\(questions.count)")
                    .font(AppFont.body(14))
                    .foregroundColor(AppTheme.muted)

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
        let questionPool = PracticeContent.trueFalseQuestions(for: progress.selectedRole)
        let count = min(10, questionPool.count)
        questions = Array(questionPool.shuffled().prefix(count))
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
            adaptiveManager.recordCorrect()
            AppFeedback.correct()
        } else {
            adaptiveManager.recordWrong()
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
        adaptiveManager.recordWrong()
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

    private var topics: [MicroDrillTopic] { PracticeContent.microDrillTopics(for: progress.selectedRole) }
    private var modules: [TrainingModule] { TrainingContent.modules(for: progress.selectedRole) }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    Text("MICRO-DRILLS")
                        .font(AppFont.title(26))
                        .foregroundColor(AppTheme.text)

                    Text("Short, role-specific drills focused on a single topic.")
                        .font(AppFont.body(14))
                        .foregroundColor(AppTheme.muted)

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
                                .foregroundColor(AppTheme.text)

                            Text("Score: \(result.score)/\(result.total)")
                                .font(AppFont.subtitle(16))
                                .foregroundColor(AppTheme.text)

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
                                .foregroundColor(AppTheme.text)
                            Text("This drill needs more questions. Try another topic.")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.muted)
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
                        .foregroundColor(AppTheme.text)
                    Spacer()
                    TagPill(text: "\(questionCount) Qs")
                }
                Text(topic.detail)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.muted)
            }
        }
    }
}

// MARK: - Onboarding Path

struct OnboardingPathView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var rewardSummary: RewardSummary? = nil
    @State private var showRestartAlert = false

    private var days: [OnboardingDay] { PracticeContent.onboardingDays(for: progress.selectedRole) }
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
                    Text("STARTER PROGRAM")
                        .font(AppFont.title(26))
                        .foregroundColor(AppTheme.text)

                    if progress.onboardingStartDate == nil {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("7-Day Starter Path")
                                    .font(AppFont.subtitle(18))
                                    .foregroundColor(AppTheme.text)
                                Text("Complete one short check-in each day to build momentum.")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)
                                Button("Start Program") {
                                    progress.startOnboardingIfNeeded()
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            }
                        }
                    } else {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("PROGRESS")
                                    .font(AppFont.mono(11))
                                    .foregroundColor(AppTheme.muted)

                                ProgressView(value: progressValue)
                                    .tint(AppTheme.primary)

                                Text("\(completedCount)/\(totalDays) check-ins")
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)

                                if let dayNumber = currentDayNumber {
                                    Text("Day \(dayNumber) of \(totalDays)")
                                        .font(AppFont.subtitle(15))
                                        .foregroundColor(AppTheme.info)
                                }

                                if canCheckIn, let dayNumber = currentDayNumber {
                                    Button("Check in for Day \(dayNumber)") {
                                        rewardSummary = progress.checkInOnboardingDay()
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                } else {
                                    Text("Check-in complete for today.")
                                        .font(AppFont.body(12))
                                        .foregroundColor(AppTheme.muted)
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
                                        .foregroundColor(AppTheme.info)
                                    if isComplete {
                                        Text("Complete")
                                            .font(AppFont.mono(11))
                                            .foregroundColor(AppTheme.primary)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Capsule().fill(AppTheme.primary.opacity(0.15)))
                                    } else if isCurrent {
                                        Text("Today")
                                            .font(AppFont.mono(11))
                                            .foregroundColor(AppTheme.accent)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Capsule().fill(AppTheme.accent.opacity(0.2)))
                                    }
                                    Spacer()
                                }

                                Text(day.title)
                                    .font(AppFont.subtitle(17))
                                    .foregroundColor(AppTheme.text)

                                Text(day.summary)
                                    .font(AppFont.body(13))
                                    .foregroundColor(AppTheme.muted)

                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(day.tasks, id: \.self) { task in
                                        Text("• \(task)")
                                            .font(AppFont.body(12))
                                            .foregroundColor(AppTheme.muted)
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
        case .procedureDrill:
            ProcedureDrillLobbyView()
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
        case .procedureDrill:
            return "Open Procedure Drill"
        case .trueFalseBlitz:
            return "Start True/False Blitz"
        case .microDrill:
            return "Start Micro-Drill"
        }
    }
}
