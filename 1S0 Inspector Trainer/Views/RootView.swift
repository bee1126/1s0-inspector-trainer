import SwiftUI

struct RootView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var selectedTab: Int = 0
    @State private var showRoleSelection = false

    private let swipeThreshold: CGFloat = 120

    var body: some View {
        ZStack {
            AppTheme.bg.ignoresSafeArea()

            TabView(selection: $selectedTab) {
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Label("HQ", systemImage: "shield.lefthalf.filled")
                }
                .tag(0)

                NavigationStack {
                    ProgressDashboardView()
                }
                .tabItem {
                    Label("Intel", systemImage: "chart.bar.xaxis")
                }
                .tag(1)

                NavigationStack {
                    SourcesView()
                }
                .tabItem {
                    Label("Refs", systemImage: "book")
                }
                .tag(2)

                NavigationStack {
                    ToolsView()
                }
                .tabItem {
                    Label("Comms", systemImage: "bubble.left.and.bubble.right")
                }
                .tag(3)
            }
            .tint(AppTheme.primary)
            .simultaneousGesture(
                DragGesture(minimumDistance: 30)
                    .onEnded { value in
                        let horizontal = value.translation.width
                        guard abs(horizontal) > swipeThreshold else { return }
                        withAnimation {
                            if horizontal < 0 {
                                selectedTab = min(selectedTab + 1, 3)
                            } else {
                                selectedTab = max(selectedTab - 1, 0)
                            }
                        }
                    }
            )
        }
        .onAppear {
            configureTacticalTabBar()
            if progress.selectedRole == nil {
                showRoleSelection = true
            }
            progress.refreshForNewDayIfNeeded()
        }
        .fullScreenCover(isPresented: $showRoleSelection) {
            RoleSelectionView(
                title: "Select Your Role",
                subtitle: "Choose the training path for your position.",
                onSelect: { role in
                    progress.setRole(role)
                    showRoleSelection = false
                }
            )
        }
        .preferredColorScheme(.dark)
    }

    private func configureTacticalTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(AppTheme.surface)

        let normalColor = UIColor(AppTheme.muted)
        let selectedColor = UIColor(AppTheme.primary)

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = normalColor
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
        itemAppearance.selected.iconColor = selectedColor
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]

        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        tabBarAppearance.inlineLayoutAppearance = itemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = itemAppearance

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        // Navigation bar
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(AppTheme.surface)
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.text)]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(AppTheme.text)]

        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().tintColor = UIColor(AppTheme.primary)
    }
}
