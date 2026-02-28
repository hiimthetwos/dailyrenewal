import Foundation

@Observable
class BibleVersionManager {
    private static let key = "selectedBibleVersion"
    
    var version: BibleVersion {
        didSet { UserDefaults.standard.set(version.rawValue, forKey: Self.key) }
    }
    
    init() {
        let saved = UserDefaults.standard.string(forKey: Self.key)
        self.version = BibleVersion(rawValue: saved ?? "") ?? .kjv
    }
}

enum AppSettings {
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
    static let dailyReminderEnabled   = "dailyReminderEnabled"
    static let dailyReminderHour      = "dailyReminderHour"
    static let dailyReminderMinute    = "dailyReminderMinute"
    static let biometricLockEnabled   = "biometricLockEnabled"
}
