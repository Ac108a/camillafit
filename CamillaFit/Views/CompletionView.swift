import SwiftUI

struct CompletionView: View {
    let workout: Workout
    let onDismiss: () -> Void
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Celebration icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)

                    Image(systemName: "checkmark")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(.white)
                }
                .scaleEffect(showConfetti ? 1.0 : 0.5)
                .opacity(showConfetti ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showConfetti)

                // Text
                VStack(spacing: 8) {
                    Text("Well Done!")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("You completed \(workout.type.rawValue)")
                        .font(.system(size: 16))
                        .foregroundStyle(.white.opacity(0.7))
                }

                // Stats
                HStack(spacing: 24) {
                    statItem(value: "\(workout.totalDurationMinutes)", label: "Minutes", icon: "clock")
                    statItem(value: "\(workout.exercises.count)", label: "Exercises", icon: "list.bullet")
                    statItem(value: "100%", label: "Completed", icon: "flame.fill")
                }
                .padding(.top, 10)

                Spacer()

                // Done button
                Button(action: onDismiss) {
                    HStack(spacing: 8) {
                        Image(systemName: "house.fill")
                        Text("Back to Home")
                            .font(.system(size: 17, weight: .semibold))
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
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation {
                showConfetti = true
            }
        }
    }

    private func statItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(.purple)

            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(width: 80)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    CompletionView(workout: WorkoutData.strengthWorkout) {}
}
