import SwiftUI

struct PPELoadoutView: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var phase: GamePhase = .picker
    @State private var scenario: PPEScenario = PPELoadoutBank.allScenarios[0]
    @State private var selectedIds: Set<String> = []
    @State private var rewardSummary: RewardSummary? = nil

    private enum GamePhase {
        case picker
        case briefing
        case selection
        case debrief
        case rewards
    }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(spacing: AppSpacing.section) {
                    header

                    switch phase {
                    case .picker:
                        scenarioPickerView
                    case .briefing:
                        briefingView
                    case .selection:
                        selectionView
                    case .debrief:
                        debriefView
                    case .rewards:
                        rewardsView
                    }
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("PPE Loadout")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(phase != .picker)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if phase != .picker {
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
    }

    // MARK: - Back Navigation

    private func goBack() {
        switch phase {
        case .picker:
            dismiss()
        case .briefing:
            transition(to: .picker)
        case .selection:
            transition(to: .briefing)
        case .debrief:
            transition(to: .selection)
        case .rewards:
            transition(to: .picker)
            selectedIds = []
            rewardSummary = nil
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

    // MARK: - Scenario Picker

    private var scenarioPickerView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.stack) {
            if progress.allPPEScenariosCompleted {
                GlassCard(glow: AppTheme.primary.opacity(0.5)) {
                    HStack(spacing: 10) {
                        Image(systemName: "medal.fill")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(AppTheme.accent)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PPE SPECIALIST")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.accent)
                                .tracking(1)
                            Text("All scenarios completed. Badge earned!")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.text)
                        }
                        Spacer()
                    }
                }
            } else {
                GlassCard {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Select a scenario to gear up for. Complete all \(PPELoadoutBank.allScenarios.count) to earn the PPE Specialist badge.")
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.muted)
                        HStack(spacing: 4) {
                            Text("\(progress.completedPPEScenarios.count)/\(PPELoadoutBank.allScenarios.count)")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.text)
                            Text("completed")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.muted)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(AppTheme.border)
                                    .frame(height: 6)
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(AppTheme.primary)
                                    .frame(width: geo.size.width * ppeProgress, height: 6)
                                    .shadow(color: AppTheme.primary.opacity(0.4), radius: 4, x: 0, y: 0)
                            }
                        }
                        .frame(height: 6)
                    }
                }
            }

            ForEach(PPELoadoutBank.allScenarios, id: \.id) { s in
                Button {
                    scenario = s
                    selectedIds = []
                    rewardSummary = nil
                    transition(to: .briefing)
                } label: {
                    scenarioRow(s)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func scenarioRow(_ s: PPEScenario) -> some View {
        let isCompleted = progress.completedPPEScenarios.contains(s.id)
        return GlassCard(glow: isCompleted ? AppTheme.primary.opacity(0.2) : .clear) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(s.title)
                        .font(AppFont.subtitle(14))
                        .foregroundColor(AppTheme.text)
                    Text(s.location)
                        .font(AppFont.mono(11))
                        .foregroundColor(AppTheme.info)
                    HStack(spacing: 4) {
                        ForEach(s.hazards.prefix(2), id: \.self) { hazard in
                            Text(hazard)
                                .font(AppFont.mono(9))
                                .foregroundColor(AppTheme.danger.opacity(0.8))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule().fill(AppTheme.danger.opacity(0.1))
                                )
                        }
                        if s.hazards.count > 2 {
                            Text("+\(s.hazards.count - 2)")
                                .font(AppFont.mono(9))
                                .foregroundColor(AppTheme.muted)
                        }
                    }
                }
                Spacer()
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(AppTheme.primary)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppTheme.muted)
                }
            }
        }
    }

    private var ppeProgress: Double {
        let total = PPELoadoutBank.allScenarios.count
        guard total > 0 else { return 0 }
        return Double(progress.completedPPEScenarios.count) / Double(total)
    }

    // MARK: - Briefing

    private var briefingView: some View {
        GlassCard(glow: AppTheme.accent.opacity(0.4)) {
            VStack(alignment: .leading, spacing: AppSpacing.stack) {
                HStack(spacing: 8) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.accent)
                    Text("MISSION BRIEFING")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.accent)
                }

                Text(scenario.title)
                    .font(AppFont.title(22))
                    .foregroundColor(AppTheme.text)

                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.info)
                    Text(scenario.location)
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.info)
                }

                Text(scenario.description)
                    .font(AppFont.body(14))
                    .foregroundColor(AppTheme.text)
                    .fixedSize(horizontal: false, vertical: true)

                hazardsList

                Text("Select the correct PPE for this scenario. Choosing unnecessary equipment will cost you points.")
                    .font(AppFont.body(12))
                    .foregroundColor(AppTheme.muted)

                Button {
                    transition(to: .selection)
                } label: {
                    HStack {
                        Text("Gear Up")
                        Spacer()
                        Image(systemName: "shield.checkered")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .accessibilityElement(children: .combine)
    }

    // MARK: - Hazards (reusable)

    private var hazardsList: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("IDENTIFIED HAZARDS")
                .font(AppFont.mono(10))
                .foregroundColor(AppTheme.danger)
                .tracking(1)

            ForEach(scenario.hazards, id: \.self) { hazard in
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(AppTheme.danger)
                    Text(hazard)
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.text)
                }
            }
        }
    }

    // MARK: - Selection

    private var selectionView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.stack) {
            GlassCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text(scenario.title)
                        .font(AppFont.subtitle(15))
                        .foregroundColor(AppTheme.text)

                    hazardsList

                    Rectangle()
                        .fill(AppTheme.border)
                        .frame(height: 1)

                    HStack {
                        Text("Tap items to add to your loadout.")
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.muted)
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.primary)
                            Text("\(selectedIds.count) selected")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.text)
                        }
                    }
                }
            }

            let columns = [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10),
            ]

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(availableItems, id: \.id) { item in
                    PPEItemCard(
                        item: item,
                        isSelected: selectedIds.contains(item.id)
                    ) {
                        toggleItem(item.id)
                    }
                }
            }

            Button {
                transition(to: .debrief)
            } label: {
                HStack {
                    Text("Submit Loadout")
                    Spacer()
                    Image(systemName: "checkmark.shield.fill")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    // MARK: - Debrief

    private var debriefView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.stack) {
            GlassCard(glow: scoreColor.opacity(0.4)) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "clipboard.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(scoreColor)
                        Text("DEBRIEF")
                            .font(AppFont.mono(12))
                            .foregroundColor(scoreColor)
                    }
                    Text(scenario.title)
                        .font(AppFont.subtitle(15))
                        .foregroundColor(AppTheme.text)
                    HStack(spacing: 12) {
                        Text("Score: \(scorePercent)%")
                            .font(AppFont.mono(16))
                            .foregroundColor(scoreColor)
                        Text("\(correctSelections)/\(scenario.requiredItemIds.count) correct")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.muted)
                    }
                }
            }

            if !missedItems.isEmpty {
                sectionLabel("MISSED \u{2014} Required but not selected", color: AppTheme.danger)
                ForEach(missedItems, id: \.id) { item in
                    debriefItemCard(item: item, status: .missed)
                }
            }

            if !correctItems.isEmpty {
                sectionLabel("CORRECT \u{2014} Required and selected", color: AppTheme.primary)
                ForEach(correctItems, id: \.id) { item in
                    debriefItemCard(item: item, status: .correct)
                }
            }

            if !unnecessaryItems.isEmpty {
                sectionLabel("UNNECESSARY \u{2014} Selected but not required", color: AppTheme.accent)
                ForEach(unnecessaryItems, id: \.id) { item in
                    debriefItemCard(item: item, status: .unnecessary)
                }
            }

            Button {
                submitScore()
                transition(to: .rewards)
            } label: {
                HStack {
                    Text("Continue")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    // MARK: - Rewards

    private var rewardsView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.stack) {
            GlassCard(glow: AppTheme.primary.opacity(0.4)) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppTheme.accent)
                        Text("MISSION COMPLETE")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.accent)
                    }

                    Text(scenario.title)
                        .font(AppFont.subtitle(15))
                        .foregroundColor(AppTheme.text)

                    HStack(spacing: 12) {
                        ScoreBadge(score: scorePercent)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(scoreMessage)
                                .font(AppFont.body(14))
                                .foregroundColor(AppTheme.text)
                            Text("\(correctSelections)/\(scenario.requiredItemIds.count) correct picks")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.muted)
                            if unnecessaryCount > 0 {
                                Text("\(unnecessaryCount) unnecessary pick\(unnecessaryCount == 1 ? "" : "s")")
                                    .font(AppFont.mono(11))
                                    .foregroundColor(AppTheme.accent)
                            }
                        }
                    }
                }
            }

            if let rewardSummary {
                RewardSummaryCard(summary: rewardSummary, xpToNextLevel: progress.xpToNextLevel)
            }

            if progress.allPPEScenariosCompleted && !hadBadgeBefore {
                GlassCard(glow: AppTheme.accent.opacity(0.6)) {
                    HStack(spacing: 10) {
                        Image(systemName: "medal.fill")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(AppTheme.accent)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("BADGE EARNED!")
                                .font(AppFont.mono(12))
                                .foregroundColor(AppTheme.accent)
                                .tracking(1)
                            Text("PPE Specialist \u{2014} All scenarios completed")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.text)
                        }
                        Spacer()
                    }
                }
            }

            Button {
                transition(to: .picker)
                selectedIds = []
                rewardSummary = nil
            } label: {
                HStack {
                    Text("Choose Another Scenario")
                    Spacer()
                    Image(systemName: "list.bullet")
                }
            }
            .buttonStyle(PrimaryButtonStyle())

            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Back to HQ")
                    Spacer()
                    Image(systemName: "house.fill")
                }
            }
            .buttonStyle(OutlineButtonStyle())
        }
    }

    // Tracks whether the badge was already earned before this round
    private var hadBadgeBefore: Bool {
        let allIds = Set(PPELoadoutBank.allScenarios.map(\.id))
        let withoutCurrent = progress.completedPPEScenarios.subtracting([scenario.id])
        return allIds.isSubset(of: withoutCurrent)
    }

    // MARK: - Sub-views

    private func sectionLabel(_ text: String, color: Color) -> some View {
        Text(text)
            .font(AppFont.mono(10))
            .foregroundColor(color)
            .tracking(0.5)
    }

    private enum DebriefStatus {
        case correct, missed, unnecessary
    }

    private func debriefItemCard(item: PPEItem, status: DebriefStatus) -> some View {
        let statusColor: Color = {
            switch status {
            case .correct: return AppTheme.primary
            case .missed: return AppTheme.danger
            case .unnecessary: return AppTheme.accent
            }
        }()

        let statusIcon: String = {
            switch status {
            case .correct: return "checkmark.circle.fill"
            case .missed: return "xmark.circle.fill"
            case .unnecessary: return "exclamationmark.circle.fill"
            }
        }()

        return GlassCard(glow: statusColor.opacity(0.3)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: item.sfSymbol)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(statusColor)
                        .frame(width: 24)
                    Text(item.name)
                        .font(AppFont.subtitle(14))
                        .foregroundColor(AppTheme.text)
                    Spacer()
                    Image(systemName: statusIcon)
                        .font(.system(size: 14))
                        .foregroundColor(statusColor)
                }

                if let note = scenario.debriefNotes[item.id] {
                    Text(note)
                        .font(AppFont.body(12))
                        .foregroundColor(AppTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    // MARK: - Computed Properties

    private var availableItems: [PPEItem] {
        scenario.availableItemIds.compactMap { PPELoadoutBank.allItems[$0] }
    }

    private var correctSelections: Int {
        selectedIds.intersection(scenario.requiredItemIds).count
    }

    private var unnecessaryCount: Int {
        selectedIds.subtracting(scenario.requiredItemIds).count
    }

    private var scorePercent: Int {
        let required = scenario.requiredItemIds.count
        guard required > 0 else { return 0 }
        let points = max(0, correctSelections - unnecessaryCount)
        return Int(round(Double(points) / Double(required) * 100))
    }

    private var scoreColor: Color {
        scorePercent >= 90 ? AppTheme.primary : scorePercent >= 70 ? AppTheme.accent : AppTheme.danger
    }

    private var scoreMessage: String {
        if scorePercent >= 90 {
            return "Outstanding loadout. You identified the critical PPE."
        } else if scorePercent >= 70 {
            return "Solid effort. Review the missed items below."
        } else if scorePercent >= 50 {
            return "Needs improvement. Several critical items were missed."
        } else {
            return "Study the hazard profile and required protections."
        }
    }

    private var correctItems: [PPEItem] {
        selectedIds.intersection(scenario.requiredItemIds)
            .compactMap { PPELoadoutBank.allItems[$0] }
            .sorted { $0.name < $1.name }
    }

    private var missedItems: [PPEItem] {
        scenario.requiredItemIds.subtracting(selectedIds)
            .compactMap { PPELoadoutBank.allItems[$0] }
            .sorted { $0.name < $1.name }
    }

    private var unnecessaryItems: [PPEItem] {
        selectedIds.subtracting(scenario.requiredItemIds)
            .compactMap { PPELoadoutBank.allItems[$0] }
            .sorted { $0.name < $1.name }
    }

    // MARK: - Actions

    private func toggleItem(_ id: String) {
        if selectedIds.contains(id) {
            selectedIds.remove(id)
        } else {
            selectedIds.insert(id)
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    private func submitScore() {
        let total = scenario.requiredItemIds.count
        let score = max(0, correctSelections - unnecessaryCount)
        rewardSummary = progress.completePractice(score: score, total: total)
        progress.markPPEScenarioCompleted(scenario.id)

        if scorePercent >= 70 {
            AppFeedback.correct()
        } else {
            AppFeedback.incorrect()
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
}

// MARK: - PPE Item Card

private struct PPEItemCard: View {
    let item: PPEItem
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                Image(systemName: item.sfSymbol)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(isSelected ? AppTheme.primary : AppTheme.muted)
                    .frame(height: 28)

                Text(item.name)
                    .font(AppFont.mono(10))
                    .foregroundColor(isSelected ? AppTheme.text : AppTheme.muted)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(isSelected ? AppTheme.primary.opacity(0.1) : AppTheme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(
                        isSelected ? AppTheme.primary.opacity(0.7) : AppTheme.border,
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(item.name)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityHint("Double tap to \(isSelected ? "remove from" : "add to") loadout")
        .accessibilityAddTraits(.isButton)
    }
}
