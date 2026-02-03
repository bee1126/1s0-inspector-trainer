import SwiftUI

struct ToolsView: View {
    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Feedback")
                        .font(AppFont.title(26))
                        .foregroundColor(.white)

                    ToolSection(title: "Feedback") {
                        NavigationLink { BugReportView() } label: {
                            ToolCard(title: "Bug Fix Reports", detail: "Capture issues to share with the dev team")
                        }
                        NavigationLink { FeatureRequestView() } label: {
                            ToolCard(title: "Feature Requests", detail: "Submit ideas for future updates")
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Feedback")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ToolSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(AppFont.subtitle(18))
                .foregroundColor(.white)
            content
        }
    }
}

struct ToolCard: View {
    let title: String
    let detail: String

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(AppFont.subtitle(17))
                    .foregroundColor(AppTheme.charcoal)
                Text(detail)
                    .font(AppFont.body(13))
                    .foregroundColor(AppTheme.charcoal.opacity(0.7))
            }
        }
    }
}

// MARK: Daily 5

struct DailyFiveView: View {
    @EnvironmentObject private var progress: ProgressStore

    private var questions: [QuizQuestion] {
        let pool = TrainingContent.modules.flatMap { $0.quiz }
        let shuffled = pool.shuffled()
        return Array(shuffled.prefix(5))
    }

    @State private var result: Result? = nil

    var body: some View {
        ZStack {
            BackgroundView()

            if let result {
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Daily 5 Complete")
                            .font(AppFont.title(22))
                            .foregroundColor(AppTheme.charcoal)
                        Text("Score: \(result.score)/\(result.total)")
                            .font(AppFont.subtitle(16))
                            .foregroundColor(AppTheme.charcoal)
                        Text("Streak: \(progress.dailyStreak) days")
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.charcoal.opacity(0.7))
                        Button("Run Another Daily 5") {
                            self.result = nil
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .padding(20)
            } else {
                QuizFlowView(questions: questions, onComplete: { result in
                    progress.recordDailyFive(score: result.score, total: result.total)
                    self.result = result
                }, shuffleQuestions: true, maxQuestions: 5)
            }
        }
        .navigationTitle("Daily 5")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: Hazard Spot-Check

struct HazardSpotCheckView: View {
    private let drills: [HazardDrill] = [
        HazardDrill(
            id: "haz-1",
            title: "Unguarded Shaft",
            systemImage: "gearshape.2",
            imageName: "HazardShaft",
            prompt: "Identify the primary hazard.",
            options: [
                HazardOption(id: "haz-1-a", text: "Unguarded rotating shaft", isCorrect: true),
                HazardOption(id: "haz-1-b", text: "Noise exposure only", isCorrect: false),
                HazardOption(id: "haz-1-c", text: "Chemical spill", isCorrect: false)
            ]
        ),
        HazardDrill(
            id: "haz-2",
            title: "Improper Ladder",
            systemImage: "ladder",
            imageName: "HazardLadder",
            prompt: "Identify the primary hazard.",
            options: [
                HazardOption(id: "haz-2-a", text: "Ladder not secured / wrong angle", isCorrect: true),
                HazardOption(id: "haz-2-b", text: "Trip hazard from tape", isCorrect: false),
                HazardOption(id: "haz-2-c", text: "Electrical shock", isCorrect: false)
            ]
        ),
        HazardDrill(
            id: "haz-3",
            title: "Compressed Gas",
            systemImage: "cylinder",
            imageName: "HazardCylinder",
            prompt: "Identify the primary hazard.",
            options: [
                HazardOption(id: "haz-3-a", text: "Cylinder not secured", isCorrect: true),
                HazardOption(id: "haz-3-b", text: "Slip hazard only", isCorrect: false),
                HazardOption(id: "haz-3-c", text: "Fire extinguisher missing", isCorrect: false)
            ]
        )
    ]

    @State private var index = 0
    @State private var selectedId: String? = nil
    @State private var score = 0
    @State private var showFeedback = false

    var body: some View {
        let drill = drills[index]

        ZStack {
            BackgroundView()

            GlassCard {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Hazard Spot-Check")
                        .font(AppFont.mono(12))
                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
                    Text(drill.title)
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.charcoal)

                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(AppTheme.sky.opacity(0.35))
                            .frame(height: 160)
                        if let imageName = drill.imageName {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        } else {
                            Image(systemName: drill.systemImage)
                                .font(.system(size: 56))
                                .foregroundColor(AppTheme.blue)
                        }
                    }

                    Text(drill.prompt)
                        .font(AppFont.subtitle(16))
                        .foregroundColor(AppTheme.charcoal)

                    ForEach(drill.options, id: \.id) { option in
                        OptionRow(
                            text: option.text,
                            isSelected: selectedId == option.id,
                            isCorrect: option.isCorrect,
                            isLocked: selectedId != nil,
                            revealCorrect: true
                        )
                        .onTapGesture {
                            guard selectedId == nil else { return }
                            selectedId = option.id
                            if option.isCorrect { score += 1 }
                            showFeedback = true
                        }
                    }

                    if showFeedback {
                        Button(index == drills.count - 1 ? "Finish" : "Next") {
                            advance()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }

                    Text("Score: \(score)/\(drills.count)")
                        .font(AppFont.body(12))
                        .foregroundColor(AppTheme.charcoal.opacity(0.6))
                }
            }
            .padding(20)
        }
        .navigationTitle("Spot-Check")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func advance() {
        if index == drills.count - 1 {
            index = 0
            score = 0
        } else {
            index += 1
        }
        selectedId = nil
        showFeedback = false
    }
}

struct HazardDrill: Identifiable {
    let id: String
    let title: String
    let systemImage: String
    let imageName: String?
    let prompt: String
    let options: [HazardOption]
}

struct HazardOption: Identifiable {
    let id: String
    let text: String
    let isCorrect: Bool
}

// MARK: Checklist Mode

struct ChecklistModeView: View {
    @State private var items = ChecklistItem.sample

