import SwiftUI

struct DailyVerseCardView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(BibleVersionManager.self) private var bibleVersionManager

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(theme.gold)
                Text("Today's Word")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                Spacer()
                Text(Date.now, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let verse = ScriptureLibrary.dailyVerse(version: bibleVersionManager.version) {
                Text(verse.text)
                    .font(.system(.body, design: .serif).italic())
                    .lineSpacing(5)
                    .foregroundColor(.primary)

                HStack {
                    Text("— \(verse.reference)")
                        .font(.system(.footnote, design: .serif))
                        .foregroundColor(theme.accent)
                    
                    Spacer()
                    
                    Text(verse.version.rawValue)
                        .font(.system(.caption2, design: .serif))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .background(theme.accent.opacity(DesignSystem.opacity.light))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.cornerRadius.md)
                .stroke(theme.accent.opacity(DesignSystem.opacity.medium), lineWidth: 1)
        )
        .cornerRadius(DesignSystem.cornerRadius.md)
        .padding(.horizontal)
    }
}

#Preview {
    DailyVerseCardView()
        .padding()
        .environment(ThemeManager())
        .environment(BibleVersionManager())
}
