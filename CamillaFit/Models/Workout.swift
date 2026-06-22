import Foundation

enum WorkoutType: String, Codable {
    case strength = "Strength Training"
    case pilatesYoga = "Pilates & Yoga"

    var iconName: String {
        switch self {
        case .strength: return "flame.fill"
        case .pilatesYoga: return "leaf.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .strength: return "Weight Loss Focus"
        case .pilatesYoga: return "Mobility & Flexibility"
        }
    }

    var equipmentSummary: String {
        switch self {
        case .strength: return "Dumbbells, Kettlebell, Barbell"
        case .pilatesYoga: return "Bodyweight Only"
        }
    }
}

struct Workout: Identifiable {
    let id: UUID
    let type: WorkoutType
    let exercises: [Exercise]
    let workDuration: Int      // seconds per exercise
    let restDuration: Int      // seconds between exercises
    let introDuration: Int     // seconds before first exercise

    init(
        type: WorkoutType,
        exercises: [Exercise],
        workDuration: Int,
        restDuration: Int,
        introDuration: Int = 5
    ) {
        self.id = UUID()
        self.type = type
        self.exercises = exercises
        self.workDuration = workDuration
        self.restDuration = restDuration
        self.introDuration = introDuration
    }

    var totalDuration: Int {
        let exerciseTime = exercises.count * workDuration
        let restTime = (exercises.count - 1) * restDuration
        return introDuration + exerciseTime + restTime
    }

    var totalDurationMinutes: Int {
        totalDuration / 60
    }
}
