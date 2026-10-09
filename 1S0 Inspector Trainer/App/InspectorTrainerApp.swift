import SwiftUI

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
