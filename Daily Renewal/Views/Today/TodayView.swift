import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Struggle.createdAt) private var struggles: [Struggle]
    @State private var showingCheckIn  = false
    @State private var showingSettings = false
    @State private var showingAddStruggle = false

    private var activeStruggles: [Struggle] { struggles.filter { $0.isActive } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    DailyVerseCardView()

                    if activeStruggles.isEmpty {
                        emptyStateView
                    } else {
                        VStack(spacing: 12) {
                            SectionHeaderView(title: "Your Struggles")
                                .padding(.horizontal)

                            ForEach(activeStruggles) { struggle in
                                NavigationLink {
                                    StruggleDetailView(struggle: struggle)
                                } label: {
                                    StreakSummaryCardView(struggle: struggle)
                                        .padding(.horizontal)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    Button {
                        showingCheckIn = true
                    } label: {
                        Label("Daily Check-In", systemImage: "checkmark.circle.fill")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(theme.accent)
                            .foregroundColor(.white)
                            .cornerRadius(DesignSystem.cornerRadius.md)
                    }
                    .buttonStyle(PressButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top)
            }
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("Daily Renewal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(theme.accent)
                    }
                    .accessibilityLabel("Settings")
                }
            }
            .sheet(isPresented: $showingCheckIn) {
                CheckInView(struggles: activeStruggles)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingAddStruggle) {
                AddStruggleView()
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.walk")
                .font(.system(size: 50))
                .foregroundColor(theme.accent.opacity(0.5))

            Text("Begin Your Journey")
                .font(.system(.title2, design: .serif))
                .fontWeight(.semibold)

            Text("Add a struggle in the Journey tab to start tracking your path to freedom.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)

            Button {
                showingAddStruggle = true
            } label: {
                Label("Add Your First Struggle", systemImage: "plus.circle.fill")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.accent)
                    .foregroundColor(.white)
                    .cornerRadius(DesignSystem.cornerRadius.md)
            }
            .buttonStyle(PressButtonStyle())
            .padding(.horizontal, 40)
        }
        .padding(.vertical, 40)
    }
}



#Preview {
    TodayView()
        .modelContainer(for: DailyCheckIn.self, inMemory: true)
        .environment(ThemeManager())
}

