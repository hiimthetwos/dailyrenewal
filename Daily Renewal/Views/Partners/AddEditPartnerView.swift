import SwiftUI
import SwiftData

struct AddEditPartnerView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    /// Pass an existing partner to edit; nil to create new.
    var partner: AccountabilityPartner? = nil

    @State private var name         = ""
    @State private var phone        = ""
    @State private var email        = ""
    @State private var relationship = ""
    @State private var isPrimary    = false

    private var isEditing: Bool { partner != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Relationship (e.g. Pastor, Friend)", text: $relationship)
                    Toggle("Primary Partner", isOn: $isPrimary)
                        .tint(theme.accent)
                }

                Section("Contact") {
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }

                Section {
                    if let scripture = ScriptureLibrary.scripture(for: "GAL6:1-2") {
                        VerseBlockView(scripture: scripture)
                            .listRowBackground(Color.clear)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(theme.background.ignoresSafeArea())
            .navigationTitle(isEditing ? "Edit Partner" : "New Partner")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let p = partner {
                    name         = p.name
                    phone        = p.phone
                    email        = p.email
                    relationship = p.relationship
                    isPrimary    = p.isPrimary
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isEditing ? "Save" : "Add") { save() }
                        .fontWeight(.semibold)
                        .foregroundColor(theme.accent)
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func save() {
        if let p = partner {
            p.name         = name
            p.phone        = phone
            p.email        = email
            p.relationship = relationship
            p.isPrimary    = isPrimary
        } else {
            let p = AccountabilityPartner(
                name: name.trimmingCharacters(in: .whitespaces),
                phone: phone,
                email: email,
                relationship: relationship,
                isPrimary: isPrimary
            )
            modelContext.insert(p)
        }
        HapticManager.success()
        dismiss()
    }
}

#Preview {
    // Add new partner preview
    AddEditPartnerView()
        .modelContainer(for: AccountabilityPartner.self, inMemory: true)
        .environment(ThemeManager())
}

#Preview("Edit Partner") {
    // Edit existing partner preview
    let samplePartner = AccountabilityPartner(
        name: "John Smith",
        phone: "+1 (555) 123-4567",
        email: "john@example.com",
        relationship: "Accountability Partner"
    )
    
    AddEditPartnerView(partner: samplePartner)
        .modelContainer(for: AccountabilityPartner.self, inMemory: true)
}
