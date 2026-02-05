import SwiftUI

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// DESIGN 2 — "HORIZON"
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// Concept: Bold, modern, gradient-forward design with layered depth.
// - Rich background mesh gradient (deep indigo → electric blue → warm coral)
// - Frosted glass cards with generous blur and rounded corners (24pt)
// - Large hero typography with gradient text effects
// - Colorful pill-shaped action buttons with depth shadows
// - Playful but professional — think modern fitness/learning app
// - Generous spacing, breathing room, visual hierarchy through scale
//
// Palette:
//   Gradient Start:  #1A1040 (deep indigo)
//   Gradient Mid:    #2D4FBF (electric blue)
//   Gradient End:    #FF6B6B (warm coral)
//   Card:            White @ 12% with blur
//   Primary:         #6C5CE7 (vibrant purple)
//   Accent:          #FDCB6E (warm gold)
//   Success:         #00B894 (emerald)
//   Danger:          #FF6B6B (coral)
//   Text:            #FFFFFF
//   Muted:           rgba(255,255,255,0.6)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// MARK: - Theme

private enum HZ {
    static let indigo   = Color(red: 0.10, green: 0.06, blue: 0.25)
    static let electric = Color(red: 0.18, green: 0.31, blue: 0.75)
    static let coral    = Color(red: 1.0, green: 0.42, blue: 0.42)
    static let purple   = Color(red: 0.42, green: 0.36, blue: 0.91)
    static let gold     = Color(red: 0.99, green: 0.80, blue: 0.43)
    static let emerald  = Color(red: 0.0, green: 0.72, blue: 0.58)
    static let white    = Color.white
    static let muted    = Color.white.opacity(0.6)
    static let cardFill = Color.white.opacity(0.12)
    static let cardBorder = Color.white.opacity(0.18)

    static func hero(_ size: CGFloat) -> Font {
        .system(size: size, weight: .black, design: .rounded)
    }
    static func heading(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }
    static func label(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
    static func body(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }
    static func mono(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .monospaced)
    }
}

// MARK: - Background

private struct HZBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [HZ.indigo, HZ.electric, HZ.indigo.opacity(0.9)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Floating orbs
            Circle()
                .fill(HZ.coral.opacity(0.2))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: 120, y: -200)

            Circle()
                .fill(HZ.purple.opacity(0.25))
                .frame(width: 250, height: 250)
                .blur(radius: 70)
                .offset(x: -100, y: 300)

            Circle()
                .fill(HZ.electric.opacity(0.15))
                .frame(width: 200, height: 200)
                .blur(radius: 60)
                .offset(x: 80, y: 500)
        }
    }
}

// MARK: - Frosted Card

private struct HZCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(HZ.cardBorder, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Pill Button

private struct HZButtonPrimary: ButtonStyle {
    var gradient: [Color] = [HZ.purple, HZ.electric]

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(HZ.label(15))
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(
                Capsule()
                    .fill(LinearGradient(colors: gradient, startPoint: .leading, endPoint: .trailing))
            )
            .shadow(color: gradient.first!.opacity(0.4), radius: 12, x: 0, y: 6)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

private struct HZButtonOutline: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(HZ.label(14))
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                Capsule()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Stat Orb

private struct HZStatOrb: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 52, height: 52)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(color)
            }
            Text(value)
                .font(HZ.heading(16))
                .foregroundColor(.white)
            Text(label)
                .font(HZ.body(11))
                .foregroundColor(HZ.muted)
        }
    }
}

// MARK: - XP Ring

private struct HZProgressRing: View {
    let progress: Double
    let level: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 8)
            Circle()
                .trim(from: 0, to: min(progress, 1))
                .stroke(
                    LinearGradient(colors: [HZ.gold, HZ.coral], startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: HZ.gold.opacity(0.4), radius: 8)
            VStack(spacing: 1) {
                Text("\(level)")
                    .font(HZ.hero(22))
                    .foregroundColor(.white)
                Text("LEVEL")
                    .font(HZ.mono(8))
                    .foregroundColor(HZ.muted)
            }
        }
        .frame(width: 72, height: 72)
    }
}

// MARK: - Hearts

private struct HZHearts: View {
    let hearts: Int
    let max: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<max, id: \.self) { i in
                Image(systemName: i < hearts ? "heart.fill" : "heart")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(i < hearts ? HZ.coral : .white.opacity(0.3))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule().fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Module Card

private struct HZModuleCard: View {
    let title: String
    let subtitle: String
    let difficulty: String
    let minutes: Int
    let score: Int?
    let isComplete: Bool

    var body: some View {
        HZCard {
            HStack(spacing: 14) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: isComplete ? [HZ.emerald, HZ.emerald.opacity(0.7)] : [HZ.purple, HZ.electric],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    Image(systemName: isComplete ? "checkmark" : "book.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(HZ.heading(16))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(HZ.body(13))
                        .foregroundColor(HZ.muted)
                        .lineLimit(1)
                    HStack(spacing: 8) {
                        Label("\(minutes) min", systemImage: "clock")
                            .font(HZ.mono(10))
                            .foregroundColor(HZ.muted)
                        Text(difficulty)
                            .font(HZ.mono(10))
                            .foregroundColor(difficultyColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule().fill(difficultyColor.opacity(0.2))
                            )
                    }
                }

                Spacer()

                if let score {
                    VStack(spacing: 2) {
                        Text("\(score)%")
                            .font(HZ.heading(20))
                            .foregroundColor(score >= 90 ? HZ.emerald : HZ.gold)
                        Text("best")
                            .font(HZ.mono(9))
                            .foregroundColor(HZ.muted)
                    }
                }
            }
        }
    }

    private var difficultyColor: Color {
        switch difficulty.lowercased() {
        case "hard": return HZ.coral
        case "medium": return HZ.gold
        default: return HZ.emerald
        }
    }
}

