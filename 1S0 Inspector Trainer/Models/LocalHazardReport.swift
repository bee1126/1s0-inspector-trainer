import Foundation
import UIKit

enum ReportSeverity: String, Codable, CaseIterable, Identifiable {
    case catastrophic = "Catastrophic (death or permanent disability)"
    case serious = "Serious (hospitalization or days away)"
    case moderate = "Moderate (medical treatment or restricted work)"
    case minor = "Minor (first aid)"
    var title: String { String(rawValue.split(separator: "(")[0]).trimmingCharacters(in: .whitespaces) }
    var id: String { rawValue }
}
enum HazardLikelihood: String, Codable, CaseIterable, Identifiable {
    case almostCertain = "Almost certain", likely = "Likely", possible = "Possible", unlikely = "Unlikely"
    var id: String { rawValue }
}
enum HazardRisk: String, Codable { case critical = "Critical", high = "High", medium = "Medium", low = "Low" }
enum ExampleRiskMatrix {
    static let disclaimer = "Example matrix. Use your organization's matrix if it has one. OSHA does not prescribe a risk matrix."
    static func risk(_ severity: ReportSeverity, _ likelihood: HazardLikelihood) -> HazardRisk {
        let cells: [[HazardRisk]] = [[.critical, .critical, .high, .medium], [.critical, .high, .medium, .low], [.high, .medium, .medium, .low], [.medium, .low, .low, .low]]
        return cells[ReportSeverity.allCases.firstIndex(of: severity)!][HazardLikelihood.allCases.firstIndex(of: likelihood)!]
    }
}
struct LocalHazardReport: Codable, Identifiable, Equatable {
    var id = UUID()
    var createdAt = Date()
    var location = ""
    var description = ""
    var category = "Other"
    var standard = ""
    var employeesExposed = 0
    var imminentDanger = false
    var severity: ReportSeverity = .minor
    var likelihood: HazardLikelihood = .unlikely
    var interimControls = ""
    var correctiveAction = ""
    var controlTypes: Set<String> = []
    var owner = ""
    var dueDate = Date()
    var status = "Open"
    static let categories = ["Walking-working surfaces", "Electrical", "Machine guarding", "Hazardous chemicals", "PPE", "Fire / egress", "Material handling", "Confined space", "Noise", "Other"]
    static let statuses = ["Open", "Interim controls in place", "Closed"]
    static let hierarchy = ["Eliminate", "Substitute", "Engineering", "Administrative", "PPE"]
    static let dangerNotice = "Remove people from exposure and notify your supervisor now. Follow your employer's procedure."
    var risk: HazardRisk { ExampleRiskMatrix.risk(severity, likelihood) }
    var exportText: String {
        """
        \(AppBrand.name) — Hazard Report & Risk Matrix
        Date: \(createdAt.formatted())
        Location: \(location)
        Hazard: \(description)
        Category: \(category)
        Applicable standard: \(standard)
        Employees exposed: \(employeesExposed)
        Imminent danger: \(imminentDanger ? "Yes" : "No")
        \(imminentDanger ? Self.dangerNotice : "")
        Severity: \(severity.rawValue)
        Likelihood: \(likelihood.rawValue)
        Risk level: \(risk.rawValue)
        \(ExampleRiskMatrix.disclaimer)
        Interim controls: \(interimControls)
        Corrective action: \(correctiveAction)
        Hierarchy of controls: \(Self.hierarchy.filter { controlTypes.contains($0) }.joined(separator: ", "))
        Owner: \(owner)
        Due date: \(dueDate.formatted(date: .abbreviated, time: .omitted))
        Status: \(status)
        Local planning record. Follow current standards and your employer's procedures.
        """
    }
    /// Paginated text export handles long reports without clipping.
    func pdfData() -> Data {
        let bounds = CGRect(x: 0, y: 0, width: 612, height: 792)
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.black]
        let storage = NSTextStorage(string: exportText, attributes: attributes)
        let layout = NSLayoutManager()
        storage.addLayoutManager(layout)
        var containers: [NSTextContainer] = []
        var covered = 0
        repeat {
            let container = NSTextContainer(size: CGSize(width: 516, height: 696))
            container.lineFragmentPadding = 0
            layout.addTextContainer(container)
            containers.append(container)
            let range = layout.glyphRange(for: container)
            guard range.length > 0 else { break }
            covered = NSMaxRange(range)
        } while covered < layout.numberOfGlyphs
        return UIGraphicsPDFRenderer(bounds: bounds).pdfData { context in
            for container in containers {
                context.beginPage()
                let range = layout.glyphRange(for: container)
                layout.drawBackground(forGlyphRange: range, at: CGPoint(x: 48, y: 48))
                layout.drawGlyphs(forGlyphRange: range, at: CGPoint(x: 48, y: 48))
            }
        }
    }
}

/// Separate user-authored records; never writes study_state_v1 or contacts a server.
final class LocalHazardReportStore: ObservableObject {
    @Published private(set) var reports: [LocalHazardReport] = []
    @Published private(set) var errorMessage: String?
    let fileURL: URL
    private var readable = true
    init(directory: URL? = nil) {
        let folder = directory ?? FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        fileURL = folder.appendingPathComponent("hazard_reports_v1.json")
        reload()
    }
    func reload() {
        do {
            reports = FileManager.default.fileExists(atPath: fileURL.path) ? try JSONDecoder().decode([LocalHazardReport].self, from: Data(contentsOf: fileURL)) : []
            readable = true; errorMessage = nil
        } catch { readable = false; errorMessage = "Saved reports could not be read. The original file is preserved. \(error.localizedDescription)" }
    }
    func save(_ report: LocalHazardReport) throws {
        guard readable else { throw CocoaError(.fileReadCorruptFile) }
        var updated = reports.filter { $0.id != report.id }; updated.insert(report, at: 0)
        try persist(updated)
    }
    func delete(_ id: UUID) throws { guard readable else { throw CocoaError(.fileReadCorruptFile) }; try persist(reports.filter { $0.id != id }) }
    func deleteAll() throws { try persist([]); readable = true; errorMessage = nil }
    private func persist(_ updated: [LocalHazardReport]) throws {
        try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try JSONEncoder().encode(updated).write(to: fileURL, options: [.atomic, .completeFileProtection])
        reports = updated
    }
}
