import SwiftUI
import SwiftData

struct JourneyView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Struggle.createdAt) private var struggles: [Struggle]
    @State private var showingAddStruggle = false

    var body: some View {
        NavigationStack {
            Group {
                if struggles.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(struggles) { struggle in
                            NavigationLink {
                                StruggleDetailView(struggle: struggle)
                            } label: {
                                StruggleRowView(struggle: struggle)
                            }
                            .listRowBackground(theme.background)
                        }
                        .onDelete(perform: deleteStruggle)
                    }
                    .scrollContentBackground(.hidden)
                    .background(theme.background)
                }
            }
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("Journey")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddStruggle = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(theme.accent)
                    }
                    .accessibilityLabel("Add a Struggle")
                }
            }
            .sheet(isPresented: $showingAddStruggle) {
                AddStruggleView()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "figure.walk")
                .font(.system(size: 60))
                .foregroundColor(theme.accent.opacity(0.5))

            Text("Begin Your Walk")
                .font(.system(.title2, design: .serif))

            Text("Add the areas where you seek freedom. The Lord meets us in our weakness.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)

            Button {
                showingAddStruggle = true
            } label: {
                Text("Add a Struggle")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(theme.accent)
                    .foregroundColor(.white)
                    .cornerRadius(DesignSystem.cornerRadius.pill)
            }
            .buttonStyle(PressButtonStyle())

            Spacer()
        }
    }

    private func deleteStruggle(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(struggles[index])
        }
    }
}

// MARK: – Row

struct StruggleRowView: View {
    @Environment(ThemeManager.self) private var theme
    let struggle: Struggle

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(theme.accent.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: struggle.type.icon)
                    .foregroundColor(theme.accent)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(struggle.name)
                    .font(.system(.body, design: .serif))
                    .fontWeight(.semibold)

                Text(DateHelpers.formattedStreakDays(struggle.currentStreakDays))
                    .font(.subheadline)
                    .foregroundColor(theme.accent)
            }

            Spacer()

            if !struggle.isActive {
                Text("Paused")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    JourneyView()
        .modelContainer(for: Struggle.self, inMemory: true)
        .environment(ThemeManager())
}
