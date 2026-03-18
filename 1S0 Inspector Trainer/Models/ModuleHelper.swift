import Foundation

enum ModuleHelper {
    static func modulePrefix(for questionId: String) -> String {
        let components = questionId.split(separator: "-")
        guard components.count > 1 else { return questionId }
        return components.dropLast().joined(separator: "-")
    }
}
