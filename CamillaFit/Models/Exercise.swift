import Foundation

enum Equipment: String, Codable, CaseIterable {
    case kettlebell = "Kettlebell"
    case dumbbells = "Dumbbells"
    case barbell = "Barbell"
    case bodyweight = "Bodyweight"

    var iconName: String {
        switch self {
        case .kettlebell: return "figure.strengthtraining.traditional"
        case .dumbbells: return "dumbbell.fill"
        case .barbell: return "figure.cross.training"
        case .bodyweight: return "figure.mind.and.body"
        }
    }
}

struct Exercise: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let equipment: Equipment
    let gifName: String
    let targetMuscles: String
    let sfSymbolFallback: String

    init(
        name: String,
        description: String,
        equipment: Equipment,
        gifName: String,
        targetMuscles: String,
        sfSymbolFallback: String = "figure.run"
    ) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.equipment = equipment
        self.gifName = gifName
        self.targetMuscles = targetMuscles
        self.sfSymbolFallback = sfSymbolFallback
    }
}
