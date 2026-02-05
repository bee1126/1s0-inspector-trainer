import SwiftUI

struct RootView: View {
    @StateObject private var progress = ProgressStore()
    @State private var showSplash = true
    @State private var selectedTab: RootTab = .home
    @State private var showRoleSelection = false
    private let swipeThreshold: CGFloat = 120

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Label("Home", systemImage: "shield.lefthalf.filled")
                }
                .tag(RootTab.home)

                NavigationStack {
                    ProgressDashboardView()
                }
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.xaxis")
                }
                .tag(RootTab.progress)

                NavigationStack {
                    SourcesView()
                }
                .tabItem {
                    Label("Sources", systemImage: "book")
                }
                .tag(RootTab.sources)

                NavigationStack {
                    ToolsView()
                }
                .tabItem {
                    Label("Feedback", systemImage: "bubble.left.and.bubble.right")
                }
                .tag(RootTab.feedback)
            }
            .tint(AppTheme.blue)
            .environmentObject(progress)
            .simultaneousGesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        handleTabSwipe(value)
                    }
            )

            if showSplash {
                SplashView(title: progress.selectedRole?.appTitle ?? "Inspector Trainer")
                    .transition(.opacity)
                    .zIndex(10)
            }
        }
        .onAppear {
            progress.refreshForNewDayIfNeeded()
            if progress.selectedRole == nil {
                showRoleSelection = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeOut(duration: 0.45)) {
                    showSplash = false
                }
            }
        }
        .fullScreenCover(isPresented: $showRoleSelection) {
            RoleSelectionView(
                title: "Choose Your Role",
                subtitle: "We'll tailor lessons and questions to your program.",
                onSelect: { role in
                    progress.setRole(role)
                    showRoleSelection = false
                }
            )
            .interactiveDismissDisabled()
        }
    }

    private func handleTabSwipe(_ value: DragGesture.Value) {
        let horizontal = value.translation.width
        let vertical = value.translation.height
        guard abs(horizontal) > abs(vertical) else { return }
        guard abs(horizontal) > swipeThreshold else { return }

        let allTabs = RootTab.allCases
        guard let currentIndex = allTabs.firstIndex(of: selectedTab) else { return }

        if horizontal < 0, currentIndex < allTabs.count - 1 {
            selectedTab = allTabs[currentIndex + 1]
        } else if horizontal > 0, currentIndex > 0 {
            selectedTab = allTabs[currentIndex - 1]
        }
    }
}

enum RootTab: Int, CaseIterable {
    case home
    case progress
    case sources
    case feedback
}

struct SplashView: View {
    let title: String

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .overlay(
                    RadialGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.25), Color.clear]),
                        center: .topTrailing,
                        startRadius: 10,
                        endRadius: 220
                    )
                )
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 110, height: 110)
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        .frame(width: 110, height: 110)
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 46))
                        .foregroundColor(.white)
                }

                Text(title)
                    .font(AppFont.title(24))
                    .foregroundColor(.white)

                Text("Daily missions, XP, and streaks")
                    .font(AppFont.body(14))
                    .foregroundColor(Color.white.opacity(0.8))
            }
        }
    }
}
