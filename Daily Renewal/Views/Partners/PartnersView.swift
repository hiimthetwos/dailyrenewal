import SwiftUI
import SwiftData

struct PartnersView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AccountabilityPartner.createdAt) private var partners: [AccountabilityPartner]
    @State private var showingAddPartner = false

    var body: some View {
        NavigationStack {
            Group {
                if partners.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(partners) { partner in
                            NavigationLink {
                                PartnerDetailView(partner: partner)
                            } label: {
                                PartnerRowView(partner: partner)
                            }
                            .listRowBackground(theme.background)
                        }
                        .onDelete(perform: deletePartner)
                    }
                    .scrollContentBackground(.hidden)
                    .background(theme.background)
                }
            }
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("Partners")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddPartner = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(theme.accent)
                    }
                    .accessibilityLabel("Add a Partner")
                }
            }
            .sheet(isPresented: $showingAddPartner) {
                AddEditPartnerView()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "person.2.fill")
                .font(.system(size: 60))
                .foregroundColor(theme.accent.opacity(0.5))

            Text("Add a Partner")
                .font(.system(.title2, design: .serif))

            Text("\"Iron sharpeneth iron.\" Add someone who will walk with you in prayer and accountability.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)

            Button {
                showingAddPartner = true
            } label: {
                Text("Add Partner")
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

    private func deletePartner(at offsets: IndexSet) {
        for index in offsets { modelContext.delete(partners[index]) }
    }
}

// MARK: – Row

struct PartnerRowView: View {
    @Environment(ThemeManager.self) private var theme
    let partner: AccountabilityPartner

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(theme.accent.opacity(0.15))
                    .frame(width: 44, height: 44)
                Text(String(partner.name.prefix(1)))
                    .font(.system(.headline, design: .serif))
                    .foregroundColor(theme.accent)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(partner.name)
                        .font(.system(.body, design: .serif))
                        .fontWeight(.semibold)

                    if partner.isPrimary {
                        Text("Primary")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(theme.gold.opacity(0.4))
                            .cornerRadius(4)
                    }
                }

                if !partner.relationship.isEmpty {
                    Text(partner.relationship)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PartnersView()
        .modelContainer(for: AccountabilityPartner.self, inMemory: true)
        .environment(ThemeManager())
}
