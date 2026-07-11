import SwiftUI

enum AppDeepLink: Equatable {
    case home
    case module(String)
    case dailyFive
    case publication(String)
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
        case "reference", "epubs":
            if let publicationId = pathComponents.first,
               EpubsCatalog.publication(id: publicationId) != nil {
                target = .publication(publicationId)
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
    @StateObject private var adaptiveManager = AdaptiveDifficultyManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(progress)
                .environmentObject(deepLinkRouter)
                .environmentObject(adaptiveManager)
                .onOpenURL { url in
                    deepLinkRouter.handle(url: url)
                }
        }
    }
}
