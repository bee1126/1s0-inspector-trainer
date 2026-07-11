import SwiftUI

enum HomeDeepLinkDestination: Hashable {
    case module(String)
    case dailyFive
}

enum RefsDeepLinkDestination: Hashable {
    case publication(String)
}

struct RootView: View {
    @EnvironmentObject private var progress: ProgressStore
    @EnvironmentObject private var deepLinkRouter: DeepLinkRouter
    @State private var selectedTab: Int = 0
    @State private var homePath: [HomeDeepLinkDestination] = []
    @State private var refsPath: [RefsDeepLinkDestination] = []

    var body: some View {
        ZStack {
            AppTheme.bg.ignoresSafeArea()

            TabView(selection: $selectedTab) {
                NavigationStack(path: $homePath) {
                    HomeView()
                        .navigationDestination(for: HomeDeepLinkDestination.self) { destination in
                            switch destination {
                            case .module(let moduleId):
                                if let module = TrainingContent.modules(for: progress.selectedRole)
                                    .first(where: { $0.id == moduleId }) {
                                    ModuleDetailView(module: module)
                                } else {
                                    ModuleUnavailableView(moduleId: moduleId)
                                }
                            case .dailyFive:
                                PracticeSessionView()
                            }
                        }
                }
                .tabItem {
                    Label("HQ", systemImage: "shield.lefthalf.filled")
                        .accessibilityLabel("HQ Home")
                }
                .tag(0)

                NavigationStack {
                    ProgressDashboardView()
                }
                .tabItem {
                    Label("Intel", systemImage: "chart.bar.xaxis")
                        .accessibilityLabel("Intel Progress")
                }
                .tag(1)

                NavigationStack(path: $refsPath) {
                    SourcesView()
                        .navigationDestination(for: RefsDeepLinkDestination.self) { destination in
                            switch destination {
                            case .publication(let publicationId):
                                EpubsLibraryView(focusPublicationId: publicationId)
                            }
                        }
                }
                .tabItem {
                    Label("Refs", systemImage: "book")
                        .accessibilityLabel("References")
                }
                .tag(2)

                NavigationStack {
                    ToolsView()
                }
                .tabItem {
                    Label("Comms", systemImage: "bubble.left.and.bubble.right")
                        .accessibilityLabel("Comms Feedback")
                }
                .tag(3)
            }
            .tint(AppTheme.primary)
        }
        .onAppear {
            configureTacticalTabBar()
            progress.refreshForNewDayIfNeeded()
            handleDeepLinkTarget(deepLinkRouter.target)
        }
        .onChange(of: deepLinkRouter.target) { _, target in
            handleDeepLinkTarget(target)
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

    private func handleDeepLinkTarget(_ target: AppDeepLink?) {
        guard let target else { return }

        switch target {
        case .home:
            selectedTab = 0
            homePath = []
        case .module(let moduleId):
            selectedTab = 0
            homePath = [.module(moduleId)]
        case .dailyFive:
            selectedTab = 0
            homePath = [.dailyFive]
        case .publication(let publicationId):
            selectedTab = 2
            refsPath = [.publication(publicationId)]
        }

        DispatchQueue.main.async {
            deepLinkRouter.target = nil
        }
    }
}

private struct ModuleUnavailableView: View {
    let moduleId: String

    var body: some View {
        ZStack {
            BackgroundView()
            GlassCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Module Unavailable")
                        .font(AppFont.subtitle(18))
                        .foregroundColor(AppTheme.text)
                    Text("No module found for id: \(moduleId)")
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.muted)
                }
            }
            .tacticalReadableWidth()
            .padding(AppSpacing.screenPadding)
        }
        .navigationTitle("Module")
        .navigationBarTitleDisplayMode(.inline)
    }
}
