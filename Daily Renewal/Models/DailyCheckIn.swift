import Foundation
import SwiftData

enum MoodRating: String, Codable, CaseIterable {
    case struggling = "Heavy-Laden"
    case weary = "Weary"
    case holding = "Holding On"
    case hopeful = "Hopeful"
    case grateful = "Grateful"

    var icon: String {
        switch self {
        case .struggling: return "cloud.rain.fill"
        case .weary: return "cloud.fill"
        case .holding: return "wind"
        case .hopeful: return "sun.horizon.fill"
        case .grateful: return "sun.max.fill"
        }
    }
}

@Model
final class DailyCheckIn {
    var id: UUID
    var date: Date
    var mood: MoodRating
    var prayerNote: String
    var gratitudeNote: String
    var assignedVerseKey: String

    init(
        date: Date = .now,
        mood: MoodRating,
        prayerNote: String = "",
        gratitudeNote: String = "",
        assignedVerseKey: String = ""
    ) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.mood = mood
        self.prayerNote = prayerNote
        self.gratitudeNote = gratitudeNote
        self.assignedVerseKey = assignedVerseKey
    }
}
