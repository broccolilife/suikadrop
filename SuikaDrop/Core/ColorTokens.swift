// ColorTokens.swift — SuikaDrop semantic color palette
// Pixel+Muse — fruit-themed colors with dark mode support

import SwiftUI

// MARK: - Color Palette

enum SDColor {
    // Fruit tier colors (smallest → largest)
    static let cherry      = Color(hex: "E74C3C")
    static let strawberry  = Color(hex: "FF6B6B")
    static let grape       = Color(hex: "9B59B6")
    static let dekopon     = Color(hex: "F39C12")
    static let persimmon   = Color(hex: "E67E22")
    static let apple       = Color(hex: "2ECC71")
    static let pear        = Color(hex: "A8D84E")
    static let peach       = Color(hex: "FFB6C1")
    static let pineapple   = Color(hex: "F1C40F")
    static let melon       = Color(hex: "27AE60")
    static let watermelon  = Color(hex: "1ABC9C")

    // UI semantic colors
    static let background      = Color(.systemBackground)
    static let backgroundGame  = Color(hex: "1A1A2E")
    static let backgroundMenu  = Color(.secondarySystemBackground)
    static let surface         = Color(.secondarySystemBackground)

    static let textPrimary   = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    static let textOnDark    = Color.white

    // Game state
    static let dangerZone = Color(hex: "E74C3C").opacity(0.3)
    static let comboGlow  = Color(hex: "FFD700")
    static let mergeBurst = Color.white
    
    // Accent
    static let accent      = Color(hex: "FF6B35")
    static let accentLight = Color(hex: "FF8F65")
}

// MARK: - Hex Init

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255,
                  blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// MARK: - Fruit Color Lookup

extension SDColor {
    static func forFruitTier(_ tier: Int) -> Color {
        let colors: [Color] = [
            cherry, strawberry, grape, dekopon, persimmon,
            apple, pear, peach, pineapple, melon, watermelon
        ]
        return colors[min(tier, colors.count - 1)]
    }
    
    /// Glow color for merge particle effects
    static func mergeGlow(_ tier: Int) -> Color {
        forFruitTier(tier).opacity(0.6)
    }
}

// MARK: - Game Gradients

enum SDGradient {
    static let gameBackground = LinearGradient(
        colors: [Color(hex: "1A1A2E"), Color(hex: "16213E")],
        startPoint: .top, endPoint: .bottom
    )
    
    static let dangerWarning = LinearGradient(
        colors: [SDColor.dangerZone, Color.clear],
        startPoint: .top, endPoint: .center
    )
    
    static let comboStreak = LinearGradient(
        colors: [Color(hex: "FFD700"), Color(hex: "FF6B35")],
        startPoint: .leading, endPoint: .trailing
    )
    
    static func fruitGlow(_ tier: Int) -> RadialGradient {
        RadialGradient(
            colors: [SDColor.forFruitTier(tier).opacity(0.4), Color.clear],
            center: .center, startRadius: 5, endRadius: 40
        )
    }
}
