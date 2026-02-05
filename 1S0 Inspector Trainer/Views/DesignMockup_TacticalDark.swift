import SwiftUI

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// DESIGN 1 — "TACTICAL DARK"
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// Concept: Military-grade dark interface with a HUD (heads-up display) feel.
// - Near-black background with subtle green scanline texture
// - Neon-accented status indicators (amber XP, green success, red alerts)
// - Sharp-cornered cards with 1px luminous borders
// - Monospace-heavy typography for a tactical/console aesthetic
// - Segmented status bar at top like cockpit instruments
// - Cards use translucent dark glass instead of white
//
// Palette:
//   Background:  #0A0E14 (near black with blue tint)
//   Surface:     #141A22 (dark card)
//   Border:      #1E2A38 (subtle edge)
//   Primary:     #00E5A0 (tactical green)
//   Accent:      #FFB800 (amber/gold for XP)
//   Danger:      #FF3B5C (alert red)
//   Text:        #E8ECF1 (high contrast light)
//   Muted:       #5A6678 (secondary text)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// MARK: - Theme

private enum TD {
    static let bg       = Color(red: 0.04, green: 0.055, blue: 0.08)
    static let surface  = Color(red: 0.08, green: 0.10, blue: 0.13)
    static let border   = Color(red: 0.12, green: 0.16, blue: 0.22)
    static let primary  = Color(red: 0.0, green: 0.90, blue: 0.63)
    static let accent   = Color(red: 1.0, green: 0.72, blue: 0.0)
    static let danger   = Color(red: 1.0, green: 0.23, blue: 0.36)
    static let text     = Color(red: 0.91, green: 0.93, blue: 0.95)
    static let muted    = Color(red: 0.35, green: 0.40, blue: 0.47)
    static let glow     = Color(red: 0.0, green: 0.90, blue: 0.63).opacity(0.15)

    static func mono(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .monospaced)
    }
    static func heading(_ size: CGFloat) -> Font {
        .system(size: size, weight: .black, design: .default)
    }
    static func label(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }
    static func body(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
}

// MARK: - Background

