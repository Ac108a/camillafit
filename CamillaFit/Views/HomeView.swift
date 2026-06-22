import SwiftUI

enum NavigationDestination: Hashable {
    case preview(WorkoutType)
    case active(WorkoutType)
}

struct HomeView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        // Header
                        VStack(spacing: 6) {
                            Text("CamillaFit")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple, .pink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                            Text("10 minutes. That's all you need.")
                                .font(.system(size: 15))
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        .padding(.top, 20)

                        // Workout Cards
                        ForEach(WorkoutData.allWorkouts) { workout in
                            Button {
                                path.append(NavigationDestination.preview(workout.type))
                            } label: {
                                WorkoutCard(workout: workout)
                            }
                            .buttonStyle(.plain)
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .preview(let type):
                    WorkoutPreviewView(workout: workout(for: type), path: $path)
                case .active(let type):
                    ActiveWorkoutView(workout: workout(for: type), path: $path)
                }
            }
        }
    }

    private func workout(for type: WorkoutType) -> Workout {
        WorkoutData.allWorkouts.first { $0.type == type } ?? WorkoutData.strengthWorkout
    }
}

// MARK: - Workout Card

private struct WorkoutCard: View {
    let workout: Workout

    var gradientColors: [Color] {
        switch workout.type {
        case .strength:
            return [Color(hex: "e94560"), Color(hex: "c23616")]
        case .pilatesYoga:
            return [Color(hex: "6c5ce7"), Color(hex: "a29bfe")]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: workout.type.iconName)
                    .font(.system(size: 28))
                    .foregroundStyle(.white)

                Spacer()

                Text("\(workout.totalDurationMinutes) min")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(.white.opacity(0.2))
                    .clipShape(Capsule())
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(workout.type.rawValue)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)

                Text(workout.type.subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
            }

            HStack(spacing: 8) {
                Image(systemName: "clock")
                    .font(.system(size: 12))
                Text("\(workout.workDuration)s work / \(workout.restDuration)s rest")
                    .font(.system(size: 13))

                Text("•")

                Image(systemName: "list.bullet")
                    .font(.system(size: 12))
                Text("\(workout.exercises.count) exercises")
                    .font(.system(size: 13))
            }
            .foregroundStyle(.white.opacity(0.7))

            // Equipment
            Text(workout.type.equipmentSummary)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.6))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.white.opacity(0.1))
                .clipShape(Capsule())
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: gradientColors[0].opacity(0.4), radius: 12, y: 6)
    }
}

// MARK: - Hex Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    HomeView()
}
