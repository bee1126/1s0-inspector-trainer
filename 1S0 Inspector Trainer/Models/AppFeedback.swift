import AudioToolbox
import UIKit

enum AppFeedback {
    static func correct() {
        haptic(.success)
        play(.correct)
    }

    static func incorrect() {
        haptic(.error)
        play(.incorrect)
    }

    static func complete() {
        haptic(.success)
        play(.complete)
    }

    static func levelUp() {
        haptic(.success)
        play(.levelUp)
    }

    static func badge() {
        haptic(.success)
        play(.badge)
    }

    private static func haptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    private static func play(_ sound: Sound) {
        AudioServicesPlaySystemSound(sound.rawValue)
    }

    private enum Sound: SystemSoundID {
        case correct = 1104
        case incorrect = 1053
        case complete = 1001
        case levelUp = 1025
        case badge = 1013
    }
}
