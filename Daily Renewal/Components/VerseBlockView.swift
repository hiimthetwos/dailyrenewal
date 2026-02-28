import SwiftUI

struct VerseBlockView: View {
    @Environment(ThemeManager.self) private var theme
    let scripture: Scripture
    var showReference: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(scripture.text)
                .font(.system(.body, design: .serif).italic())
                .foregroundColor(.primary)
                .lineSpacing(4)

            if showReference {
                HStack {
                    Text("— \(scripture.reference)")
                        .font(.system(.footnote, design: .serif))
                        .foregroundColor(theme.accent)
                    
                    Spacer()
                    
                    Text(scripture.version.rawValue)
                        .font(.system(.caption2, design: .serif))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.accent.opacity(DesignSystem.opacity.subtle))
        .cornerRadius(DesignSystem.cornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.cornerRadius.md)
                .stroke(theme.accent.opacity(DesignSystem.opacity.light), lineWidth: 1)
        )
    }
}

#Preview {
    @Previewable @State var bibleVersionManager = BibleVersionManager()
    
    VStack(spacing: 20) {
        if let dailyVerse = ScriptureLibrary.dailyVerse(version: bibleVersionManager.version) {
            VerseBlockView(scripture: dailyVerse)
        }
        
        if let sampleScripture = ScriptureLibrary.scripture(for: "PHP4:13", version: .kjv) {
            VerseBlockView(scripture: sampleScripture, showReference: false)
        }
    }
    .padding()
    .environment(ThemeManager())
    .environment(bibleVersionManager)
}
