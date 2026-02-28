import SwiftUI

struct OnboardingView: View {
    @Environment(ThemeManager.self) private var theme
    @AppStorage(AppSettings.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @State private var page = 0

    var body: some View {
        TabView(selection: $page) {
            OnboardingPageView(
                icon: "sunrise.fill",
                title: "New Every Morning",
                message: "\"It is of the LORD's mercies that we are not consumed, because his compassions fail not. They are new every morning: great is thy faithfulness.\"\n\n— Lamentations 3:22–23",
                isQuote: true
            )
            .tag(0)

            OnboardingPageView(
                icon: "figure.walk",
                title: "Track Your Journey",
                message: "Add the struggles you are walking free from. Your streak is a testimony of God's faithfulness — one day at a time.",
                isQuote: false
            )
            .tag(1)

            OnboardingPageView(
                icon: "book.closed.fill",
                title: "Grounded in His Word",
                message: "40 King James Bible verses organised by theme — always available, always free, no internet required.",
                isQuote: false
            )
            .tag(2)

            OnboardingPageView(
                icon: "person.2.fill",
                title: "Walk With Others",
                message: "\"Iron sharpeneth iron.\" Add accountability partners who will pray with you and walk beside you on the journey.",
                isQuote: false
            )
            .tag(3)

            // Final page with Begin button
            finalPage
                .tag(4)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(theme.background.ignoresSafeArea())
    }

    private var finalPage: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "heart.fill")
                .font(.system(size: 72))
                .foregroundColor(theme.accent)

            VStack(spacing: 16) {
                Text("You Are Not Alone")
                    .font(.system(.largeTitle, design: .serif))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("\"There hath no temptation taken you but such as is common to man: but God is faithful.\"\n\n— 1 Corinthians 10:13")
                    .font(.system(.body, design: .serif).italic())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 32)
                    .lineSpacing(4)
            }

            Spacer()

            Button {
                HapticManager.success()
                hasCompletedOnboarding = true
            } label: {
                Text("Begin My Journey")
                    .font(.system(.headline, design: .serif))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.accent)
                    .foregroundColor(.white)
                    .cornerRadius(DesignSystem.cornerRadius.md)
            }
            .buttonStyle(PressButtonStyle())
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
        }
        .padding()
    }
}

struct OnboardingPageView: View {
    @Environment(ThemeManager.self) private var theme
    let icon: String
    let title: String
    let message: String
    let isQuote: Bool

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: 72))
                .foregroundColor(theme.accent)

            VStack(spacing: 16) {
                Text(title)
                    .font(.system(.largeTitle, design: .serif))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(isQuote
                          ? .system(.body, design: .serif).italic()
                          : .system(.body, design: .serif))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 32)
                    .lineSpacing(4)
            }

            Spacer()

            Text("Swipe to continue →")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 8)
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
        .environment(ThemeManager())
}