    var body: some View {
        ZStack {
            BackgroundView()

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Inspect This Shop")
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.charcoal)
                    Text("Mark each item as compliant, needs attention, or not applicable.")
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.charcoal.opacity(0.7))

                    ForEach($items) { $item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.title)
                                .font(AppFont.subtitle(14))
                                .foregroundColor(AppTheme.charcoal)
                            HStack(spacing: 8) {
                                ChecklistChip(label: "OK", isSelected: item.status == .ok) {
                                    item.status = .ok
                                }
                                ChecklistChip(label: "Needs Fix", isSelected: item.status == .needsFix) {
                                    item.status = .needsFix
                                }
                                ChecklistChip(label: "N/A", isSelected: item.status == .na) {
                                    item.status = .na
                                }
                            }
                        }
                        Divider().opacity(0.3)
                    }

                    Text("Score: \(score)%")
                        .font(AppFont.subtitle(16))
                        .foregroundColor(AppTheme.blue)
                }
            }
            .padding(20)
        }
        .navigationTitle("Checklist")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var score: Int {
        let applicable = items.filter { $0.status != .na }
        guard !applicable.isEmpty else { return 0 }
        let okCount = applicable.filter { $0.status == .ok }.count
        return Int(round(Double(okCount) / Double(applicable.count) * 100))
    }
}

struct ChecklistItem: Identifiable {
    enum Status { case ok, needsFix, na }

    let id: String
    let title: String
    var status: Status

    static let sample: [ChecklistItem] = [
        ChecklistItem(id: "chk-1", title: "Exit routes clear and marked", status: .ok),
        ChecklistItem(id: "chk-2", title: "LOTO devices available and in use", status: .ok),
        ChecklistItem(id: "chk-3", title: "PPE worn correctly", status: .ok),
        ChecklistItem(id: "chk-4", title: "Hazard signage posted", status: .ok),
        ChecklistItem(id: "chk-5", title: "Housekeeping standards met", status: .ok)
    ]
}

struct ChecklistChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(label) {
            action()
        }
        .font(AppFont.mono(11))
        .foregroundColor(isSelected ? .white : AppTheme.charcoal)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule().fill(isSelected ? AppTheme.blue : Color.white.opacity(0.9))
        )
    }
}

// MARK: Red Team

