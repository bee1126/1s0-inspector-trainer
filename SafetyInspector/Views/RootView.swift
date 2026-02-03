import SwiftUI

struct RootView: View {
    @StateObject private var progress = ProgressStore()
    @State private var showSplash = true

    var body: some View {
        ZStack {
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

            NavigationStack {
                ToolsView()
            }
            .tabItem {
                Label("Tools", systemImage: "wrench.and.screwdriver")
            }
        }
            .tint(AppTheme.blue)
            .environmentObject(progress)

            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .zIndex(10)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeOut(duration: 0.45)) {
                    showSplash = false
                }
            }
        }
    }
}

struct SplashView: View {
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

                Text("1S0 Inspector Trainer")
                    .font(AppFont.title(24))
                    .foregroundColor(.white)

                Text("Mission-ready safety training")
                    .font(AppFont.body(14))
                    .foregroundColor(Color.white.opacity(0.8))
            }
        }
    }
}
