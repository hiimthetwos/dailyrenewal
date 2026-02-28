import Foundation
import SwiftData

enum StruggleType: String, Codable, CaseIterable {
    case alcohol = "Alcohol"
    case nicotineTobacco = "Nicotine & Tobacco"
    case cannabis = "Cannabis"
    case drugs = "Drugs"
    case food = "Food"
    case caffeine = "Caffeine"
    case sexLust = "Sex & Lust"
    case pornography = "Pornography"
    case anger = "Anger"
    case gambling = "Gambling"
    case videoGames = "Video Games"
    case socialMedia = "Social Media"
    case custom = "Other (Custom)"

    var icon: String {
        switch self {
        case .alcohol: return "wineglass"
        case .nicotineTobacco: return "smoke"
        case .cannabis: return "leaf"
        case .drugs: return "pills"
        case .food: return "fork.knife"
        case .caffeine: return "cup.and.saucer"
        case .sexLust: return "heart.slash"
        case .pornography: return "eye.slash"
        case .anger: return "exclamationmark.triangle"
        case .gambling: return "suit.club"
        case .videoGames: return "gamecontroller"
        case .socialMedia: return "iphone.slash"
        case .custom: return "pencil.circle"
        }
    }

    var foundationVerseKey: String {
        switch self {
        case .alcohol: return "1COR10:13"
        case .nicotineTobacco: return "1COR6:19-20"
        case .cannabis: return "1COR6:19-20"
        case .drugs: return "1COR6:19-20"
        case .food: return "1COR10:31"
        case .caffeine: return "1COR6:12"
        case .sexLust: return "1TH4:3-4"
        case .pornography: return "JOB31:1"
        case .anger: return "EPH4:26-27"
        case .gambling: return "GAL5:16"
        case .videoGames: return "EPH5:15-16"
        case .socialMedia: return "EPH5:15-16"
        case .custom: return "PHP4:13"
        }
    }
}

@Model
final class Struggle {
    var id: UUID
    var name: String
    var type: StruggleType
    var startDate: Date
    var isActive: Bool
    var slipDates: [Date]
    var createdAt: Date
    var notes: String

    @Relationship(deleteRule: .cascade) var checkIns: [DailyCheckIn]

    init(name: String, type: StruggleType, startDate: Date = .now, notes: String = "") {
        self.id = UUID()
        self.name = name
        self.type = type
        self.startDate = startDate
        self.isActive = true
        self.slipDates = []
        self.createdAt = .now
        self.notes = notes
        self.checkIns = []
    }

    var currentStreakDays: Int {
        DateHelpers.daysBetween(startDate, and: .now)
    }

    // Longest streak across all historical periods.
    // createdAt = first-ever start; slipDates = subsequent resets.
    var longestStreakDays: Int {
        var periods: [Date] = [createdAt] + slipDates.sorted()
        var longest = 0
        for i in 0..<periods.count {
            let from = periods[i]
            let to = i + 1 < periods.count ? periods[i + 1] : Date.now
            let days = DateHelpers.daysBetween(from, and: to)
            if days > longest { longest = days }
        }
        return longest
    }

    var totalSlipCount: Int {
        slipDates.count
    }

    func recordSlip() {
        slipDates.append(Date.now)
        startDate = Date.now
    }
}
