import SwiftUI
import Combine

enum WorkoutPhase: Equatable {
    case intro
    case work
    case rest
    case completed
}

@MainActor
final class WorkoutViewModel: ObservableObject {
    // MARK: - Published State

    @Published var currentExerciseIndex: Int = 0
    @Published var phase: WorkoutPhase = .intro
    @Published var timeRemaining: Int = 0
    @Published var isPaused: Bool = false
    @Published var totalElapsed: Int = 0

    // MARK: - Properties

    let workout: Workout
    private var timer: AnyCancellable?
    private let audio = AudioManager.shared

    var currentExercise: Exercise {
        workout.exercises[currentExerciseIndex]
    }

    var nextExercise: Exercise? {
        let next = currentExerciseIndex + 1
        guard next < workout.exercises.count else { return nil }
        return workout.exercises[next]
    }

    var phaseDuration: Int {
        switch phase {
        case .intro: return workout.introDuration
        case .work: return workout.workDuration
        case .rest: return workout.restDuration
        case .completed: return 0
        }
    }

    var progress: Double {
        guard phaseDuration > 0 else { return 1.0 }
        return 1.0 - (Double(timeRemaining) / Double(phaseDuration))
    }

    var overallProgress: Double {
        guard workout.totalDuration > 0 else { return 0 }
        return Double(totalElapsed) / Double(workout.totalDuration)
    }

    var phaseColor: Color {
        switch phase {
        case .intro: return .blue
        case .work: return .green
        case .rest: return .orange
        case .completed: return .purple
        }
    }

    var phaseLabel: String {
        switch phase {
        case .intro: return "GET READY"
        case .work: return "WORK"
        case .rest: return "REST"
        case .completed: return "DONE"
        }
    }

    // MARK: - Init

    init(workout: Workout) {
        self.workout = workout
    }

    // MARK: - Controls

    func start() {
        phase = .intro
        currentExerciseIndex = 0
        timeRemaining = workout.introDuration
        totalElapsed = 0
        isPaused = false

        audio.announceGetReady()
        startTimer()
    }

    func togglePause() {
        isPaused.toggle()
        if isPaused {
            stopTimer()
            audio.stopSpeaking()
        } else {
            startTimer()
        }
    }

    func stop() {
        stopTimer()
        audio.stopSpeaking()
    }

    // MARK: - Timer

    private func startTimer() {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                Task { @MainActor in
                    self.tick()
                }
            }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    private func tick() {
        guard !isPaused else { return }

        totalElapsed += 1

        if timeRemaining > 1 {
            timeRemaining -= 1

            // Countdown beeps for last 3 seconds
            if timeRemaining <= 3 && timeRemaining >= 1 {
                audio.playCountdownBeep()
                if phase == .rest || phase == .intro {
                    audio.announceCountdown(timeRemaining)
                }
            }
        } else {
            // Time's up - advance phase
            advancePhase()
        }
    }

    private func advancePhase() {
        audio.playTransitionBeep()
        audio.triggerHaptic()

        switch phase {
        case .intro:
            // Start first exercise
            phase = .work
            timeRemaining = workout.workDuration
            audio.announceExercise(currentExercise.name)

        case .work:
            if currentExerciseIndex < workout.exercises.count - 1 {
                // Move to rest
                phase = .rest
                timeRemaining = workout.restDuration
                audio.announceRest(nextExercise: nextExercise?.name)
            } else {
                // Workout complete
                completeWorkout()
            }

        case .rest:
            // Move to next exercise
            currentExerciseIndex += 1
            phase = .work
            timeRemaining = workout.workDuration
            audio.announceExercise(currentExercise.name)

        case .completed:
            break
        }
    }

    private func completeWorkout() {
        stopTimer()
        phase = .completed
        audio.playWorkoutEndBeeps()
        audio.triggerCompletionHaptic()

        Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 800_000_000)
            self?.audio.announceWorkoutComplete()
        }
    }
}
