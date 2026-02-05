import SwiftUI

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// DESIGN 3 — "BLUEPRINT"
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// Concept: Clean, structured, light-mode design inspired by technical blueprints.
// - Off-white canvas background with subtle grid pattern
// - Cards with crisp left-accent borders (colored by category)
// - System-default SF Pro typography, clean and readable
// - Muted color palette with strategic color pops
// - Structured layout with clear section dividers
// - Professional, institutional feel — like a well-designed government tool
// - Subtle embossed/inset effects for depth without heavy shadows
//
// Palette:
//   Canvas:      #F5F6F8 (cool off-white)
//   Card:        #FFFFFF
//   Border:      #E2E5EB (light border)
//   Navy:        #1B2A4A (primary text)
//   Steel:       #6B7B95 (secondary text)
//   Blueprint:   #2563EB (primary blue)
//   Safety:      #059669 (success green)
//   Alert:       #DC2626 (danger red)
//   Amber:       #D97706 (warning/XP)
//   Grid:        #E8EBF0 (background lines)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// MARK: - Theme

private enum BP {
    static let canvas    = Color(red: 0.96, green: 0.965, blue: 0.975)
    static let card      = Color.white
    static let border    = Color(red: 0.886, green: 0.898, blue: 0.922)
    static let navy      = Color(red: 0.106, green: 0.165, blue: 0.29)
    static let steel     = Color(red: 0.42, green: 0.48, blue: 0.585)
    static let blueprint = Color(red: 0.145, green: 0.388, blue: 0.922)
    static let safety    = Color(red: 0.02, green: 0.588, blue: 0.412)
    static let alert     = Color(red: 0.863, green: 0.149, blue: 0.149)
    static let amber     = Color(red: 0.851, green: 0.467, blue: 0.024)
    static let grid      = Color(red: 0.91, green: 0.922, blue: 0.94)

    static func heading(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .default)
    }
    static func label(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }
    static func body(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
    static func mono(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .monospaced)
    }
    static func caption(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }
}

// MARK: - Background

private struct BPBackground: View {
    var body: some View {
        ZStack {
            BP.canvas.ignoresSafeArea()

            GeometryReader { proxy in
                Canvas { context, size in
                    let spacing: CGFloat = 24
                    let color = BP.grid.opacity(0.6)

                    for x in stride(from: 0, through: size.width, by: spacing) {
                        var path = Path()
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                        context.stroke(path, with: .color(color), lineWidth: 0.5)
                    }
                    for y in stride(from: 0, through: size.height, by: spacing) {
                        var path = Path()
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                        context.stroke(path, with: .color(color), lineWidth: 0.5)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - Card with accent edge

private struct BPCard<Content: View>: View {
    let accent: Color
    let content: Content

    init(accent: Color = BP.border, @ViewBuilder content: () -> Content) {
        self.accent = accent
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 0) {
            // Left accent bar
            RoundedRectangle(cornerRadius: 2)
                .fill(accent)
                .frame(width: 4)

            content
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(BP.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(BP.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Button Styles

private struct BPButtonPrimary: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BP.label(14))
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(BP.blueprint)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

private struct BPButtonSecondary: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BP.label(14))
            .foregroundColor(BP.blueprint)
            .padding(.vertical, 11)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(BP.blueprint.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(BP.blueprint.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Section Header

private struct BPSectionHeader: View {
    let title: String
    let count: Int?

    init(_ title: String, count: Int? = nil) {
        self.title = title
        self.count = count
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(BP.heading(18))
                .foregroundColor(BP.navy)
            if let count {
                Text("(\(count))")
                    .font(BP.body(14))
                    .foregroundColor(BP.steel)
            }
            Spacer()
        }
    }
}

// MARK: - Inline Stat

private struct BPInlineStat: View {
    let label: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 28, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .fill(color.opacity(0.1))
                )
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(BP.caption(11))
                    .foregroundColor(BP.steel)
                Text(value)
                    .font(BP.label(15))
                    .foregroundColor(BP.navy)
            }
        }
    }
}

// MARK: - XP Progress

private struct BPProgressBar: View {
    let label: String
    let current: Int
    let total: Int
    let color: Color

    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(1, Double(current) / Double(total))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(BP.caption(12))
                    .foregroundColor(BP.steel)
                Spacer()
                Text("\(current)/\(total)")
                    .font(BP.mono(12))
                    .foregroundColor(BP.navy)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(BP.border)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Hearts

private struct BPHearts: View {
    let hearts: Int
    let max: Int

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<max, id: \.self) { i in
                Image(systemName: i < hearts ? "heart.fill" : "heart")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(i < hearts ? BP.alert : BP.border)
            }
        }
    }
}

// MARK: - Level Badge

private struct BPLevelBadge: View {
    let level: Int
    let progress: Double

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(BP.border, lineWidth: 4)
                    .frame(width: 48, height: 48)
                Circle()
                    .trim(from: 0, to: min(progress, 1))
                    .stroke(BP.blueprint, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 48, height: 48)
                Text("\(level)")
                    .font(BP.heading(18))
                    .foregroundColor(BP.navy)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Level \(level)")
                    .font(BP.label(15))
                    .foregroundColor(BP.navy)
                Text("\(Int(progress * 100))% to next level")
                    .font(BP.body(12))
                    .foregroundColor(BP.steel)
            }
        }
    }
}

