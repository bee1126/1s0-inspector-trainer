import SwiftUI
import WidgetKit

struct InspectorWidgetEntry: TimelineEntry {
    let date: Date
    let progress: SharedProgressData
}

struct InspectorWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> InspectorWidgetEntry {
        InspectorWidgetEntry(date: Date(), progress: .preview)
    }

    func getSnapshot(in context: Context, completion: @escaping (InspectorWidgetEntry) -> Void) {
        let progress = loadProgressData()
        completion(InspectorWidgetEntry(date: Date(), progress: progress))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<InspectorWidgetEntry>) -> Void) {
        let progress = loadProgressData()
        let entry = InspectorWidgetEntry(date: Date(), progress: progress)
        let refreshDate = Date().addingTimeInterval(900)
        completion(Timeline(entries: [entry], policy: .after(refreshDate)))
    }

    private func loadProgressData() -> SharedProgressData {
        guard let suite = UserDefaults(suiteName: SharedProgressData.suiteName),
              let data = suite.data(forKey: SharedProgressData.key),
              let decoded = try? JSONDecoder().decode(SharedProgressData.self, from: data) else {
            return .preview
        }
        return decoded
    }
}

struct InspectorWidget: Widget {
    private let kind = "InspectorWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: InspectorWidgetProvider()) { entry in
            InspectorWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Inspector Progress")
        .description("View your streak, XP goal progress, hearts, and quick drill status.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct InspectorWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    let entry: InspectorWidgetEntry

    var body: some View {
        Group {
            switch family {
            case .systemMedium:
                MediumInspectorWidgetView(progress: entry.progress)
            default:
                SmallInspectorWidgetView(progress: entry.progress, linksToHome: true)
            }
        }
        .containerBackground(WidgetTheme.bg, for: .widget)
    }
}

private struct SmallInspectorWidgetView: View {
    let progress: SharedProgressData
    let linksToHome: Bool

    private var goalProgress: Double {
        guard progress.dailyGoal > 0 else { return 0 }
        return min(max(Double(progress.dailyXp) / Double(progress.dailyGoal), 0), 1)
    }

    @ViewBuilder
    var body: some View {
        if linksToHome {
            content
                .widgetURL(URL(string: "inspectortrainer://home"))
        } else {
            content
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .foregroundColor(WidgetTheme.accent)
                Text("\(progress.dailyStreak)")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(WidgetTheme.accent)
                Spacer()
            }

            Spacer(minLength: 0)

            ZStack {
                Circle()
                    .stroke(WidgetTheme.surface, lineWidth: 8)
                Circle()
                    .trim(from: 0, to: goalProgress)
                    .stroke(WidgetTheme.primary, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("LVL \(progress.level)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(WidgetTheme.text)
            }
            .frame(width: 76, height: 76)
            .frame(maxWidth: .infinity)

            Spacer(minLength: 0)

            HStack(spacing: 4) {
                ForEach(0..<progress.maxHearts, id: \.self) { index in
                    Image(systemName: index < progress.hearts ? "heart.fill" : "heart")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(index < progress.hearts ? WidgetTheme.danger : WidgetTheme.muted)
                }
                Spacer(minLength: 0)
            }
        }
    }
}

private struct MediumInspectorWidgetView: View {
    let progress: SharedProgressData

    var body: some View {
        HStack(spacing: 14) {
            SmallInspectorWidgetView(progress: progress, linksToHome: false)
                .frame(width: 110)

            VStack(alignment: .leading, spacing: 10) {
                Link(destination: URL(string: "inspectortrainer://practice/daily-five") ?? URL(string: "inspectortrainer://home")!) {
                    Text("QUICK DRILL")
                        .font(.system(size: 13, weight: .black, design: .rounded))
                        .foregroundColor(WidgetTheme.bg)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(WidgetTheme.primary)
                        )
                }

                Text("\(progress.completedModuleCount)/\(progress.totalModuleCount) modules")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(WidgetTheme.muted)

                Text("\(progress.overdueReviewCount) cards due")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(WidgetTheme.muted)

                Spacer(minLength: 0)
            }
        }
        .padding(.vertical, 2)
    }
}

private enum WidgetTheme {
    static let bg = Color(red: 0.04, green: 0.055, blue: 0.08)
    static let surface = Color(red: 0.08, green: 0.10, blue: 0.13)
    static let primary = Color(red: 0.0, green: 0.90, blue: 0.63)
    static let accent = Color(red: 1.0, green: 0.72, blue: 0.0)
    static let danger = Color(red: 1.0, green: 0.23, blue: 0.36)
    static let text = Color(red: 0.91, green: 0.93, blue: 0.95)
    static let muted = Color(red: 0.35, green: 0.40, blue: 0.47)
}

private extension SharedProgressData {
    static let preview = SharedProgressData(
        xp: 280,
        level: 3,
        dailyXp: 14,
        dailyGoal: 20,
        dailyStreak: 4,
        hearts: 4,
        maxHearts: 5,
        completedModuleCount: 6,
        totalModuleCount: 14,
        overdueReviewCount: 9,
        lastUpdated: Date()
    )
}
