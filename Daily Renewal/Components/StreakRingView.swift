import SwiftUI

struct StreakRingView: View {
    @Environment(ThemeManager.self) private var theme
    let progress: Double
    let days: Int
    let size: CGFloat

    init(progress: Double, days: Int, size: CGFloat = 120) {
        self.progress = min(max(progress, 0), 1)
        self.days     = days
        self.size     = size
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(theme.accent.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    theme.accent,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.8), value: progress)

            VStack(spacing: 2) {
                Text("\(days)")
                    .font(.system(size: size * 0.28, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(theme.accent)
                Text("days")
                    .font(.system(size: size * 0.12))
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: size, height: size)
    }

    private var lineWidth: CGFloat { size * 0.08 }
}

#Preview {
    StreakRingView(progress: 0.65, days: 47)
        .padding()
        .environment(ThemeManager())
}
