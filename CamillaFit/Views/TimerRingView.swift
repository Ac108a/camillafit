import SwiftUI

struct TimerRingView: View {
    let progress: Double
    let timeRemaining: Int
    let color: Color
    let lineWidth: CGFloat

    init(progress: Double, timeRemaining: Int, color: Color, lineWidth: CGFloat = 8) {
        self.progress = progress
        self.timeRemaining = timeRemaining
        self.color = color
        self.lineWidth = lineWidth
    }

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)

            // Progress ring
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1.0), value: progress)

            // Time display
            Text("\(timeRemaining)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.default, value: timeRemaining)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        TimerRingView(progress: 0.65, timeRemaining: 24, color: .green)
            .frame(width: 160, height: 160)
    }
}
