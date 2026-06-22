import SwiftUI

struct WorkoutPreviewView: View {
    let workout: Workout
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header info
                VStack(spacing: 8) {
                    Image(systemName: workout.type.iconName)
                        .font(.system(size: 32))
                        .foregroundStyle(.purple)

                    Text(workout.type.rawValue)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    HStack(spacing: 16) {
                        Label("\(workout.totalDurationMinutes) min", systemImage: "clock")
                        Label("\(workout.exercises.count) exercises", systemImage: "list.bullet")
                        Label("\(workout.workDuration)s/\(workout.restDuration)s", systemImage: "timer")
                    }
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.6))
                }
                .padding(.top, 10)
                .padding(.bottom, 16)

                // Exercise list
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(Array(workout.exercises.enumerated()), id: \.element.id) { index, exercise in
                            ExerciseCardView(exercise: exercise, index: index)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }

                Spacer(minLength: 0)
            }

            // Start button
            VStack {
                Spacer()

                Button {
                    path.append(NavigationDestination.active(workout.type))
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 18))
                        Text("Start Workout")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .purple.opacity(0.5), radius: 10, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        WorkoutPreviewView(
            workout: WorkoutData.strengthWorkout,
            path: .constant(NavigationPath())
        )
    }
}
