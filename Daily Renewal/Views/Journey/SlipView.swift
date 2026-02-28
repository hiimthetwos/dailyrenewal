import SwiftUI

struct SlipView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(\.dismiss) private var dismiss
    @Bindable var struggle: Struggle

    @State private var confirmationStep = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // Grace header
                    VStack(spacing: 12) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 52))
                            .foregroundColor(theme.accent)
                            .padding(.top, 8)

                        Text("Come Back to Him")
                            .font(.system(.title, design: .serif))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)

                        Text("There is no condemnation for those who are in Christ Jesus. He is faithful and just to receive you.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }

                    // 1 John 1:9
                    if let verse = ScriptureLibrary.scripture(for: "1JN1:9") {
                        VerseBlockView(scripture: verse)
                            .padding(.horizontal)
                    }

                    // Psalm 34:17-18
                    if let verse = ScriptureLibrary.scripture(for: "PS34:17-18") {
                        VerseBlockView(scripture: verse)
                            .padding(.horizontal)
                    }

                    Text("Your streak days are not lost to heaven — they are recorded there. Resetting your clock does not erase the work God has done in you. His mercies are new every morning.")
                        .font(.system(.body, design: .serif))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .italic()
                        .padding(.horizontal, 32)

                    // Two-tap confirmation
                    if confirmationStep == 0 {
                        Button {
                            confirmationStep = 1
                            HapticManager.warning()
                        } label: {
                            Text("Reset My Streak")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(theme.maroon.opacity(DesignSystem.opacity.light))
                                .foregroundColor(theme.maroon)
                                .cornerRadius(DesignSystem.cornerRadius.md)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignSystem.cornerRadius.md)
                                        .stroke(theme.maroon.opacity(DesignSystem.opacity.medium), lineWidth: 1)
                                )
                        }
                        .buttonStyle(PressButtonStyle())
                        .padding(.horizontal)
                    } else {
                        VStack(spacing: 12) {
                            Text("This will reset your current streak of **\(struggle.currentStreakDays) days**. Your longest streak will always be remembered.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)

                            Button {
                                recordSlip()
                            } label: {
                                Text("Yes, Reset and Begin Again")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(theme.maroon)
                                    .foregroundColor(.white)
                                    .cornerRadius(DesignSystem.cornerRadius.md)
                            }
                            .buttonStyle(PressButtonStyle())
                            .padding(.horizontal)

                            Button("Go Back") {
                                confirmationStep = 0
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("A New Beginning")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .foregroundColor(theme.accent)
                }
            }
        }
    }

    private func recordSlip() {
        struggle.recordSlip()
        HapticManager.success()
        dismiss()
    }
}
