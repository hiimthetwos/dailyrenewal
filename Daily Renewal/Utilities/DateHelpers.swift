import Foundation

enum DateHelpers {
    /// Number of calendar days between two dates. Never uses raw TimeInterval math.
    static func daysBetween(_ start: Date, and end: Date) -> Int {
        let cal = Calendar.current
        let from = cal.startOfDay(for: start)
        let to   = cal.startOfDay(for: end)
        let components = cal.dateComponents([.day], from: from, to: to)
        return max(components.day ?? 0, 0)
    }

    static func startOfDay(_ date: Date = .now) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    static func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }

    static func formattedStreakDays(_ days: Int) -> String {
        switch days {
        case 0:  return "Day 0 — Starting Today"
        case 1:  return "1 Day"
        default: return "\(days) Days"
        }
    }
}
