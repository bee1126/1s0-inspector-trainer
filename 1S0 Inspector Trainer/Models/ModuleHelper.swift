import Foundation

enum ModuleHelper {
    static func modulePrefix(for questionId: String) -> String {
        let components = questionId.split(separator: "-")
        guard components.count > 1 else { return questionId }
        return components.dropLast().joined(separator: "-")
    }
}

extension ModuleHelper {
    /// Persistence historically uses quiz prefixes; navigation uses full module IDs.
    static func moduleID(for questionID: String) -> String {
        let prefix = modulePrefix(for: questionID)
        return ["fall": "fall-protection", "rm": "risk-management", "roles": "roles-responsibilities",
                "cs": "confined-space", "hc": "hearing-conservation", "mishap": "mishap-reporting",
                "ppe": "ppe-decision", "dorm": "deployed-orm"][prefix] ?? prefix
    }
}
