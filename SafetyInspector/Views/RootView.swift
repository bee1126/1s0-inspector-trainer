import SwiftUI

struct RootView: View {
    @StateObject private var progress = ProgressStore()

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "shield.lefthalf.filled")
            }

            NavigationStack {
                ModuleListView()
            }
            .tabItem {
                Label("Modules", systemImage: "square.grid.2x2")
            }

            NavigationStack {
                ProgressDashboardView()
            }
            .tabItem {
                Label("Progress", systemImage: "chart.bar.xaxis")
            }

            NavigationStack {
                SourcesView()
            }
            .tabItem {
                Label("Sources", systemImage: "book")
            }
        }
        .tint(AppTheme.blue)
        .environmentObject(progress)
    }
}