private struct TDBackground: View {
    var body: some View {
        ZStack {
            TD.bg.ignoresSafeArea()

            // Subtle radial glow at top
            RadialGradient(
                colors: [TD.primary.opacity(0.06), .clear],
                center: .top,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()

            // Scanline overlay
            GeometryReader { proxy in
                Canvas { context, size in
                    let step: CGFloat = 3
                    for y in stride(from: 0, through: size.height, by: step) {
                        var path = Path()
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                        context.stroke(path, with: .color(.white.opacity(0.015)), lineWidth: 0.5)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - Card

private struct TDCard<Content: View>: View {
    let content: Content
    var glow: Color = TD.border

    init(glow: Color = TD.border, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.glow = glow
    }

    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(TD.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(glow.opacity(0.5), lineWidth: 1)
            )
    }
}

// MARK: - Button

private struct TDButtonPrimary: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(TD.label(14))
            .foregroundColor(TD.bg)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(TD.primary)
            )
            .shadow(color: TD.primary.opacity(0.3), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

private struct TDButtonOutline: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(TD.label(14))
            .foregroundColor(TD.primary)
            .padding(.vertical, 10)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(TD.primary.opacity(0.6), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Status Bar (HUD)

private struct TDStatusBar: View {
    let level: Int
    let xp: Int
    let streak: Int
    let hearts: Int
    let maxHearts: Int

    var body: some View {
        HStack(spacing: 0) {
            statusSegment(label: "LVL", value: "\(level)", color: TD.primary)
            divider
            statusSegment(label: "XP", value: "\(xp)", color: TD.accent)
            divider
            statusSegment(label: "STREAK", value: "\(streak)d", color: TD.accent)
            divider
            HStack(spacing: 3) {
                ForEach(0..<maxHearts, id: \.self) { i in
                    Image(systemName: i < hearts ? "heart.fill" : "heart")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(i < hearts ? TD.danger : TD.muted)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(TD.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(TD.border, lineWidth: 1)
                )
        )
    }

    private func statusSegment(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(TD.mono(9))
                .foregroundColor(TD.muted)
            Text(value)
                .font(TD.mono(15))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }

    private var divider: some View {
        Rectangle()
            .fill(TD.border)
            .frame(width: 1, height: 28)
    }
}

// MARK: - XP Ring

private struct TDProgressRing: View {
    let progress: Double
    let level: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(TD.border, lineWidth: 6)
            Circle()
                .trim(from: 0, to: min(progress, 1))
                .stroke(TD.accent, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(color: TD.accent.opacity(0.4), radius: 6)
            VStack(spacing: 1) {
                Text("LVL")
                    .font(TD.mono(8))
                    .foregroundColor(TD.muted)
                Text("\(level)")
                    .font(TD.heading(18))
                    .foregroundColor(TD.text)
            }
        }
        .frame(width: 60, height: 60)
    }
}

// MARK: - Daily Goal

private struct TDDailyGoal: View {
    let current: Int
    let goal: Int

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(1, Double(current) / Double(goal))
    }

    var body: some View {
        TDCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("DAILY OBJECTIVE")
                        .font(TD.mono(11))
                        .foregroundColor(TD.muted)
                    Spacer()
                    Text("\(current)/\(goal) XP")
                        .font(TD.mono(13))
                        .foregroundColor(TD.accent)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(TD.border)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(TD.accent)
                            .frame(width: geo.size.width * progress)
                            .shadow(color: TD.accent.opacity(0.4), radius: 4)
                    }
                }
                .frame(height: 6)
            }
        }
    }
}

// MARK: - Module Row

private struct TDModuleRow: View {
    let title: String
    let subtitle: String
    let difficulty: String
    let minutes: Int
    let score: Int?
    let isComplete: Bool

    var body: some View {
        TDCard(glow: isComplete ? TD.primary.opacity(0.3) : TD.border) {
            HStack(spacing: 14) {
                // Status indicator
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isComplete ? TD.primary.opacity(0.15) : TD.border.opacity(0.5))
                        .frame(width: 40, height: 40)
                    Image(systemName: isComplete ? "checkmark" : "play.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(isComplete ? TD.primary : TD.muted)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(TD.label(15))
                        .foregroundColor(TD.text)
                    Text(subtitle)
                        .font(TD.body(12))
                        .foregroundColor(TD.muted)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 6) {
                        Text("\(minutes)m")
                            .font(TD.mono(10))
                            .foregroundColor(TD.muted)
                        Text(difficulty.uppercased())
                            .font(TD.mono(9))
                            .foregroundColor(difficultyColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(difficultyColor.opacity(0.15))
                            )
                    }
                    if let score {
                        Text("\(score)%")
                            .font(TD.mono(13))
                            .foregroundColor(score >= 90 ? TD.primary : TD.accent)
                    }
                }
            }
        }
    }

    private var difficultyColor: Color {
        switch difficulty.lowercased() {
        case "hard": return TD.danger
        case "medium": return TD.accent
        default: return TD.primary
        }
    }
}

// MARK: - Practice Grid

private struct TDPracticeGrid: View {
    let items: [(icon: String, name: String, color: Color)]

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            ForEach(items.indices, id: \.self) { i in
                let item = items[i]
                HStack(spacing: 10) {
                    Image(systemName: item.icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(item.color)
                        .frame(width: 32, height: 32)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(item.color.opacity(0.12))
                        )
                    Text(item.name)
                        .font(TD.label(12))
                        .foregroundColor(TD.text)
                    Spacer()
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(TD.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(TD.border, lineWidth: 1)
                        )
                )
            }
        }
    }
}

// MARK: - Full Home Mockup

