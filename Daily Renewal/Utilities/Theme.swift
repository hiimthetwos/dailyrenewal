import SwiftUI
import UIKit

// MARK: – Adaptive brand colors (light / dark)
extension Color {
    static let parchmentBackground = Color(
        light: Color(hex: "F5ECD7"), dark: Color(hex: "1C1610")
    )
    static let warmAmber = Color(
        light: Color(hex: "C17D3C"), dark: Color(hex: "D4924A")
    )
    static let deepMaroon = Color(
        light: Color(hex: "6B1E1E"), dark: Color(hex: "B05252")
    )
    static let softGold = Color(
        light: Color(hex: "E8C84A"), dark: Color(hex: "D4AF37")
    )
    static let mossGreen = Color(
        light: Color(hex: "4A7C59"), dark: Color(hex: "5E9970")
    )

    // MARK: – Convenience initialisers

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    init(light: Color, dark: Color) {
        self.init(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

// MARK: – Design System constants

enum DesignSystem {
    enum cornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let pill: CGFloat = 20
    }
    enum opacity {
        static let subtle: Double = 0.08
        static let light: Double = 0.15
        static let medium: Double = 0.30
    }
}

// MARK: – Theme system

struct ThemeColors {
    let background: Color
    let accent: Color
    let maroon: Color
    let gold: Color
    let green: Color

    static let parchment = ThemeColors(
        background: Color(light: Color(hex: "F5ECD7"), dark: Color(hex: "1C1610")),
        accent:     Color(light: Color(hex: "C17D3C"), dark: Color(hex: "D4924A")),
        maroon:     Color(light: Color(hex: "6B1E1E"), dark: Color(hex: "B05252")),
        gold:       Color(light: Color(hex: "E8C84A"), dark: Color(hex: "D4AF37")),
        green:      Color(light: Color(hex: "4A7C59"), dark: Color(hex: "5E9970"))
    )

    static let ocean = ThemeColors(
        background: Color(light: Color(hex: "E8F4FC"), dark: Color(hex: "0D1E2D")),
        accent:     Color(light: Color(hex: "2E6EA6"), dark: Color(hex: "4A90D0")),
        maroon:     Color(light: Color(hex: "6B2040"), dark: Color(hex: "B04A6A")),
        gold:       Color(light: Color(hex: "D4A83C"), dark: Color(hex: "C49B30")),
        green:      Color(light: Color(hex: "2D7A5E"), dark: Color(hex: "4A9E7A"))
    )

    static let forest = ThemeColors(
        background: Color(light: Color(hex: "EAF4EA"), dark: Color(hex: "0F1A10")),
        accent:     Color(light: Color(hex: "2D6A4F"), dark: Color(hex: "50A07A")),
        maroon:     Color(light: Color(hex: "7A3030"), dark: Color(hex: "B05252")),
        gold:       Color(light: Color(hex: "D4A83C"), dark: Color(hex: "C49B30")),
        green:      Color(light: Color(hex: "3D7A4A"), dark: Color(hex: "5EA06A"))
    )

    static let evening = ThemeColors(
        background: Color(light: Color(hex: "F0EDF8"), dark: Color(hex: "14101F")),
        accent:     Color(light: Color(hex: "6840A0"), dark: Color(hex: "9B70D4")),
        maroon:     Color(light: Color(hex: "7A2050"), dark: Color(hex: "C04888")),
        gold:       Color(light: Color(hex: "D4A83C"), dark: Color(hex: "C49B30")),
        green:      Color(light: Color(hex: "3D6A5A"), dark: Color(hex: "5A9080"))
    )
}

enum AppTheme: String, CaseIterable, Identifiable {
    case parchment, ocean, forest, evening

    var id: String { rawValue }

    var name: String {
        switch self {
        case .parchment: return "Parchment"
        case .ocean:     return "Ocean"
        case .forest:    return "Forest"
        case .evening:   return "Evening"
        }
    }

    var colors: ThemeColors {
        switch self {
        case .parchment: return .parchment
        case .ocean:     return .ocean
        case .forest:    return .forest
        case .evening:   return .evening
        }
    }
}

@Observable
class ThemeManager {
    private static let key = "appTheme"

    var theme: AppTheme {
        didSet { UserDefaults.standard.set(theme.rawValue, forKey: Self.key) }
    }

    init() {
        let saved = UserDefaults.standard.string(forKey: Self.key)
        self.theme = AppTheme(rawValue: saved ?? "") ?? .ocean
    }

    var background: Color { theme.colors.background }
    var accent: Color     { theme.colors.accent }
    var maroon: Color     { theme.colors.maroon }
    var gold: Color       { theme.colors.gold }
    var green: Color      { theme.colors.green }
}

// MARK: – PressButtonStyle

struct PressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: – ToastModifier

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    @Environment(ThemeManager.self) private var themeManager

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content

            if isPresented {
                Text(message)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(themeManager.accent)
                    .cornerRadius(DesignSystem.cornerRadius.pill)
                    .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                    .padding(.top, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isPresented)
        .onChange(of: isPresented) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isPresented = false
                }
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message))
    }
}

// MARK: – TextEditorWithPlaceholder

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    let placeholder: String
    var minHeight: CGFloat = 80

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .frame(minHeight: minHeight)
                .font(.system(.body, design: .serif))

            if text.isEmpty {
                Text(placeholder)
                    .font(.system(.body, design: .serif))
                    .foregroundColor(Color(.placeholderText))
                    .padding(.top, 8)
                    .padding(.leading, 5)
                    .allowsHitTesting(false)
            }
        }
    }
}