struct RedTeamView: View {
    private let findings: [RedTeamFinding] = [
        RedTeamFinding(id: "red-1", text: "LOTO applied before servicing begins.", isIssue: false),
        RedTeamFinding(id: "red-2", text: "No evidence of fall protection plan for roof work.", isIssue: true),
        RedTeamFinding(id: "red-3", text: "Hazard abatement dates assigned and tracked.", isIssue: false),
        RedTeamFinding(id: "red-4", text: "RAC assigned without probability assessment.", isIssue: true),
        RedTeamFinding(id: "red-5", text: "PPE inspection logs are current.", isIssue: false),
        RedTeamFinding(id: "red-6", text: "Confined space entry permit missing.", isIssue: true)
    ]

    @State private var selected: Set<String> = []
    @State private var submitted = false

    var body: some View {
        ZStack {
            BackgroundView()

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Red Team Report")
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.charcoal)
                    Text("Select the statements that represent issues.")
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.charcoal.opacity(0.7))

                    ForEach(findings, id: \.id) { finding in
                        Button {
                            toggle(finding.id)
                        } label: {
                            HStack {
                                Image(systemName: selected.contains(finding.id) ? "checkmark.circle.fill" : "circle")
                                Text(finding.text)
                                    .font(AppFont.body(13))
                                Spacer()
                            }
                            .foregroundColor(AppTheme.charcoal)
                        }
                        .buttonStyle(.plain)
                    }

                    Button(submitted ? "Results" : "Submit") {
                        submitted = true
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    if submitted {
                        Text("Score: \(score)/\(findings.filter { $0.isIssue }.count)")
                            .font(AppFont.subtitle(16))
                            .foregroundColor(AppTheme.blue)
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Red Team")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var score: Int {
        let issues = findings.filter { $0.isIssue }.map { $0.id }
        return issues.filter { selected.contains($0) }.count
    }

    private func toggle(_ id: String) {
        if selected.contains(id) {
            selected.remove(id)
        } else {
            selected.insert(id)
        }
    }
}

struct RedTeamFinding: Identifiable {
    let id: String
    let text: String
    let isIssue: Bool
}

// MARK: JHA Builder

struct JhaBuilderView: View {
    @State private var taskName = ""
    @State private var hazards = ""
    @State private var controls = ""
    @State private var shareItems: [Any] = []
    @State private var showShare = false

