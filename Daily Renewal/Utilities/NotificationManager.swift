import UserNotifications
import Foundation

enum NotificationManager {
    static func requestPermissionAndSchedule(hour: Int, minute: Int, onDenied: @escaping () -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                DispatchQueue.main.async {
                    if granted {
                        scheduleDailyReminder(hour: hour, minute: minute)
                    } else {
                        onDenied()
                    }
                }
            }
    }

    static func scheduleDailyReminder(
        hour: Int,
        minute: Int,
        title: String = "Daily Renewal",
        body: String = "Take a moment to check in with the Lord today."
    ) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])

        let content = UNMutableNotificationContent()
        content.title = title
        content.body  = body
        content.sound = .default

        var dateComponents    = DateComponents()
        dateComponents.hour   = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        center.add(request)
    }

    static func cancelDailyReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
    }
}
