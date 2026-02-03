import SwiftUI

struct ProgressDashboardView: View {
    @EnvironmentObject private var progress: ProgressStore
    private let modules = TrainingContent.modules
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Progress")
                        .font(AppFont.title(26))
                        .foregroundColor(.white)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Overall Readiness")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)
                            ProgressView(value: completionRate)
                                .tint(AppTheme.safetyGreen)
                            Text("\(completedCount) of \(modules.count) modules completed")
                                .font(AppFont.body(13))
                                .foregroundColor(AppTheme.charcoal.opacity(0.7))
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Module Status")
                                .font(AppFont.subtitle(18))
                                .foregroundColor(AppTheme.charcoal)

                            ForEach(modules, id: \.id) { module in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(module.title)
                                            .font(AppFont.subtitle(15))
                                            .foregroundColor(AppTheme.charcoal)
                                        Text(progress.isCompleted(module.id) ? "Completed" : "Not started")
                                            .font(AppFont.body(12))
                                            .foregroundColor(AppTheme.charcoal.opacity(0.6))
                                        if let date = progress.lastCompletionDate(for: module.id) {
                                            Text("Last completed \(dateFormatter.string(from: date))")
                                                .font(AppFont.body(11))
                                                .foregroundColor(AppTheme.charcoal.opacity(0.55))
                                        }
                                    }
                                    Spacer()
                                    if progress.isCompleted(module.id) {
                                        ScoreBadge(score: progress.bestScore(for: module.id))
                                    }
                                }
                                Divider().opacity(0.3)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Badges")
                            .font(AppFont.subtitle(18))
                            .foregroundColor(.white)

                        ForEach(badges, id: \.id) { badge in
                            MissionBadge(title: badge.title, detail: badge.detail, isEarned: badge.isEarned)
                        }
                    }

                    Button("Reset Progress") {
                        progress.resetAll()
                    }
                    .buttonStyle(OutlineButtonStyle())
                }
                .padding(20)
            }
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var completedCount: Int {
        modules.filter { progress.isCompleted($0.id) }.count
    }

    private var completionRate: Double {
        guard !modules.isEmpty else { return 0 }
        return Double(completedCount) / Double(modules.count)
    }

    private var badges: [BadgeState] {
        let perfectScores = modules.filter { progress.bestScore(for: $0.id) >= 90 }.count
        return [
            BadgeState(
                id: "first-completion",
                title: "First Mission",
                detail: "Complete your first module",
                isEarned: completedCount >= 1
            ),
            BadgeState(
                id: "full-crew",
                title: "Full Crew",
                detail: "Complete all modules",
                isEarned: completedCount == modules.count && !modules.isEmpty
            ),
            BadgeState(
                id: "precision",
                title: "Precision Operator",
                detail: "Score 90% or higher on any module",
                isEarned: perfectScores >= 1
            ),
            BadgeState(
                id: "ace",
                title: "Safety Ace",
                detail: "Score 90% or higher on all modules",
                isEarned: perfectScores == modules.count && !modules.isEmpty
            )
        ]
    }
}

struct BadgeState: Identifiable {
    let id: String
    let title: String
    let detail: String
    let isEarned: Bool
}