    var body: some View {
        ZStack {
            BackgroundView()

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("JHA Builder")
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.charcoal)

                    TextField("Task name", text: $taskName)
                        .textFieldStyle(.roundedBorder)

                    Text("Hazards")
                        .font(AppFont.subtitle(14))
                    TextEditor(text: $hazards)
                        .frame(height: 90)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

                    Text("Controls")
                        .font(AppFont.subtitle(14))
                    TextEditor(text: $controls)
                        .frame(height: 90)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

                    Button("Share JHA Draft") {
                        let text = "JHA Draft\nTask: \(taskName)\nHazards: \(hazards)\nControls: \(controls)"
                        shareItems = [text]
                        showShare = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(20)
        }
        .sheet(isPresented: $showShare) {
            ShareSheet(activityItems: shareItems)
        }
        .navigationTitle("JHA")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: Safety Briefing

struct SafetyBriefingView: View {
    @State private var selectedModuleId = TrainingContent.modules.first?.id ?? ""
    @State private var shareItems: [Any] = []
    @State private var showShare = false

    var body: some View {
        ZStack {
            BackgroundView()

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Safety Briefing")
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.charcoal)

                    Picker("Module", selection: $selectedModuleId) {
                        ForEach(TrainingContent.modules, id: \.id) { module in
                            Text(module.title).tag(module.id)
                        }
                    }
                    .pickerStyle(.menu)

                    Text("Briefing Outline")
                        .font(AppFont.subtitle(14))
                    Text(briefingText)
                        .font(AppFont.body(13))
                        .foregroundColor(AppTheme.charcoal.opacity(0.75))

                    Button("Share Briefing") {
                        shareItems = [briefingText]
                        showShare = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(20)
        }
        .sheet(isPresented: $showShare) {
            ShareSheet(activityItems: shareItems)
        }
        .navigationTitle("Briefing")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var briefingText: String {
        guard let module = TrainingContent.modules.first(where: { $0.id == selectedModuleId }) else {
            return "Select a module to generate a briefing."
        }
        let objectives = module.objectives.prefix(3).joined(separator: "; ")
        return "Briefing for \(module.title):\n- Focus: \(module.subtitle)\n- Objectives: \(objectives)\n- Emphasize risk controls and verify understanding."
    }
}

// MARK: PPE Decision Tree

struct PpeDecisionTreeView: View {
    @State private var step: Int = 0
    @State private var responses: [String] = []

    var body: some View {
        ZStack {
            BackgroundView()

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("PPE Decision Tree")
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.charcoal)

                    if step < questions.count {
                        Text(questions[step])
                            .font(AppFont.subtitle(16))
                            .foregroundColor(AppTheme.charcoal)
                        HStack {
                            Button("Yes") { answer("Yes") }
                                .buttonStyle(PrimaryButtonStyle())
                            Button("No") { answer("No") }
                                .buttonStyle(OutlineButtonStyle())
                        }
                    } else {
                        Text("Recommended PPE")
                            .font(AppFont.subtitle(16))
                        Text(recommendation)
                            .font(AppFont.body(13))
                            .foregroundColor(AppTheme.charcoal.opacity(0.75))
                        Button("Restart") {
                            step = 0
                            responses = []
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("PPE")
        .navigationBarTitleDisplayMode(.inline)
    }

    private let questions: [String] = [
        "Is there a risk of falling objects or head impact?",
        "Is there a risk of flying particles or chemical splash?",
        "Is there a risk of respiratory exposure?",
        "Is there a risk of high noise levels?"
    ]

    private var recommendation: String {
        var ppe: [String] = []
        if responses.indices.contains(0), responses[0] == "Yes" { ppe.append("Hard hat") }
        if responses.indices.contains(1), responses[1] == "Yes" { ppe.append("Eye/face protection") }
        if responses.indices.contains(2), responses[2] == "Yes" { ppe.append("Respiratory protection") }
        if responses.indices.contains(3), responses[3] == "Yes" { ppe.append("Hearing protection") }
        if ppe.isEmpty { ppe.append("Standard PPE and task-specific controls") }
        return ppe.joined(separator: ", ")
    }

    private func answer(_ value: String) {
        responses.append(value)
        step += 1
    }
}

// MARK: Feedback Forms

struct BugReportView: View {
    @State private var title = ""
    @State private var steps = ""
    @State private var expected = ""
    @State private var actual = ""
    @State private var shareItems: [Any] = []
    @State private var showShare = false

    var body: some View {
        ZStack {
            BackgroundView()

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Bug Fix Report")
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.charcoal)

                    TextField("Short title", text: $title)
                        .textFieldStyle(.roundedBorder)

                    Text("Steps to reproduce")
                        .font(AppFont.subtitle(14))
                    TextEditor(text: $steps)
                        .frame(height: 90)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

                    Text("Expected result")
                        .font(AppFont.subtitle(14))
                    TextEditor(text: $expected)
                        .frame(height: 70)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

                    Text("Actual result")
                        .font(AppFont.subtitle(14))
                    TextEditor(text: $actual)
                        .frame(height: 70)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

                    Button("Share Bug Report") {
                        let text = """
Bug Report
Title: \(title)
Steps: \(steps)
Expected: \(expected)
Actual: \(actual)
"""
                        shareItems = [text]
                        showShare = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(20)
        }
        .sheet(isPresented: $showShare) {
            ShareSheet(activityItems: shareItems)
        }
        .navigationTitle("Bug Report")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRequestView: View {
    @State private var title = ""
    @State private var value = ""
    @State private var details = ""
    @State private var shareItems: [Any] = []
    @State private var showShare = false

    var body: some View {
        ZStack {
            BackgroundView()

            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Feature Request")
                        .font(AppFont.title(22))
                        .foregroundColor(AppTheme.charcoal)

                    TextField("Feature title", text: $title)
                        .textFieldStyle(.roundedBorder)

                    Text("Why this helps")
                        .font(AppFont.subtitle(14))
                    TextEditor(text: $value)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

                    Text("Details")
                        .font(AppFont.subtitle(14))
                    TextEditor(text: $details)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

                    Button("Share Feature Request") {
                        let text = """
Feature Request
Title: \(title)
Why it helps: \(value)
Details: \(details)
"""
                        shareItems = [text]
                        showShare = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(20)
        }
        .sheet(isPresented: $showShare) {
            ShareSheet(activityItems: shareItems)
        }
        .navigationTitle("Feature")
        .navigationBarTitleDisplayMode(.inline)
    }
}
