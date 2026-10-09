import SwiftUI

struct LocalHazardReportsView: View {
    @StateObject private var store = LocalHazardReportStore()
    @State private var editing: LocalHazardReport?
    @State private var deleteID: UUID?
    @State private var error: String?
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Hazard Report & Risk Matrix").font(.title2.bold())
                    Text("Records stay on this device. Share only when you choose.").foregroundStyle(.secondary)
                    Button("New report", systemImage: "plus") { editing = LocalHazardReport() }.buttonStyle(.borderedProminent)
                    if let message = store.errorMessage ?? error { Text(message).foregroundStyle(AppTheme.danger) }
                    ForEach(store.reports) { report in
                        GlassCard { VStack(alignment: .leading, spacing: 12) {
                            Button { editing = report } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(report.location.isEmpty ? "Untitled location" : report.location).font(.headline)
                                    Text(report.description).lineLimit(3)
                                    Text("\(report.risk.rawValue) · \(report.status)").font(.subheadline).foregroundStyle(.secondary)
                                }.frame(maxWidth: .infinity, alignment: .leading)
                            }.buttonStyle(.plain)
                            Button("Delete", role: .destructive) { deleteID = report.id }
                        } }
                    }
                    Text(ExampleRiskMatrix.disclaimer).font(.footnote).foregroundStyle(.secondary)
                }.tacticalReadableWidth().padding(20)
            }
        }.navigationTitle("Hazard reports").navigationBarTitleDisplayMode(.inline)
            .onAppear { store.reload() }
            .sheet(item: $editing) { report in LocalHazardEditor(report: report, store: store) }
            .confirmationDialog("Delete this report?", isPresented: Binding(get: { deleteID != nil }, set: { if !$0 { deleteID = nil } })) {
                Button("Delete report", role: .destructive) { if let deleteID { do { try store.delete(deleteID) } catch { self.error = error.localizedDescription } }; deleteID = nil }
            }
    }
}

struct LocalHazardEditor: View {
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: LocalHazardReportStore
    @State private var report: LocalHazardReport
    @State private var error: String?
    @State private var pdfURL: URL?
    @State private var saved = false
    init(report: LocalHazardReport, store: LocalHazardReportStore) { _report = State(initialValue: report); self.store = store }
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                Form {
                    Section("Hazard") {
                        DatePicker("Date and time", selection: $report.createdAt)
                        VStack(alignment: .leading, spacing: 6) { Text("Location or area").font(.caption).foregroundStyle(.secondary).accessibilityHidden(true); TextField("Location or area", text: $report.location) }
                        TextField("Hazard description", text: $report.description, axis: .vertical).lineLimit(3...8)
                        Picker("Category", selection: $report.category) { ForEach(LocalHazardReport.categories, id: \.self) { Text($0) } }
                        Picker("Cited standard", selection: $report.standard) {
                            Text("Optional / free text").tag("")
                            ForEach(progress.catalog.standards, id: \.title) { Text($0.title).tag($0.title) }
                            if !report.standard.isEmpty && !progress.catalog.standards.contains(where: { $0.title == report.standard }) { Text(report.standard).tag(report.standard) }
                        }
                        VStack(alignment: .leading, spacing: 6) { Text("Applicable standard (optional)").font(.caption).foregroundStyle(.secondary).accessibilityHidden(true); TextField("Applicable standard (optional)", text: $report.standard) }
                        VStack(alignment: .leading, spacing: 6) { Text("Employees exposed").font(.caption).foregroundStyle(.secondary).accessibilityHidden(true); TextField("Employees exposed", value: $report.employeesExposed, format: .number).keyboardType(.numberPad) }
                        Toggle(isOn: $report.imminentDanger) { Text("Imminent danger").fixedSize(horizontal: false, vertical: true) }
                        if report.imminentDanger { Label(LocalHazardReport.dangerNotice, systemImage: "exclamationmark.triangle.fill").foregroundStyle(AppTheme.danger).accessibilityAddTraits(.isStaticText) }
                    }
                    Section("Risk assessment") {
                        Picker("Severity", selection: $report.severity) { ForEach(ReportSeverity.allCases) { Text($0.title).tag($0) } }
                        Text(report.severity.rawValue).font(.footnote).foregroundStyle(.secondary)
                        Picker("Likelihood", selection: $report.likelihood) { ForEach(HazardLikelihood.allCases) { Text($0.rawValue).tag($0) } }
                        GlassCard { VStack(alignment: .leading, spacing: 10) {
                            Label("Risk level: \(report.risk.rawValue)", systemImage: "square.grid.3x3").font(.headline)
                            Text(ExampleRiskMatrix.disclaimer).font(.footnote).foregroundStyle(.secondary)
                        } }.accessibilityElement(children: .combine).accessibilityIdentifier("report-risk-summary")
                        DisclosureGroup("View example matrix") {
                            ForEach(ReportSeverity.allCases) { severity in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(severity.rawValue).font(.headline)
                                    ForEach(HazardLikelihood.allCases) { likelihood in
                                        Text("\(likelihood.rawValue): \(ExampleRiskMatrix.risk(severity, likelihood).rawValue)").accessibilityLabel("\(severity.rawValue), \(likelihood.rawValue), \(ExampleRiskMatrix.risk(severity, likelihood).rawValue) risk")
                                    }
                                }.padding(.vertical, 8)
                            }
                        }
                    }
                    Section("Controls and follow-up") {
                        TextField("Interim controls", text: $report.interimControls, axis: .vertical).lineLimit(2...6)
                        ForEach(LocalHazardReport.hierarchy, id: \.self) { item in
                            Toggle(item, isOn: Binding(get: { report.controlTypes.contains(item) }, set: { if $0 { report.controlTypes.insert(item) } else { report.controlTypes.remove(item) } }))
                        }
                        TextField("Corrective action", text: $report.correctiveAction, axis: .vertical).lineLimit(2...6)
                        VStack(alignment: .leading, spacing: 6) { Text("Owner").font(.caption).foregroundStyle(.secondary).accessibilityHidden(true); TextField("Owner", text: $report.owner) }
                        DatePicker("Due date", selection: $report.dueDate, displayedComponents: .date)
                        Picker("Status", selection: $report.status) { ForEach(LocalHazardReport.statuses, id: \.self) { Text($0) } }
                    }
                    Section("Save and export") {
                        Button(saved ? "Saved on this device" : "Save report") { save() }.disabled(report.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || report.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || report.employeesExposed < 0)
                        ShareLink("Share plain text", item: report.exportText)
                        Button("Prepare PDF") { do {
                            let url = FileManager.default.temporaryDirectory.appendingPathComponent("hazard-\(report.id).pdf")
                            try report.pdfData().write(to: url, options: .atomic); pdfURL = url
                        } catch { self.error = error.localizedDescription } }
                        if let pdfURL { ShareLink("Share PDF", item: pdfURL) }
                        if let error { Text(error).foregroundStyle(AppTheme.danger) }
                    }
                }.scrollContentBackground(.hidden)
            }.navigationTitle("Hazard report").navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Done", systemImage: "checkmark") { dismiss() }.labelStyle(.iconOnly) } }
                .onChange(of: report) { _, _ in saved = false; pdfURL = nil }
        }
    }
    private func save() { do { try store.save(report); saved = true; error = nil } catch { self.error = error.localizedDescription } }
}
