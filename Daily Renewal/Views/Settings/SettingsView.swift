import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ThemeManager.self) private var theme
    @Environment(BibleVersionManager.self) private var bibleVersionManager
    @AppStorage(AppSettings.dailyReminderEnabled) private var reminderEnabled = false
    @AppStorage(AppSettings.dailyReminderHour) private var reminderHour = 8
    @AppStorage(AppSettings.dailyReminderMinute) private var reminderMinute = 0

    @State private var reminderTime = Date()
    @State private var showingPermissionAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    themeSelectionView
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                }

                Section("Bible Version") {
                    Picker("Bible Version", selection: Binding(
                        get: { bibleVersionManager.version },
                        set: { bibleVersionManager.version = $0 }
                    )) {
                        ForEach(BibleVersion.allCases) { version in
                            Text(version.displayName)
                                .tag(version)
                        }
                    }
                    .tint(theme.accent)
                }

                Section("Daily Reminder") {
                    Toggle("Enable Reminders", isOn: $reminderEnabled)
                        .tint(theme.accent)
                        .onChange(of: reminderEnabled) { _, enabled in
                            HapticManager.impact(.light)
                            handleReminderToggle(enabled)
                        }

                    if reminderEnabled {
                        DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            .onChange(of: reminderTime) { _, newTime in
                                let comps = Calendar.current.dateComponents([.hour, .minute], from: newTime)
                                reminderHour   = comps.hour   ?? 8
                                reminderMinute = comps.minute ?? 0
                                NotificationManager.scheduleDailyReminder(
                                    hour: reminderHour, minute: reminderMinute
                                )
                            }
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(
                            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
                        )
                        .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Daily Renewal")
                            .fontWeight(.semibold)
                        Text("A faith-based sobriety companion with scripture from the King James Bible, English Standard Version, and New American Standard Bible 1995. Multiple Bible versions are included to provide different perspectives on God's Word.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    if let scripture = ScriptureLibrary.scripture(for: "LAM3:22-23", version: bibleVersionManager.version) {
                        VerseBlockView(scripture: scripture)
                            .listRowBackground(Color.clear)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(theme.accent)
                }
            }
            .onAppear {
                // Initialize reminder time from stored values
                if let initialTime = Calendar.current.date(bySettingHour: reminderHour, minute: reminderMinute, second: 0, of: Date()) {
                    reminderTime = initialTime
                }
            }
            .alert("Notifications Disabled", isPresented: $showingPermissionAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("To receive daily reminders, enable notifications for Daily Renewal in iOS Settings.")
            }
        }
    }

    private var themeSelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Theme")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack(spacing: 20) {
                ForEach(AppTheme.allCases) { appTheme in
                    ThemeSwatchView(
                        appTheme: appTheme,
                        isSelected: theme.theme == appTheme
                    ) {
                        theme.theme = appTheme
                        HapticManager.impact(.light)
                    }
                }
            }
        }
    }

    private func handleReminderToggle(_ enabled: Bool) {
        if enabled {
            NotificationManager.requestPermissionAndSchedule(
                hour: reminderHour,
                minute: reminderMinute
            ) {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(false, forKey: AppSettings.dailyReminderEnabled)
                    showingPermissionAlert = true
                }
            }
        } else {
            NotificationManager.cancelDailyReminder()
        }
    }
}

#Preview {
    SettingsView()
        .environment(ThemeManager())
        .environment(BibleVersionManager())
}

// MARK: – ThemeSwatchView

struct ThemeSwatchView: View {
    let appTheme: AppTheme
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(appTheme.colors.background)
                        .frame(width: 52, height: 52)
                        .overlay(
                            Circle()
                                .stroke(
                                    isSelected ? appTheme.colors.accent : Color.secondary.opacity(0.2),
                                    lineWidth: isSelected ? 3 : 1
                                )
                        )

                    Circle()
                        .fill(appTheme.colors.accent)
                        .frame(width: 28, height: 28)

                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                Text(appTheme.name)
                    .font(.caption2)
                    .foregroundColor(isSelected ? appTheme.colors.accent : .secondary)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .accessibilityLabel(appTheme.name)
    }
}