struct DesignMockup_TacticalDark: View {
    var body: some View {
        ZStack {
            TDBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Header
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("1S0 INSPECTOR TRAINER")
                                .font(TD.mono(11))
                                .foregroundColor(TD.primary)
                            Text("Tactical Readiness")
                                .font(TD.heading(26))
                                .foregroundColor(TD.text)
                            Text("Level up your inspection skills with daily practice.")
                                .font(TD.body(14))
                                .foregroundColor(TD.muted)
                        }
                        Spacer()
                        TDProgressRing(progress: 0.65, level: 4)
                    }

                    // HUD Status Bar
                    TDStatusBar(level: 4, xp: 485, streak: 3, hearts: 4, maxHearts: 5)

                    // Daily Goal
                    TDDailyGoal(current: 14, goal: 20)

                    // Continue Training
                    TDCard(glow: TD.accent.opacity(0.4)) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(TD.accent)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("CONTINUE TRAINING")
                                    .font(TD.mono(10))
                                    .foregroundColor(TD.muted)
                                Text("Risk Management")
                                    .font(TD.label(16))
                                    .foregroundColor(TD.text)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(TD.muted)
                        }
                    }

                    // Practice Zone
                    VStack(alignment: .leading, spacing: 10) {
                        Text("PRACTICE OPS")
                            .font(TD.mono(11))
                            .foregroundColor(TD.muted)

                        TDPracticeGrid(items: [
                            ("bolt.fill", "Quick Drill", TD.primary),
                            ("checkmark.seal.fill", "Daily 5", TD.accent),
                            ("timer", "Match Sprint", Color(red: 0.4, green: 0.6, blue: 1.0)),
                            ("bolt.circle", "T/F Blitz", TD.danger),
                            ("arrow.up.arrow.down.square", "Sequences", TD.primary),
                            ("square.grid.2x2", "RAC Sort", TD.accent)
                        ])
                    }

                    // Modules
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("TRAINING MODULES")
                                .font(TD.mono(11))
                                .foregroundColor(TD.muted)
                            Spacer()
                            Text("6 available")
                                .font(TD.mono(10))
                                .foregroundColor(TD.muted)
                        }

                        TDModuleRow(
                            title: "Lockout/Tagout",
                            subtitle: "Energy isolation procedures",
                            difficulty: "Medium",
                            minutes: 8,
                            score: 94,
                            isComplete: true
                        )

                        TDModuleRow(
                            title: "Fall Protection",
                            subtitle: "Working at heights safety",
                            difficulty: "Hard",
                            minutes: 10,
                            score: nil,
                            isComplete: false
                        )

                        TDModuleRow(
                            title: "Risk Management",
                            subtitle: "RAC and hazard assessment",
                            difficulty: "Easy",
                            minutes: 6,
                            score: 87,
                            isComplete: true
                        )
                    }

                    // Footer
                    Text("Not an official Air Force product. Training aids only.")
                        .font(TD.mono(10))
                        .foregroundColor(TD.muted)
                        .padding(.top, 8)
                }
                .padding(20)
            }
            .scrollIndicators(.hidden)
        }
    }
}

// MARK: - Tab Bar Mockup

struct TDTabBar: View {
    @State private var selected = 0

    private let tabs: [(icon: String, label: String)] = [
        ("shield.lefthalf.filled", "HQ"),
        ("chart.bar.xaxis", "Intel"),
        ("book", "Refs"),
        ("bubble.left.and.bubble.right", "Comms")
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
                            .font(TD.mono(9))
                    }
                    .foregroundColor(selected == i ? TD.primary : TD.muted)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 10)
        .background(
            Rectangle()
                .fill(TD.surface)
                .overlay(
                    Rectangle()
                        .fill(TD.border)
                        .frame(height: 1),
                    alignment: .top
                )
        )
    }
}

// MARK: - Preview

#Preview("Design 1: Tactical Dark") {
    VStack(spacing: 0) {
        DesignMockup_TacticalDark()
        TDTabBar()
    }
    .preferredColorScheme(.dark)
}
