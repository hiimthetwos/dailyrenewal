import SwiftUI

struct ScriptureDetailView: View {
    @Environment(ThemeManager.self) private var theme
    let scripture: Scripture

    private var related: [Scripture] {
        ScriptureLibrary.scriptures(for: scripture.theme, version: scripture.version).filter { $0.id != scripture.id }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Theme label
                Label(scripture.theme.rawValue, systemImage: scripture.theme.icon)
                    .font(.subheadline)
                    .foregroundColor(theme.accent)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(theme.accent.opacity(DesignSystem.opacity.light))
                    .cornerRadius(DesignSystem.cornerRadius.pill)

                // Verse text
                Text(scripture.text)
                    .font(.system(size: 20, design: .serif).italic())
                    .lineSpacing(8)
                    .foregroundColor(.primary)

                Text("— \(scripture.reference)")
                    .font(.system(.body, design: .serif))
                    .foregroundColor(theme.accent)

                Divider()

                // Related verses
                if !related.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("More on \(scripture.theme.rawValue)")
                            .font(.system(.headline, design: .serif))

                        ForEach(related) { verse in
                            NavigationLink {
                                ScriptureDetailView(scripture: verse)
                            } label: {
                                HStack(alignment: .top, spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(verse.reference)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(theme.accent)
                                        Text(verse.text)
                                            .font(.system(size: 13, design: .serif).italic())
                                            .lineLimit(2)
                                            .foregroundColor(.primary)
                                            .lineSpacing(2)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                        .padding(.top, 2)
                                }
                                .padding(12)
                                .background(theme.accent.opacity(DesignSystem.opacity.subtle))
                                .cornerRadius(DesignSystem.cornerRadius.md)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
        .background(theme.background.ignoresSafeArea())
        .navigationTitle(scripture.reference)
        .navigationBarTitleDisplayMode(.inline)
    }
}
