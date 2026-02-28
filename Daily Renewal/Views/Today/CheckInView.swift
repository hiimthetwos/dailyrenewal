import SwiftUI
import SwiftData

struct CheckInView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let struggles: [Struggle]

    @State private var selectedMood: MoodRating = .holding
    @State private var prayerNote    = ""
    @State private var gratitudeNote = ""
    @State private var selectedStruggleID: PersistentIdentifier? = nil

    private var todayVerse: Scripture { 
        ScriptureLibrary.dailyVerse() ?? ScriptureLibrary.scripture(for: "PSA23:1") ?? defaultScripture
    }
    
    private var defaultScripture: Scripture {
        let verse = ScriptureVerse(id: "PSA23:1", reference: "Psalm 23:1", theme: .graceAndForgiveness)
        return Scripture(verse: verse, text: "The Lord is my shepherd, I lack nothing.", version: .kjv)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How are you today?")
                            .font(.system(.subheadline, design: .serif))
                            .foregroundColor(.secondary)

                        VStack(spacing: 0) {
                            ForEach(MoodRating.allCases, id: \.self) { mood in
                                Button {
                                    selectedMood = mood
                                    HapticManager.impact(.light)
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: mood.icon)
                                            .font(.system(size: 22))
                                            .frame(width: 28)
                                        Text(mood.rawValue)
                                            .font(.system(.body, design: .serif))
                                        Spacer()
                                        if selectedMood == mood {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                    }
                                    .frame(minHeight: 44)
                                    .padding(.horizontal, 14)
                                    .background(
                                        selectedMood == mood
                                            ? theme.accent
                                            : theme.accent.opacity(DesignSystem.opacity.subtle)
                                    )
                                    .foregroundColor(selectedMood == mood ? .white : theme.accent)
                                }
                                .accessibilityLabel(mood.rawValue)

                                if mood != MoodRating.allCases.last {
                                    Divider()
                                }
                            }
                        }
                        .cornerRadius(DesignSystem.cornerRadius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.cornerRadius.md)
                                .stroke(theme.accent.opacity(DesignSystem.opacity.light), lineWidth: 1)
                        )
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))

                if !struggles.isEmpty {
                    Section("Link to a struggle (optional)") {
                        Picker("Struggle", selection: $selectedStruggleID) {
                            Text("General").tag(Optional<PersistentIdentifier>.none)
                            ForEach(struggles) { s in
                                Text(s.name).tag(Optional(s.persistentModelID))
                            }
                        }
                    }
                }

                Section("Prayer") {
                    TextEditorWithPlaceholder(text: $prayerNote, placeholder: "Write your prayer...")
                }

                Section("Gratitude") {
                    TextEditorWithPlaceholder(text: $gratitudeNote, placeholder: "What are you thankful for today?")
                }

                Section("Today's Verse") {
                    VerseBlockView(scripture: todayVerse)
                        .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("Check In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { saveCheckIn() }
                        .fontWeight(.semibold)
                        .foregroundColor(theme.accent)
                }
            }
        }
    }

    private func saveCheckIn() {
        let checkIn = DailyCheckIn(
            date: DateHelpers.startOfDay(),
            mood: selectedMood,
            prayerNote: prayerNote,
            gratitudeNote: gratitudeNote,
            assignedVerseKey: todayVerse.id
        )

        if let pid = selectedStruggleID,
           let struggle = struggles.first(where: { $0.persistentModelID == pid }) {
            struggle.checkIns.append(checkIn)
        } else {
            modelContext.insert(checkIn)
        }

        HapticManager.success()
        dismiss()
    }
}

#Preview {
    CheckInView(struggles: [])
        .modelContainer(for: DailyCheckIn.self, inMemory: true)
        .environment(ThemeManager())
}
