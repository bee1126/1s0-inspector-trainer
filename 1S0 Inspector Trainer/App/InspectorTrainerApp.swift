import SwiftUI

@main
struct InspectorTrainerApp: App {
    @StateObject private var progress = InspectorTrainerApp.makeProgress()
    @StateObject private var deepLinkRouter = DeepLinkRouter()
    @StateObject private var adaptiveManager = AdaptiveDifficultyManager()

    var body: some Scene {
        WindowGroup {
            appContent
                #if DEBUG
                .preferredColorScheme(ProcessInfo.processInfo.environment["SAFETYFLUENT_QA_DARK"] == "1" ? .dark : nil)
                #endif
                .environmentObject(progress)
                .environmentObject(deepLinkRouter)
                .environmentObject(adaptiveManager)
                .onOpenURL { url in
                    deepLinkRouter.handle(url: url)
                }
        }
    }

    @ViewBuilder private var appContent: some View {
        #if DEBUG
        if let screen = ProcessInfo.processInfo.environment["SAFETYFLUENT_SCREENSHOT"] { ScreenshotScene(screen: screen) }
        else { RootView() }
        #else
        RootView()
        #endif
    }
    private static func makeProgress() -> ProgressStore {
        #if DEBUG
        let env = ProcessInfo.processInfo.environment
        if let testID = env["SAFETYFLUENT_UI_TEST"] ?? env["SAFETYFLUENT_SCREENSHOT"] {
            let suite = "SafetyFluent.QA." + testID
            let defaults = UserDefaults(suiteName: suite)!
            defaults.removePersistentDomain(forName: suite)
            if let encoded = env["SAFETYFLUENT_LEGACY_FIXTURE"], let data = Data(base64Encoded: encoded),
               let values = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] {
                values.forEach { defaults.set($0.value, forKey: $0.key) }
            }
            let store = ProgressStore(defaults: defaults)
            if let screen = env["SAFETYFLUENT_SCREENSHOT"], screen != "picker" {
                store.selectTrack(screen == "airforce" ? .airForce : .osha)
                store.dismissTrackBanner()
                if screen == "debrief" || screen == "progress" || screen == "today" {
                    let bank = store.catalog.questions.filter { ["wws", "ppeha"].contains(ModuleHelper.moduleID(for: $0.id)) }
                    _ = store.startStudySession(configuration: StudyConfiguration(mode: .exam, questionCount: 10), questions: bank)
                    if let session = store.activeStudySession {
                        for (index, question) in session.questions.enumerated() {
                            let choice = question.choices.first { $0.isCorrect == (index < 8) }!
                            store.selectStudyAnswer(questionID: question.id, choiceID: choice.id)
                        }
                        _ = store.finishStudySession(id: session.id, questions: bank)
                    }
                    store.markCompleted(moduleId: "ppeha", score: 90, scenarioPerfect: true, quizPerfect: false)
                }
            }
            return store
        }
        #endif
        return ProgressStore()
    }
}
