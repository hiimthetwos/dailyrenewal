import SwiftUI
import SwiftData

struct StreakSummaryCardView: View {
    @Environment(ThemeManager.self) private var theme
    let struggle: Struggle

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(theme.accent.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: struggle.type.icon)
                    .foregroundColor(theme.accent)
                    .font(.system(size: 20))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(struggle.name)
                    .font(.system(.subheadline, design: .serif))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(DateHelpers.formattedStreakDays(struggle.currentStreakDays))
                    .font(.system(size: 22, design: .serif))
                    .foregroundColor(theme.accent)

                if let next = MilestoneEngine.next(after: struggle.currentStreakDays) {
                    Text("\(next.days - struggle.currentStreakDays) days to \"\(next.title)\"")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("All milestones reached")
                        .font(.caption)
                        .foregroundColor(theme.green)
                }
            }

            Spacer()

            StreakRingView(
                progress: MilestoneEngine.progress(currentDays: struggle.currentStreakDays),
                days: struggle.currentStreakDays,
                size: 60
            )
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(DesignSystem.cornerRadius.md)
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
    }
}

#Preview {
    let sampleStruggle = Struggle(
        name: "Social Media",
        type: .custom,
        startDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
        notes: "Breaking free from endless scrolling"
    )
    
    let themeManager = ThemeManager()
    
    VStack(spacing: 16) {
        StreakSummaryCardView(struggle: sampleStruggle)
    }
    .padding()
    .background(themeManager.background)
    .modelContainer(for: Struggle.self, inMemory: true)
    .environment(themeManager)
}