// MARK: - Practice Card

private struct HZPracticeButton: View {
    let icon: String
    let title: String
    let gradient: [Color]

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                )
            Text(title)
                .font(HZ.label(15))
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(HZ.cardBorder, lineWidth: 1)
        )
    }
}

// MARK: - Full Home Mockup

struct DesignMockup_Horizon: View {
    var body: some View {
        ZStack {
            HZBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Hero Header
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Good evening")
                                .font(HZ.body(15))
                                .foregroundColor(HZ.muted)
                            Text("Inspector\nTrainer")
                                .font(HZ.hero(34))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, HZ.gold],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                        Spacer()
                        HZProgressRing(progress: 0.65, level: 4)
                    }

                    // Hearts
                    HStack {
                        HZHearts(hearts: 4, max: 5)
                        Spacer()
                    }

                    // Stats Row
                    HZCard {
                        HStack {
                            HZStatOrb(icon: "flame.fill", value: "3", label: "Streak", color: HZ.coral)
                            Spacer()
                            HZStatOrb(icon: "sparkles", value: "485", label: "Total XP", color: HZ.gold)
                            Spacer()
                            HZStatOrb(icon: "target", value: "14/20", label: "Daily XP", color: HZ.emerald)
                        }
                    }

                    // Daily Progress
                    HZCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Daily Progress")
                                .font(HZ.heading(18))
                                .foregroundColor(.white)

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.white.opacity(0.1))
                                    Capsule()
                                        .fill(
                                            LinearGradient(colors: [HZ.gold, HZ.coral], startPoint: .leading, endPoint: .trailing)
                                        )
                                        .frame(width: geo.size.width * 0.7)
                                        .shadow(color: HZ.gold.opacity(0.3), radius: 6)
                                }
                            }
                            .frame(height: 10)

                            Text("6 XP until daily goal")
                                .font(HZ.body(13))
                                .foregroundColor(HZ.muted)
                        }
                    }

                    // Continue
                    Button {} label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Continue Training")
                                    .font(HZ.heading(16))
                                Text("Risk Management")
                                    .font(HZ.body(13))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            Spacer()
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 32))
                        }
                        .foregroundColor(.white)
                    }
                    .buttonStyle(HZButtonPrimary(gradient: [HZ.purple, HZ.electric]))

                    // Practice Zone
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Practice Zone")
                            .font(HZ.heading(20))
                            .foregroundColor(.white)

                        HZPracticeButton(icon: "bolt.fill", title: "Quick Drill", gradient: [HZ.purple, HZ.electric])
                        HZPracticeButton(icon: "checkmark.seal.fill", title: "Daily 5", gradient: [HZ.gold, HZ.coral])
                        HZPracticeButton(icon: "timer", title: "Match Sprint", gradient: [HZ.electric, HZ.emerald])
                        HZPracticeButton(icon: "bolt.circle", title: "True/False Blitz", gradient: [HZ.coral, HZ.purple])
                    }

                    // Modules
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Training Modules")
                            .font(HZ.heading(20))
                            .foregroundColor(.white)

                        HZModuleCard(
                            title: "Lockout/Tagout",
                            subtitle: "Energy isolation procedures",
                            difficulty: "Medium",
                            minutes: 8,
                            score: 94,
                            isComplete: true
                        )

                        HZModuleCard(
                            title: "Fall Protection",
                            subtitle: "Working at heights safety",
                            difficulty: "Hard",
                            minutes: 10,
                            score: nil,
                            isComplete: false
                        )

                        HZModuleCard(
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
                        .font(HZ.body(12))
                        .foregroundColor(HZ.muted)
                        .padding(.top, 8)
                }
                .padding(22)
            }
            .scrollIndicators(.hidden)
        }
    }
}

// MARK: - Tab Bar

struct HZTabBar: View {
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
                            .font(.system(size: 20, weight: selected == i ? .bold : .regular))
                            .symbolEffect(.bounce, value: selected == i)
                        Text(tabs[i].label)
                            .font(HZ.body(10))
                    }
                    .foregroundColor(selected == i ? .white : .white.opacity(0.4))
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Preview

#Preview("Design 2: Horizon") {
    VStack(spacing: 0) {
        DesignMockup_Horizon()
        HZTabBar()
    }
    .preferredColorScheme(.dark)
}
