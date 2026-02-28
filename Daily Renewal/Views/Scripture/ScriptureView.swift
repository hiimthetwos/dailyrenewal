import SwiftUI

struct ScriptureView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(BibleVersionManager.self) private var bibleVersionManager
    @State private var searchText    = ""
    @State private var selectedTheme: ScriptureTheme? = nil

    private var filteredScriptures: [Scripture] {
        let baseVerses = selectedTheme.map { ScriptureLibrary.verses(for: $0) } ?? ScriptureLibrary.allVerses
        let scriptures = baseVerses.compactMap { verse in
            ScriptureLibrary.scripture(for: verse.id, version: bibleVersionManager.version)
        }
        
        guard !searchText.isEmpty else { return scriptures }
        return scriptures.filter {
            $0.text.localizedCaseInsensitiveContains(searchText) ||
            $0.reference.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Theme filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        themeChip(nil, label: "All")
                        ForEach(ScriptureTheme.allCases) { theme in
                            themeChip(theme, label: theme.rawValue)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .background(themeManager.background)

                List(filteredScriptures) { scripture in
                    NavigationLink {
                        ScriptureDetailView(scripture: scripture)
                    } label: {
                        ScriptureRowView(scripture: scripture)
                    }
                    .listRowBackground(themeManager.background)
                }
                .scrollContentBackground(.hidden)
                .background(themeManager.background)
            }
            .background(themeManager.background.ignoresSafeArea())
            .navigationTitle("Scripture")
            .searchable(text: $searchText, prompt: "Search verses…")
        }
    }

    private func themeChip(_ theme: ScriptureTheme?, label: String) -> some View {
        Button {
            selectedTheme = theme
            HapticManager.impact(.light)
        } label: {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    selectedTheme == theme ? themeManager.accent : themeManager.accent.opacity(DesignSystem.opacity.light)
                )
                .foregroundColor(selectedTheme == theme ? .white : themeManager.accent)
                .cornerRadius(DesignSystem.cornerRadius.pill)
        }
        .accessibilityLabel("Filter by \(label)")
    }
}

// MARK: – Row

struct ScriptureRowView: View {
    @Environment(ThemeManager.self) private var themeManager
    let scripture: Scripture

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(scripture.reference)
                .font(.system(.subheadline, design: .serif))
                .fontWeight(.semibold)
                .foregroundColor(themeManager.accent)

            Text(scripture.text)
                .font(.system(size: 14, design: .serif).italic())
                .lineLimit(3)
                .foregroundColor(.primary)
                .lineSpacing(2)

            Text(scripture.theme.rawValue)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Text(scripture.version.rawValue)
                .font(.caption2)
                .foregroundColor(Color(UIColor.tertiaryLabel))
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ScriptureView()
        .environment(ThemeManager())
        .environment(BibleVersionManager())
}