// MARK: - Module Row

private struct BPModuleRow: View {
    let title: String
    let subtitle: String
    let difficulty: String
    let minutes: Int
    let score: Int?
    let isComplete: Bool

    var body: some View {
        BPCard(accent: isComplete ? BP.safety : BP.blueprint) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(BP.label(16))
                        .foregroundColor(BP.navy)
                    Spacer()
                    if isComplete {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(BP.safety)
                    }
                }
                Text(subtitle)
                    .font(BP.body(13))
                    .foregroundColor(BP.steel)

                HStack(spacing: 12) {
                    Label("\(minutes) min", systemImage: "clock")
                        .font(BP.caption(11))
                        .foregroundColor(BP.steel)

                    Text(difficulty)
                        .font(BP.mono(10))
                        .foregroundColor(difficultyColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(difficultyColor.opacity(0.1))
                        )

                    Spacer()

                    if let score {
                        Text("\(score)%")
                            .font(BP.mono(14))
                            .foregroundColor(score >= 90 ? BP.safety : BP.amber)
                    }
                }
            }
        }
    }

    private var difficultyColor: Color {
        switch difficulty.lowercased() {
        case "hard": return BP.alert
        case "medium": return BP.amber
        default: return BP.safety
        }
    }
}

// MARK: - Practice List Item

private struct BPPracticeRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.08))
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(BP.label(14))
                    .foregroundColor(BP.navy)
                Text(description)
                    .font(BP.body(12))
                    .foregroundColor(BP.steel)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(BP.border)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(BP.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(BP.border, lineWidth: 1)
        )
    }
}

// MARK: - Full Home Mockup

struct DesignMockup_Blueprint: View {
    var body: some View {
        ZStack {
            BPBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    // Header
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("1S0 Inspector Trainer")
                                .font(BP.heading(24))
                                .foregroundColor(BP.navy)
                            Text("Level up your inspection skills with daily practice.")
                                .font(BP.body(14))
                                .foregroundColor(BP.steel)
                        }
                        Spacer()
                        BPLevelBadge(level: 4, progress: 0.65)
                    }

                    // Quick Stats
                    BPCard(accent: BP.blueprint) {
                        VStack(spacing: 14) {
                            HStack {
                                BPInlineStat(label: "Streak", value: "3 days", icon: "flame.fill", color: BP.amber)
                                Spacer()
                                BPInlineStat(label: "Hearts", value: "4/5", icon: "heart.fill", color: BP.alert)
                            }
                            BPProgressBar(label: "Daily XP Goal", current: 14, total: 20, color: BP.amber)
                        }
                    }

