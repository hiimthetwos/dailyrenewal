import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(BibleVersionManager.self) private var bibleVersionManager
    @AppStorage(AppSettings.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @State private var selectedTab = 0

    var body: some View {
        if hasCompletedOnboarding {
            mainTabView
        } else {
            OnboardingView()
        }
    }

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem { Label("Today",    systemImage: "house.fill") }
                .tag(0)

            JourneyView()
                .tabItem { Label("Journey",  systemImage: "figure.walk") }
                .tag(1)

            ScriptureView()
                .tabItem { Label("Scripture", systemImage: "book.closed.fill") }
                .tag(2)

            PartnersView()
                .tabItem { Label("Partners", systemImage: "person.2.fill") }
                .tag(3)
        }
        .tint(theme.accent)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Struggle.self, DailyCheckIn.self, AccountabilityPartner.self], inMemory: true)
        .environment(ThemeManager())
        .environment(BibleVersionManager())
}
