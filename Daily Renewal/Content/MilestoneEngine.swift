import Foundation

struct Milestone: Identifiable {
    let id: String
    let days: Int
    let title: String
    let message: String
    let verseKey: String
}

enum MilestoneEngine {
    // 14 milestones — Day 1 through Day 1000
    static let all: [Milestone] = [
        Milestone(
            id: "day1", days: 1,
            title: "First Step",
            message: "One day of walking in the light. Every great journey begins with a single step of faith. His mercies welcomed you this morning, and they will meet you again tomorrow.",
            verseKey: "LAM3:22-23"),
        Milestone(
            id: "day3", days: 3,
            title: "Three Days Strong",
            message: "As Christ rose on the third day, so too does your new life begin to rise. His resurrection power is not merely history — it is the power at work in you right now.",
            verseKey: "2COR5:17"),
        Milestone(
            id: "day7", days: 7,
            title: "One Week Faithful",
            message: "Seven days — a full week resting in His grace. As He called the seventh day holy, your faithfulness this week is holy unto Him. He has seen every moment.",
            verseKey: "PHP4:13"),
        Milestone(
            id: "day14", days: 14,
            title: "Two Weeks Walking",
            message: "Fourteen days of choosing Him over the old way. Your feet are learning a new path, and the Lord orders every step of the righteous.",
            verseKey: "HEB12:1"),
        Milestone(
            id: "day21", days: 21,
            title: "Three Weeks Transformed",
            message: "Three weeks of walking in the Spirit. New habits are forming, old strongholds are crumbling — not by your power or might, but by His Spirit.",
            verseKey: "ROM12:2"),
        Milestone(
            id: "day30", days: 30,
            title: "One Month of Grace",
            message: "Thirty days of His faithfulness meeting yours. Every morning has brought new mercy, and thirty mornings you have received it. That is no small thing.",
            verseKey: "ISA40:31"),
        Milestone(
            id: "day60", days: 60,
            title: "Two Months Redeemed",
            message: "Sixty days of redemption written in His book. You are not who you were — you are who He says you are. Old things have passed away.",
            verseKey: "GAL2:20"),
        Milestone(
            id: "day90", days: 90,
            title: "Ninety Days Renewed",
            message: "Ninety days of His mercies, new every morning. This is not merely discipline or habit — this is the testimony of a life surrendered to the living God.",
            verseKey: "ISA43:18-19"),
        Milestone(
            id: "day180", days: 180,
            title: "Half a Year Holy",
            message: "Six months. The Lord has been your strength in every trial and your rest in every quiet moment. You have proven His word true — He does not abandon those who seek Him.",
            verseKey: "PSA46:1"),
        Milestone(
            id: "day270", days: 270,
            title: "Nine Months Sustained",
            message: "Nine months — long enough for new life to be born. Something holy has been forming in you through every day of surrender. Others are beginning to see it too.",
            verseKey: "1PET2:9"),
        Milestone(
            id: "day365", days: 365,
            title: "One Year Victorious",
            message: "A full year of walking free. Three hundred and sixty-five mornings of new mercy received. The Lord has been faithful, and so have you.",
            verseKey: "ROM8:1"),
        Milestone(
            id: "day500", days: 500,
            title: "Five Hundred Days",
            message: "Five hundred days of testimony. Your story of grace is becoming a lamp to those who still walk in darkness. Let it shine before men.",
            verseKey: "2COR12:9"),
        Milestone(
            id: "day730", days: 730,
            title: "Two Years Faithful",
            message: "Two full years surrendered to the Lord. What He has begun in you, He is faithful and able to complete. You are living proof of His power to transform a life.",
            verseKey: "EPH2:10"),
        Milestone(
            id: "day1000", days: 1000,
            title: "One Thousand Days",
            message: "One thousand days of grace upon grace. The Lord has rewritten your story. May your testimony declare His goodness for a thousand more.",
            verseKey: "1COR10:13"),
    ]

    static func achieved(for days: Int) -> [Milestone] {
        all.filter { $0.days <= days }
    }

    static func next(after days: Int) -> Milestone? {
        all.first { $0.days > days }
    }

    /// Progress (0–1) from the last achieved milestone to the next.
    static func progress(currentDays: Int) -> Double {
        guard let next = next(after: currentDays) else { return 1.0 }
        let previousDays = all.last { $0.days <= currentDays }?.days ?? 0
        let span    = next.days - previousDays
        let elapsed = currentDays - previousDays
        return span > 0 ? Double(elapsed) / Double(span) : 0
    }

    static func justAchieved(for days: Int) -> Milestone? {
        all.first { $0.days == days }
    }
}
