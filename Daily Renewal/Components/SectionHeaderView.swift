import SwiftUI

struct SectionHeaderView: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(.headline, design: .serif))
                .foregroundColor(.primary)

            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack(spacing: 20) {
        SectionHeaderView(title: "Your Struggles")
        SectionHeaderView(title: "Progress", subtitle: "This week's activity")
    }
    .padding()
}
