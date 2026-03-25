// Typography.swift — Type system for SuikaDrop
// Pixel+Muse — consistent typographic scale with dynamic type support

import SwiftUI

// MARK: - App Typography

enum AppTypography {
    
    // MARK: - Font Scale (relative to dynamic type)
    
    /// Score display — big, bold, playful
    static let scoreDisplay: Font = .system(size: 48, weight: .black, design: .rounded)
    
    /// Game over / level complete headers
    static let heroTitle: Font = .system(size: 34, weight: .bold, design: .rounded)
    
    /// Section titles (menus, settings)
    static let sectionTitle: Font = .system(size: 22, weight: .semibold, design: .rounded)
    
    /// Card titles, fruit names
    static let cardTitle: Font = .system(size: 17, weight: .semibold, design: .rounded)
    
    /// Primary body text
    static let body: Font = .system(size: 16, weight: .regular, design: .rounded)
    
    /// Secondary / supporting text
    static let secondary: Font = .system(size: 14, weight: .regular, design: .rounded)
    
    /// Captions, timestamps, labels
    static let caption: Font = .system(size: 12, weight: .medium, design: .rounded)
    
    /// Tiny labels (badges, counters)
    static let micro: Font = .system(size: 10, weight: .bold, design: .rounded)
    
    // MARK: - Monospaced (for scores/timers)
    
    static let monoScore: Font = .system(size: 48, weight: .black, design: .monospaced)
    static let monoTimer: Font = .system(size: 20, weight: .semibold, design: .monospaced)
    static let monoCaption: Font = .system(size: 12, weight: .medium, design: .monospaced)
}

// MARK: - Typography View Modifier

struct TypeStyle: ViewModifier {
    let font: Font
    let color: Color
    let tracking: CGFloat
    
    init(_ font: Font, color: Color = .primary, tracking: CGFloat = 0) {
        self.font = font
        self.color = color
        self.tracking = tracking
    }
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
            .tracking(tracking)
    }
}

extension View {
    /// Apply a consistent type style
    func typeStyle(_ font: Font, color: Color = .primary, tracking: CGFloat = 0) -> some View {
        modifier(TypeStyle(font, color: color, tracking: tracking))
    }
    
    /// Score display style — large, rounded, with slight letter spacing
    func scoreStyle() -> some View {
        modifier(TypeStyle(AppTypography.scoreDisplay, tracking: -1.5))
    }
    
    /// Hero title for game states
    func heroStyle() -> some View {
        modifier(TypeStyle(AppTypography.heroTitle, tracking: -0.5))
    }
    
    /// Combo multiplier text — escalating emphasis
    func comboStyle() -> some View {
        modifier(TypeStyle(AppTypography.comboText, color: .orange, tracking: 1.0))
    }
}

// MARK: - Dynamic Type Scaling

extension AppTypography {
    /// Combo multiplier — "x3!", "x4!"
    static let comboText: Font = .system(size: 28, weight: .heavy, design: .rounded)
    
    /// Tutorial / onboarding text
    static let tutorial: Font = .system(size: 18, weight: .medium, design: .rounded)
    
    /// Leaderboard rank
    static let rank: Font = .system(size: 20, weight: .bold, design: .monospaced)
    
    /// Accessible variants that respect Dynamic Type
    enum Accessible {
        static let scoreDisplay: Font = .system(.largeTitle, design: .rounded, weight: .black)
        static let heroTitle: Font = .system(.title, design: .rounded, weight: .bold)
        static let body: Font = .system(.body, design: .rounded)
        static let caption: Font = .system(.caption, design: .rounded, weight: .medium)
    }
}
