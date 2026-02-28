import SwiftUI
import SwiftData

struct AddStruggleView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(BibleVersionManager.self) private var bibleVersionManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name      = ""
    @State private var customName = ""
    @State private var type: StruggleType = .alcohol
    @State private var startDate = Date.now
    @State private var notes     = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("What are you walking free from?") {
                    Picker("Type", selection: $type) {
                        ForEach(StruggleType.allCases, id: \.self) { t in
                            Label(t.rawValue, systemImage: t.icon).tag(t)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: type) { _, newType in
                        if newType == .custom {
                            name = customName
                        } else {
                            name = newType.rawValue
                        }
                    }

                    if type == .custom {
                        TextField("Enter your custom struggle", text: $customName)
                            .font(.system(.body, design: .serif))
                            .onChange(of: customName) { _, newValue in
                                name = newValue
                            }
                    } else {
                        TextField("Name", text: $name)
                            .font(.system(.body, design: .serif))
                    }
                }

                Section("When did your current streak begin?") {
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        in: ...Date.now,
                        displayedComponents: .date
                    )
                }

                Section("Notes (optional)") {
                    TextEditorWithPlaceholder(text: $notes, placeholder: "Any notes for your journey...")
                }

                if let verse = ScriptureLibrary.scripture(for: type.foundationVerseKey, version: bibleVersionManager.version) {
                    Section("Your Foundation Verse") {
                        VerseBlockView(scripture: verse)
                            .listRowBackground(Color.clear)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("New Struggle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") { addStruggle() }
                        .fontWeight(.semibold)
                        .foregroundColor(theme.accent)
                        .disabled(isAddButtonDisabled)
                }
            }
            .onAppear {
                // Initialize with the first struggle type's name
                if name.isEmpty {
                    name = type.rawValue
                }
            }
        }
    }

    private var isAddButtonDisabled: Bool {
        if type == .custom {
            return customName.trimmingCharacters(in: .whitespaces).isEmpty
        } else {
            return name.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }

    private func addStruggle() {
        let struggle = Struggle(
            name: name.trimmingCharacters(in: .whitespaces),
            type: type,
            startDate: startDate,
            notes: notes
        )
        modelContext.insert(struggle)
        HapticManager.success()
        dismiss()
    }
}

#Preview {
    AddStruggleView()
        .modelContainer(for: Struggle.self, inMemory: true)
        .environment(ThemeManager())
        .environment(BibleVersionManager())
}
