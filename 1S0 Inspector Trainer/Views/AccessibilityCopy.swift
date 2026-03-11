import Foundation

enum AccessibilityCopy {
    static func heartsLabel(hearts: Int, maxHearts: Int) -> String {
        "Hearts"
    }

    static func heartsValue(hearts: Int, maxHearts: Int) -> String {
        "\(hearts) of \(maxHearts) remaining"
    }

    static func heartsHint() -> String {
        "Wrong answers consume hearts. Practice restores hearts."
    }

    static func scoreLabel(score: Int) -> String {
        "Score"
    }

    static func scoreValue(score: Int) -> String {
        "\(score) percent"
    }

    static func xpRingLabel(level: Int) -> String {
        "Level progress"
    }

    static func xpRingValue(level: Int, progress: Double) -> String {
        let percent = Int(round(min(max(progress, 0), 1) * 100))
        return "Level \(level), \(percent) percent to next level"
    }

    static func optionLabel(text: String) -> String {
        text
    }

    static func optionHint() -> String {
        "Double tap to choose this answer."
    }

    static func feedbackLabel(isCorrect: Bool) -> String {
        isCorrect ? "Correct feedback" : "Incorrect feedback"
    }

    static func progressLabel(name: String, current: Int, total: Int) -> String {
        "\(name) progress"
    }

    static func progressValue(current: Int, total: Int) -> String {
        "\(current) of \(total)"
    }
}
