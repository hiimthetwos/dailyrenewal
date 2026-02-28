import SwiftUI
import SwiftData

@main
struct Daily_RenewalApp: App {
    @State private var themeManager = ThemeManager()
    @State private var bibleVersionManager = BibleVersionManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Struggle.self,
            DailyCheckIn.self,
            AccountabilityPartner.self,
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(themeManager)
                .environment(bibleVersionManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