                    // Continue
                    BPCard(accent: BP.amber) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Continue Training")
                                    .font(BP.caption(11))
                                    .foregroundColor(BP.steel)
                                    .textCase(.uppercase)
                                Text("Risk Management")
                                    .font(BP.label(16))
                                    .foregroundColor(BP.navy)
                                Text("Module in progress - pick up where you left off")
                                    .font(BP.body(12))
                                    .foregroundColor(BP.steel)
                            }
                            Spacer()
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(BP.blueprint)
                        }
                    }

                    // Practice Zone
                    BPSectionHeader("Practice Zone")

                    VStack(spacing: 8) {
                        BPPracticeRow(icon: "bolt.fill", title: "Quick Drill", description: "Random questions, earn XP", color: BP.blueprint)
                        BPPracticeRow(icon: "checkmark.seal.fill", title: "Daily 5", description: "5-question daily challenge", color: BP.amber)
                        BPPracticeRow(icon: "timer", title: "Match Sprint", description: "Pair terms and definitions", color: BP.safety)
                        BPPracticeRow(icon: "bolt.circle", title: "True/False Blitz", description: "8-second time pressure", color: BP.alert)
                        BPPracticeRow(icon: "arrow.up.arrow.down.square", title: "Sequence Builder", description: "Reorder procedure steps", color: BP.blueprint)
                        BPPracticeRow(icon: "square.grid.2x2", title: "RAC Sort", description: "Categorize hazards by risk", color: BP.amber)
                    }

                    // Training Modules
                    BPSectionHeader("Training Modules", count: 6)

                    VStack(spacing: 10) {
                        BPModuleRow(
                            title: "Lockout/Tagout",
                            subtitle: "Energy isolation procedures",
                            difficulty: "Medium",
                            minutes: 8,
                            score: 94,
                            isComplete: true
                        )

                        BPModuleRow(
                            title: "Fall Protection",
                            subtitle: "Working at heights safety",
                            difficulty: "Hard",
                            minutes: 10,
                            score: nil,
                            isComplete: false
                        )

                        BPModuleRow(
                            title: "Risk Management",
                            subtitle: "RAC and hazard assessment",
                            difficulty: "Easy",
                            minutes: 6,
                            score: 87,
                            isComplete: true
                        )
                    }

                    // Badges Preview
                    BPSectionHeader("Recent Badges")

                    HStack(spacing: 12) {
                        BPBadge(icon: "star.fill", title: "First Mission", earned: true)
                        BPBadge(icon: "target", title: "Precision", earned: true)
                        BPBadge(icon: "flame.fill", title: "Streak 3", earned: true)
                        BPBadge(icon: "crown.fill", title: "Safety Ace", earned: false)
                    }

                    // Footer
                    Divider()
                        .background(BP.border)

                    Text("Not an official Air Force product. Training aids only.")
                        .font(BP.body(12))
                        .foregroundColor(BP.steel)
                        .padding(.bottom, 8)
                }
                .padding(20)
            }
            .scrollIndicators(.hidden)
        }
    }
}

// MARK: - Badge

private struct BPBadge: View {
    let icon: String
    let title: String
    let earned: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(earned ? BP.safety.opacity(0.1) : BP.border.opacity(0.5))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(earned ? BP.safety : BP.steel.opacity(0.5))
            }
            Text(title)
                .font(BP.caption(10))
                .foregroundColor(earned ? BP.navy : BP.steel)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Tab Bar

struct BPTabBar: View {
    @State private var selected = 0

    private let tabs: [(icon: String, label: String)] = [
        ("shield.lefthalf.filled", "Home"),
        ("chart.bar.xaxis", "Progress"),
        ("book", "Sources"),
        ("bubble.left.and.bubble.right", "Feedback")
    ]

    var body: some View {
        HStack {
            ForEach(tabs.indices, id: \.self) { i in
                Button {
                    selected = i
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[i].icon)
                            .font(.system(size: 18, weight: selected == i ? .bold : .regular))
                        Text(tabs[i].label)
                            .font(BP.caption(10))
                    }
                    .foregroundColor(selected == i ? BP.blueprint : BP.steel)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 10)
        .background(
            VStack(spacing: 0) {
                Rectangle()
                    .fill(BP.border)
                    .frame(height: 1)
                BP.card
            }
        )
    }
}

// MARK: - Preview

#Preview("Design 3: Blueprint") {
    VStack(spacing: 0) {
        DesignMockup_Blueprint()
        BPTabBar()
    }
    .preferredColorScheme(.light)
}
