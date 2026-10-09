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
    @State private var learnPath: [HomeDeepLinkDestination] = []
    @State private var practicePath: [HomeDeepLinkDestination] = []
    @State private var refsPath: [RefsDeepLinkDestination] = []

    var body: some View {
        ZStack {
            AppTheme.bg.ignoresSafeArea()

            TabView(selection: $selectedTab) {
                NavigationStack(path: $homePath) {
                    HomeView()
                }
                .tabItem {
                    Label("Today", systemImage: "sun.max")
                        .accessibilityLabel("Today")
                }
                .tag(0)

                NavigationStack(path: $learnPath) { LearnView().navigationDestination(for: HomeDeepLinkDestination.self, destination: trainingDestination) }
                    .tabItem { Label("Learn", systemImage: "book.closed") }.tag(1)

                NavigationStack(path: $practicePath) { PracticeHubView().navigationDestination(for: HomeDeepLinkDestination.self, destination: trainingDestination) }
                    .tabItem { Label("Practice", systemImage: "scope") }.tag(2)

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
                    Label("Library", systemImage: "books.vertical")
                        .accessibilityLabel("References")
                }
                .tag(3)

                NavigationStack {
                    ProgressDashboardView()
                }
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.xaxis")
                        .accessibilityLabel("Progress")
                }
                .tag(4)
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

    @ViewBuilder private func trainingDestination(_ destination: HomeDeepLinkDestination) -> some View {
        switch destination {
        case .module(let id):
            if let module = TrainingContent.modules(for: progress.selectedRole).first(where: { $0.id == id }) {
                ModuleDetailView(module: module)
            } else { ModuleUnavailableView(moduleId: id) }
        case .dailyFive: PracticeSessionView()
        }
    }

    private func configureTacticalTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(AppTheme.surface)

        let normalColor = UIColor(AppTheme.text.opacity(0.65))
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
            selectedTab = 1
            learnPath = [.module(moduleId)]
        case .dailyFive:
            selectedTab = 2
            practicePath = [.dailyFive]
        case .publication(let publicationId):
            selectedTab = 3
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
                        .font(AppFont.body(16))
                        .foregroundColor(AppTheme.text.opacity(0.68))
                }
            }
            .tacticalReadableWidth()
            .padding(AppSpacing.screenPadding)
        }
        .navigationTitle("Module")
        .navigationBarTitleDisplayMode(.inline)
    }
}
