import SwiftUI
import SwiftData

struct PartnerDetailView: View {
    @Environment(ThemeManager.self) private var theme
    @Bindable var partner: AccountabilityPartner
    @Environment(\.openURL) private var openURL
    @State private var showingEdit = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(theme.accent.opacity(DesignSystem.opacity.light))
                        .frame(width: 100, height: 100)
                    Text(String(partner.name.prefix(1)))
                        .font(.system(size: 44, design: .serif))
                        .foregroundColor(theme.accent)
                }
                .padding(.top)

                VStack(spacing: 6) {
                    Text(partner.name)
                        .font(.system(.title2, design: .serif))
                        .fontWeight(.semibold)

                    if !partner.relationship.isEmpty {
                        Text(partner.relationship)
                            .foregroundColor(.secondary)
                    }

                    if partner.isPrimary {
                        Label("Primary Partner", systemImage: "star.fill")
                            .font(.caption)
                            .foregroundColor(theme.gold)
                    }
                }

                // Contact buttons
                if !partner.phone.isEmpty || !partner.email.isEmpty {
                    HStack(spacing: 12) {
                        if !partner.phone.isEmpty {
                            contactButton(
                                title: "Call",
                                icon: "phone.fill",
                                urlString: "tel://\(partner.phone.filter { $0.isNumber })"
                            )
                            contactButton(
                                title: "Text",
                                icon: "message.fill",
                                urlString: "sms://\(partner.phone.filter { $0.isNumber })"
                            )
                        }
                        if !partner.email.isEmpty {
                            contactButton(
                                title: "Email",
                                icon: "envelope.fill",
                                urlString: "mailto:\(partner.email)"
                            )
                        }
                    }
                    .padding(.horizontal)
                }

                if let verse = ScriptureLibrary.scripture(for: "PRO27:17") {
                    VerseBlockView(scripture: verse)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 40)
        }
        .background(theme.background.ignoresSafeArea())
        .navigationTitle(partner.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showingEdit = true }
                    .foregroundColor(theme.accent)
            }
        }
        .sheet(isPresented: $showingEdit) {
            AddEditPartnerView(partner: partner)
        }
    }

    private func contactButton(title: String, icon: String, urlString: String) -> some View {
        Button {
            if let url = URL(string: urlString) {
                openURL(url)
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(theme.accent.opacity(DesignSystem.opacity.light))
            .foregroundColor(theme.accent)
            .cornerRadius(DesignSystem.cornerRadius.md)
        }
        .accessibilityLabel("\(title) \(partner.name)")
    }
}

#Preview {
    let samplePartner = AccountabilityPartner(
        name: "John Smith",
        phone: "+1 (555) 123-4567",
        email: "john@example.com",
        relationship: "Accountability Partner"
    )
    
    NavigationStack {
        PartnerDetailView(partner: samplePartner)
    }
    .modelContainer(for: AccountabilityPartner.self, inMemory: true)
        .environment(ThemeManager())
}
