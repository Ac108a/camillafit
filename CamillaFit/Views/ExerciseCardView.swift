import SwiftUI

struct ExerciseCardView: View {
    let exercise: Exercise
    let index: Int
    let isCompact: Bool

    init(exercise: Exercise, index: Int, isCompact: Bool = false) {
        self.exercise = exercise
        self.index = index
        self.isCompact = isCompact
    }

    var body: some View {
        HStack(spacing: 14) {
            // Exercise number
            Text("\(index + 1)")
                .font(.system(size: isCompact ? 16 : 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 28)

            // GIF or fallback
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.08))

                Image(systemName: exercise.sfSymbolFallback)
                    .font(.system(size: isCompact ? 22 : 28))
                    .foregroundStyle(.purple.opacity(0.8))
            }
            .frame(width: isCompact ? 44 : 56, height: isCompact ? 44 : 56)

            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(exercise.name)
                    .font(.system(size: isCompact ? 15 : 16, weight: .semibold))
                    .foregroundStyle(.white)

                if !isCompact {
                    Text(exercise.description)
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.6))
                        .lineLimit(2)
                }

                HStack(spacing: 6) {
                    Label(exercise.equipment.rawValue, systemImage: exercise.equipment.iconName)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.purple.opacity(0.9))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.purple.opacity(0.15))
                        .clipShape(Capsule())

                    Text(exercise.targetMuscles)
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }

            Spacer()
        }
        .padding(.vertical, isCompact ? 8 : 12)
        .padding(.horizontal, 14)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            ExerciseCardView(
                exercise: WorkoutData.strengthExercises[0],
                index: 0
            )
            ExerciseCardView(
                exercise: WorkoutData.strengthExercises[1],
                index: 1,
                isCompact: true
            )
        }
        .padding()
    }
}
