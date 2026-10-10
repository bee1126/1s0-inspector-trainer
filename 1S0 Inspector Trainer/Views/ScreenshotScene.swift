#if DEBUG
import SwiftUI

/// Debug-only entry points for reproducible simulator QA. Release builds never include this view.
struct ScreenshotScene: View {
    let screen: String
    @EnvironmentObject private var progress: ProgressStore
    private var exampleQuestion: QuizQuestion { progress.catalog.questions.first { $0.id == "wws-q1" }! }
    var body: some View {
        if screen == "picker" { TrackPickerView() }
        else if screen == "today" { RootView() }
        else if screen == "catalog" || screen == "airforce" { RootView(initialTab: 1) }
        else if screen == "progress" { RootView(initialTab: 4) }
        else if screen == "hazard" { LocalHazardEditor(report: Self.report, store: LocalHazardReportStore(directory: FileManager.default.temporaryDirectory.appendingPathComponent("SafetyFluent-screenshot-reports"))) }
        else { NavigationStack {
            switch screen {
            case "builder": StudyBuilderView()
            case "quiz":
                ZStack { BackgroundView(); ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Walking-Working Surfaces").font(.title2.bold())
                        StudyQuestionCard(question: StudyQuestion(exampleQuestion, shuffle: false), selectedID: exampleQuestion.choices.first!.id, reveal: true, locked: true, onSelect: { _ in })
                    }.tacticalReadableWidth().padding(20)
                } }.navigationTitle("Study").navigationBarTitleDisplayMode(.inline)
            case "debrief":
                if let entry = progress.studyHistory.first { ZStack { BackgroundView(); StudyDebriefView(entry: entry) }.navigationTitle("Exam debrief").navigationBarTitleDisplayMode(.inline) }
            default: HomeView()
            }
        } }
    }
    static var report: LocalHazardReport {
        var report = LocalHazardReport(); report.location = "Warehouse • Loading area"; report.description = "Damaged flooring on the pedestrian route near the loading bay."
        report.category = "Walking-working surfaces"; report.standard = "29 CFR 1910.22"; report.employeesExposed = 6; report.severity = .serious; report.likelihood = .possible
        report.interimControls = "Barrier installed; alternate route marked."; report.correctiveAction = "Repair the damaged floor and verify before reopening."; report.controlTypes = ["Engineering", "Administrative"]; report.owner = "Facilities supervisor"; report.status = "Interim controls in place"
        return report
    }
}
#endif
