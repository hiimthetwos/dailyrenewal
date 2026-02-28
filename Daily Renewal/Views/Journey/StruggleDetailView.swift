import SwiftUI
import SwiftData

struct StruggleDetailView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(BibleVersionManager.self) private var bibleVersionManager
    @Bindable var struggle: Struggle
    @State private var showingSlipView = false

    private var achieved: [Milestone]  { MilestoneEngine.achieved(for: struggle.currentStreakDays) }
    private var next: Milestone?        { MilestoneEngine.next(after: struggle.currentStreakDays) }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Streak ring + name
                VStack(spacing: 10) {
                    StreakRingView(
                        progress: MilestoneEngine.progress(currentDays: struggle.currentStreakDays),
                        days: struggle.currentStreakDays,
                        size: 160
                    )
                    .padding(.top)

                    Text(struggle.name)
                        .font(.system(.title2, design: .serif))
                        .fontWeight(.semibold)

                    if let next {
                        Text("\(next.days - struggle.currentStreakDays) more days to \"\(next.title)\"")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Label("All milestones reached", systemImage: "star.fill")
                            .font(.subheadline)
                            .foregroundColor(theme.green)
                    }
                }

                // Stats strip
                HStack(spacing: 0) {
                    statCell(value: "\(struggle.currentStreakDays)", label: "Current")
                    Divider().frame(width: 1, height: 40)
                    statCell(value: "\(struggle.longestStreakDays)", label: "Longest")
                    Divider().frame(width: 1, height: 40)
                    statCell(value: "\(struggle.totalSlipCount)", label: "Slips")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(DesignSystem.cornerRadius.md)
                .padding(.horizontal)

                // Foundation verse
                if let scripture = ScriptureLibrary.scripture(for: struggle.type.foundationVerseKey, version: bibleVersionManager.version) {
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeaderView(title: "Foundation Verse")
                        VerseBlockView(scripture: scripture)
                    }
                    .padding(.horizontal)
                }

                // Milestones scroll
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(
                        title: "Milestones",
                        subtitle: "\(achieved.count) of \(MilestoneEngine.all.count) reached"
                    )
                    .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(MilestoneEngine.all) { milestone in
                                MilestoneBadgeView(
                                    milestone: milestone,
                                    isAchieved: achieved.contains { $0.id == milestone.id }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Next milestone verse preview
                if let next,
                   let scripture = ScriptureLibrary.scripture(for: next.verseKey, version: bibleVersionManager.version) {
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeaderView(
                            title: "Verse for \"\(next.title)\"",
                            subtitle: "Day \(next.days)"
                        )
                        VerseBlockView(scripture: scripture)
                    }
                    .padding(.horizontal)
                }

                // Slip / restart button
                Button {
                    showingSlipView = true
                } label: {
                    Label("I Need to Start Over", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.maroon.opacity(DesignSystem.opacity.light))
                        .foregroundColor(theme.maroon)
                        .cornerRadius(DesignSystem.cornerRadius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.cornerRadius.md)
                                .stroke(theme.maroon.opacity(DesignSystem.opacity.medium), lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
        .background(theme.background.ignoresSafeArea())
        .navigationTitle(struggle.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingSlipView) {
            SlipView(struggle: struggle)
        }
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, design: .serif))
                .fontWeight(.bold)
                .foregroundColor(theme.accent)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    // Create a sample struggle for preview
    let sampleStruggle = Struggle(
        name: "Social Media",
        type: .custom,
        startDate: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date(),
        notes: "Trying to break free from endless scrolling"
    )
    
    NavigationStack {
        StruggleDetailView(struggle: sampleStruggle)
    }
    .modelContainer(for: Struggle.self, inMemory: true)
        .environment(ThemeManager())
        .environment(BibleVersionManager())
}
