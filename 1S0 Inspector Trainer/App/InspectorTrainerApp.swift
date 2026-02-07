import SwiftUI

enum AppDeepLink: Equatable {
    case home
    case dailyFive
    case module(String)
}

final class DeepLinkRouter: ObservableObject {
    @Published var target: AppDeepLink?

    func handle(url: URL) {
        guard url.scheme?.lowercased() == "inspectortrainer" else { return }
        let host = url.host?.lowercased() ?? ""
        let pathComponents = url.pathComponents.filter { $0 != "/" }

        switch host {
        case "home":
            target = .home
        case "practice":
            if pathComponents.first?.lowercased() == "daily-five" {
                target = .dailyFive
            }
        case "module":
            if let moduleId = pathComponents.first, !moduleId.isEmpty {
                target = .module(moduleId)
            }
        default:
            break
        }
    }
}

@main
struct InspectorTrainerApp: App {
    @StateObject private var progress = ProgressStore()
    @StateObject private var deepLinkRouter = DeepLinkRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(progress)
                .environmentObject(deepLinkRouter)
                .onOpenURL { url in
                    deepLinkRouter.handle(url: url)
                }
        }
    }
}
