import AVFoundation
import AudioToolbox
import UIKit

@MainActor
final class AudioManager {
    static let shared = AudioManager()

    private let synthesizer = AVSpeechSynthesizer()

    private init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }

    // MARK: - Voice

    func speak(_ text: String, rate: Float = 0.5) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = rate
        utterance.volume = 0.8
        utterance.pitchMultiplier = 1.1
        synthesizer.speak(utterance)
    }

    func announceExercise(_ name: String) {
        speak(name)
    }

    func announceRest(nextExercise: String?) {
        if let next = nextExercise {
            speak("Rest. Next up: \(next)", rate: 0.45)
        } else {
            speak("Rest")
        }
    }

    func announceCountdown(_ number: Int) {
        speak("\(number)", rate: 0.55)
    }

    func announceWorkoutComplete() {
        speak("Great job! Workout complete!", rate: 0.45)
    }

    func announceGetReady() {
        speak("Get ready!", rate: 0.5)
    }

    // MARK: - Beeps

    func playTransitionBeep() {
        AudioServicesPlaySystemSound(1052) // short beep
    }

    func playWorkoutEndBeeps() {
        AudioServicesPlaySystemSound(1025) // triple tone
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            AudioServicesPlaySystemSound(1025)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            AudioServicesPlaySystemSound(1025)
        }
    }

    func playCountdownBeep() {
        AudioServicesPlaySystemSound(1057) // subtle tick
    }

    // MARK: - Haptics

    func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    func triggerCompletionHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
