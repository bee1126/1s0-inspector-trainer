import SwiftUI

@main
struct InspectorTrainerApp: App {
    @StateObject private var progress = ProgressStore()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(progress)
        }
    }
}
