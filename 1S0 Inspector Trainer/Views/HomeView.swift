import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var progress: ProgressStore

    private var modules: [TrainingModule] {
        TrainingContent.modules(for: progress.selectedRole)
    }

    private var resumeModule: TrainingModule? {
        guard let resume = progress.resumeState else { return nil }
        return modules.first(where: { $0.id == resume.moduleId })
    }

    private var suggestedModule: TrainingModule? {
        modules.first(where: { !$0.isCompleted(progress) && $0.isIntegrityValid })
    }

    private let practiceColumns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("1S0 INSPECTOR TRAINER")
                            .font(AppFont.mono(11))
                            .foregroundColor(AppTheme.primary)
                        Text(progress.selectedRole?.appTitle ?? "Inspector Trainer")
                            .font(AppFont.title(26))
                            .foregroundColor(AppTheme.text)
                        Text(progress.selectedRole?.homeSubtitle ?? "Level up your inspection skills with daily practice.")
                            .font(AppFont.body(14))
                            .foregroundColor(AppTheme.muted)
                    }

                    sectionHeader("MISSION STATUS")
                    missionStatusZone

                    sectionHeader("CONTINUE TRAINING")
                    continueTrainingZone

                    sectionHeader("PRACTICE MODES")
                    LazyVGrid(columns: practiceColumns, spacing: 10) {
                        practiceTile(
                            icon: "bolt.fill",
                            label: "Quick Practice",
                            tint: AppTheme.primary,
                            destination: AnyView(PracticeSessionView())
                        )
                        practiceTile(
                            icon: "checkmark.seal.fill",
                            label: "Daily 5 Challenge",
                            tint: AppTheme.accent,
                            destination: AnyView(PracticeSessionView(mode: .dailyFive))
                        )
                        practiceTile(
                            icon: "timer",
                            label: "Match Sprint",
                            tint: AppTheme.info,
                            destination: AnyView(MatchingDeckSelectionView())
                        )
                        practiceTile(
                            icon: "bolt.circle",
                            label: "True/False Blitz",
                            tint: AppTheme.danger,
                            destination: AnyView(TrueFalseBlitzView())
                        )
                        practiceTile(
                            icon: "arrow.up.arrow.down.square",
                            label: "Procedure Drill",
                            tint: AppTheme.primary,
                            destination: AnyView(ProcedureDrillLobbyView())
                        )
                        practiceTile(
                            icon: "square.grid.2x2",
                            label: "RAC Sort",
                            tint: AppTheme.info,
                            destination: AnyView(RacSortView())
                        )
                        practiceTile(
                            icon: "scope",
                            label: "Micro-Drills",
                            tint: AppTheme.accent,
                            destination: AnyView(MicroDrillSelectionView())
                        )
                    }

                    sectionHeader("TRAINING LIBRARY")
                    Text("\(modules.count) modules available")
                        .font(AppFont.mono(11))
                        .foregroundColor(AppTheme.muted)

                    ForEach(modules, id: \.id) { module in
                        if module.isIntegrityValid {
                            NavigationLink {
                                ModuleDetailView(module: module)
                            } label: {
                                ModuleCardView(module: module, score: progress.bestScore(for: module.id))
                            }
                            .buttonStyle(.plain)
                        } else {
                            GlassCard(glow: AppTheme.danger.opacity(0.5)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(module.title)
                                        .font(AppFont.subtitle(15))
                                        .foregroundColor(AppTheme.text)
                                    Text("Unavailable: incomplete content")
                                        .font(AppFont.body(13))
                                        .foregroundColor(AppTheme.danger)
                                }
                            }
                        }
                    }

                    Text("Not an official Air Force product. Training aids only.")
                        .font(AppFont.mono(10))
                        .foregroundColor(AppTheme.muted)
                        .padding(.top, AppSpacing.item)
                }
                .tacticalReadableWidth()
                .padding(AppSpacing.screenPadding)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            progress.refreshForNewDayIfNeeded()
        }
    }

    private var missionStatusZone: some View {
        VStack(alignment: .leading, spacing: 10) {
            hudStatusBar

            GlassCard {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("\(progress.dailyXp)/\(progress.dailyGoal) XP today")
                            .font(AppFont.mono(14))
                            .foregroundColor(AppTheme.text)
                        Spacer()
                        if progress.dailyGoalProgress >= 1.0 {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(AppTheme.primary)
                                .font(.system(size: 16, weight: .bold))
                        }
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(AppTheme.border)
                                .frame(height: 6)
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(AppTheme.accent)
                                .frame(width: geo.size.width * min(progress.dailyGoalProgress, 1.0), height: 6)
                                .shadow(color: AppTheme.accent.opacity(0.5), radius: 4, x: 0, y: 0)
                        }
                    }
                    .frame(height: 6)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(AccessibilityCopy.progressLabel(name: "Daily goal", current: progress.dailyXp, total: progress.dailyGoal))
                    .accessibilityValue(AccessibilityCopy.progressValue(current: progress.dailyXp, total: progress.dailyGoal))
                }
            }

            GlassCard {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppTheme.primary)
                        Text("Starter Path")
                            .font(AppFont.subtitle(15))
                            .foregroundColor(AppTheme.text)
                    }

                    Text("7-day starter program with daily check-ins.")
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.muted)

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(AppTheme.border)
                                .frame(height: 6)
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(AppTheme.primary)
                                .frame(width: geo.size.width * min(onboardingProgress, 1.0), height: 6)
                                .shadow(color: AppTheme.primary.opacity(0.4), radius: 4, x: 0, y: 0)
                        }
                    }
                    .frame(height: 6)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(AccessibilityCopy.progressLabel(name: "Starter path", current: onboardingCompleted, total: onboardingTotal))
                    .accessibilityValue(AccessibilityCopy.progressValue(current: onboardingCompleted, total: onboardingTotal))

                    HStack {
                        Text("\(onboardingCompleted)/\(onboardingTotal) check-ins")
                            .font(AppFont.mono(12))
                            .foregroundColor(AppTheme.muted)
                        Spacer()
                        if let dayNumber = onboardingDayNumber {
                            Text("DAY \(dayNumber) OF \(onboardingTotal)")
                                .font(AppFont.mono(11))
                                .foregroundColor(AppTheme.info)
                        }
                    }

                    NavigationLink {
                        OnboardingPathView()
                    } label: {
                        HStack {
                            Text("Open Starter Path")
                            Spacer()
                            Image(systemName: "calendar")
                        }
                    }
                    .buttonStyle(OutlineButtonStyle())
                }
            }
        }
    }

    private var continueTrainingZone: some View {
        Group {
            if let resumeModule {
                GlassCard(glow: AppTheme.accent) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppTheme.accent)
                            Text("Resume Current Run")
                                .font(AppFont.subtitle(15))
                                .foregroundColor(AppTheme.text)
                        }
                        Text(resumeModule.title)
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.muted)
                        NavigationLink {
                            ModuleFlowView(module: resumeModule)
                        } label: {
                            HStack {
                                Text("Continue")
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
            } else if let suggestedModule {
                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recommended Next Module")
                            .font(AppFont.subtitle(15))
                            .foregroundColor(AppTheme.text)
                        Text(suggestedModule.title)
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.muted)
                        NavigationLink {
                            ModuleDetailView(module: suggestedModule)
                        } label: {
                            HStack {
                                Text("Open Module")
                                Spacer()
                                Image(systemName: "arrow.right")
                            }
                        }
                        .buttonStyle(OutlineButtonStyle())
                    }
                }
            } else {
                GlassCard {
                    Text("All available modules are complete. Run practice modes to keep skills sharp.")
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.muted)
                }
            }
        }
    }

    private var hudStatusBar: some View {
        HStack(spacing: 0) {
            hudSegment(label: "LVL", value: "\(progress.level)", tint: AppTheme.text)
            hudDivider
            hudSegment(label: "XP", value: "\(progress.xp)", tint: AppTheme.accent)
            hudDivider
            hudSegment(label: "STREAK", value: "\(progress.dailyStreak)d", tint: AppTheme.accent)
            hudDivider
            VStack(spacing: 2) {
                Text("HEARTS")
                    .font(AppFont.mono(9))
                    .foregroundColor(AppTheme.muted)
                HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, compact: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(AppTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(AppTheme.border, lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }

    private func hudSegment(label: String, value: String, tint: Color) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(AppFont.mono(9))
                .foregroundColor(AppTheme.muted)
            Text(value)
                .font(AppFont.mono(16))
                .foregroundColor(tint)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }

    private var hudDivider: some View {
        Rectangle()
            .fill(AppTheme.border)
            .frame(width: 1, height: 32)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(AppFont.mono(11))
            .foregroundColor(AppTheme.muted)
            .tracking(1.5)
    }

    private func practiceTile(icon: String, label: String, tint: Color, destination: AnyView) -> some View {
        NavigationLink {
            destination
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(tint)
                Text(label)
                    .font(AppFont.mono(11))
                    .foregroundColor(AppTheme.text)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 96)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(AppTheme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var onboardingTotal: Int {
        PracticeContent.onboardingDays(for: progress.selectedRole).count
    }

    private var onboardingCompleted: Int {
        progress.onboardingCheckIns.count
    }

    private var onboardingProgress: Double {
        guard onboardingTotal > 0 else { return 0 }
        return Double(onboardingCompleted) / Double(onboardingTotal)
    }

    private var onboardingDayNumber: Int? {
        progress.onboardingDayNumber()
    }
}

private extension TrainingModule {
    func isCompleted(_ progress: ProgressStore) -> Bool {
        progress.isCompleted(id)
    }
}
