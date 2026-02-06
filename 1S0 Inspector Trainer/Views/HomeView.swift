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

    // 2-column grid for practice tiles
    private let practiceColumns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {

                    // ── App Title ──────────────────────────────────
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

                    // ── HUD Status Bar ─────────────────────────────
                    hudStatusBar

                    // ── Daily Goal ─────────────────────────────────
                    sectionHeader("DAILY GOAL")

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
                        }
                    }

                    // ── New Trainee Path ───────────────────────────
                    sectionHeader("STARTER PATH")

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(AppTheme.primary)
                                Text("New Trainee Path")
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

                    // ── Continue Training ──────────────────────────
                    if let resumeModule {
                        sectionHeader("CONTINUE TRAINING")

                        GlassCard(glow: AppTheme.accent) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(AppTheme.accent)
                                    Text("Resume")
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
                    }

                    // ── Practice Zone ──────────────────────────────
                    sectionHeader("PRACTICE ZONE")

                    LazyVGrid(columns: practiceColumns, spacing: 10) {
                        practiceTile(
                            icon: "bolt.fill",
                            label: "Practice",
                            tint: AppTheme.primary,
                            destination: AnyView(PracticeSessionView())
                        )
                        practiceTile(
                            icon: "checkmark.seal.fill",
                            label: "Daily 5",
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
                            label: "T/F Blitz",
                            tint: AppTheme.danger,
                            destination: AnyView(TrueFalseBlitzView())
                        )
                        practiceTile(
                            icon: "arrow.up.arrow.down.square",
                            label: "Sequence",
                            tint: AppTheme.primary,
                            destination: AnyView(SequenceBuilderSelectionView())
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

                    // ── Training Modules ───────────────────────────
                    sectionHeader("TRAINING MODULES")

                    Text("\(modules.count) modules available")
                        .font(AppFont.mono(11))
                        .foregroundColor(AppTheme.muted)

                    ForEach(modules, id: \.id) { module in
                        NavigationLink {
                            ModuleDetailView(module: module)
                        } label: {
                            ModuleCardView(module: module, score: progress.bestScore(for: module.id))
                        }
                        .buttonStyle(.plain)
                    }

                    // ── Disclaimer ─────────────────────────────────
                    Text("Not an official Air Force product. Training aids only.")
                        .font(AppFont.mono(10))
                        .foregroundColor(AppTheme.muted)
                        .padding(.top, AppSpacing.item)
                }
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

    // MARK: - HUD Status Bar

    private var hudStatusBar: some View {
        HStack(spacing: 0) {
            hudSegment(label: "LVL", value: "\(progress.level)", tint: AppTheme.text)
            hudDivider
            hudSegment(label: "XP", value: "\(progress.xp)", tint: AppTheme.accent)
            hudDivider
            hudSegment(label: "STREAK", value: "\(progress.dailyStreak)d", tint: AppTheme.accent)
            hudDivider
            HStack(spacing: 3) {
                VStack(spacing: 2) {
                    Text("HEARTS")
                        .font(AppFont.mono(9))
                        .foregroundColor(AppTheme.muted)
                    HeartsView(hearts: progress.hearts, maxHearts: progress.maxHearts, compact: true)
                }
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

    // MARK: - Section Header

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(AppFont.mono(11))
            .foregroundColor(AppTheme.muted)
            .tracking(1.5)
    }

    // MARK: - Practice Tile

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
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
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

    // MARK: - Computed Properties

    private var onboardingTotal: Int {
        PracticeContent.onboardingDays.count
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
