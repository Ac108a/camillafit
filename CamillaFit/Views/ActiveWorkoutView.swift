import SwiftUI

struct ActiveWorkoutView: View {
    let workout: Workout
    @Binding var path: NavigationPath
    @StateObject private var viewModel: WorkoutViewModel

    init(workout: Workout, path: Binding<NavigationPath>) {
        self.workout = workout
        _path = path
        _viewModel = StateObject(wrappedValue: WorkoutViewModel(workout: workout))
    }

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "0f0f23")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if viewModel.phase == .completed {
                CompletionView(workout: workout) {
                    path = NavigationPath()
                }
            } else {
                workoutContent
            }

            // Pause overlay
            if viewModel.isPaused && viewModel.phase != .completed {
                pauseOverlay
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }

    // MARK: - Workout Content

    private var workoutContent: some View {
        VStack(spacing: 0) {
            // Top bar
            topBar
                .padding(.horizontal, 20)
                .padding(.top, 8)

            // Progress dots
            progressDots
                .padding(.top, 12)
                .padding(.horizontal, 20)

            Spacer(minLength: 16)

            // Exercise display area
            if viewModel.phase == .rest {
                restView
            } else {
                exerciseView
            }

            Spacer(minLength: 16)

            // Timer ring
            TimerRingView(
                progress: viewModel.progress,
                timeRemaining: viewModel.timeRemaining,
                color: viewModel.phaseColor,
                lineWidth: 10
            )
            .frame(width: 150, height: 150)
            .padding(.bottom, 8)

            // Phase label
            Text(viewModel.phaseLabel)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(viewModel.phaseColor)
                .padding(.vertical, 6)
                .padding(.horizontal, 20)
                .background(viewModel.phaseColor.opacity(0.15))
                .clipShape(Capsule())
                .padding(.bottom, 16)

            // Pause button
            Button(action: { viewModel.togglePause() }) {
                Image(systemName: "pause.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Circle())
            }
            .padding(.bottom, 30)
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button(action: {
                viewModel.stop()
                path = NavigationPath()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }

            Spacer()

            Text(workout.type.rawValue)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))

            Spacer()

            // Overall progress
            Text("\(Int(viewModel.overallProgress * 100))%")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.purple)
                .frame(width: 36, height: 36)
        }
    }

    // MARK: - Progress Dots

    private var progressDots: some View {
        HStack(spacing: 4) {
            ForEach(0..<workout.exercises.count, id: \.self) { index in
                Capsule()
                    .fill(dotColor(for: index))
                    .frame(height: 4)
            }
        }
    }

    private func dotColor(for index: Int) -> Color {
        if index < viewModel.currentExerciseIndex {
            return .purple
        } else if index == viewModel.currentExerciseIndex {
            return viewModel.phaseColor
        } else {
            return .white.opacity(0.15)
        }
    }

    // MARK: - Exercise View

    private var exerciseView: some View {
        VStack(spacing: 14) {
            // GIF / Symbol
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.06))

                GIFImageView(
                    gifName: viewModel.currentExercise.gifName,
                    sfSymbolFallback: viewModel.currentExercise.sfSymbolFallback
                )
                .padding(16)
            }
            .frame(height: 200)
            .padding(.horizontal, 20)

            // Exercise name
            Text(viewModel.currentExercise.name)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            // Equipment badge
            Label(viewModel.currentExercise.equipment.rawValue, systemImage: viewModel.currentExercise.equipment.iconName)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.purple)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(Color.purple.opacity(0.15))
                .clipShape(Capsule())

            // Description
            Text(viewModel.currentExercise.description)
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
    }

    // MARK: - Rest View

    private var restView: some View {
        VStack(spacing: 20) {
            Text("REST")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.orange)

            if let next = viewModel.nextExercise {
                VStack(spacing: 10) {
                    Text("Next up:")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))

                    // Preview next exercise
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.06))

                        Image(systemName: next.sfSymbolFallback)
                            .font(.system(size: 50))
                            .foregroundStyle(.purple.opacity(0.6))
                    }
                    .frame(height: 140)
                    .padding(.horizontal, 40)

                    Text(next.name)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Label(next.equipment.rawValue, systemImage: next.equipment.iconName)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.purple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(Color.purple.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
        }
    }

    // MARK: - Pause Overlay

    private var pauseOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.white)

                Text("PAUSED")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                VStack(spacing: 14) {
                    Button(action: { viewModel.togglePause() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                            Text("Resume")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button(action: {
                        viewModel.stop()
                        path = NavigationPath()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark")
                            Text("Quit Workout")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundStyle(.white.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

#Preview {
    ActiveWorkoutView(
        workout: WorkoutData.strengthWorkout,
        path: .constant(NavigationPath())
    )
}
