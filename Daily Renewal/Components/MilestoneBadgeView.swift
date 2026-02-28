import SwiftUI

struct MilestoneBadgeView: View {
    @Environment(ThemeManager.self) private var theme
    let milestone: Milestone
    let isAchieved: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(isAchieved ? theme.gold : Color.secondary.opacity(DesignSystem.opacity.light))
                    .frame(width: 52, height: 52)
                    .shadow(color: isAchieved ? theme.gold.opacity(DesignSystem.opacity.medium) : .clear, radius: 4)

                Text("\(milestone.days)")
                    .font(.system(size: 13, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(isAchieved ? .black : .secondary)
            }
            .scaleEffect(isAchieved ? 1.0 : 0.9)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isAchieved)

            Text(milestone.title)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .foregroundColor(isAchieved ? .primary : .secondary)
                .frame(width: 64)
                .lineLimit(2)
        }
        .opacity(isAchieved ? 1.0 : 0.5)
    }
}
