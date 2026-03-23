// Typography.swift — Type system for SuikaDrop
// Pixel+Muse — playful rounded type with dynamic type support

import SwiftUI

// MARK: - App Typography

enum AppTypography {

    // MARK: - Display Scale

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

    // MARK: - Monospaced (scores, timers)

    static let monoScore: Font = .system(size: 48, weight: .black, design: .monospaced)
    static let monoTimer: Font = .system(size: 20, weight: .semibold, design: .monospaced)
    static let monoCaption: Font = .system(size: 12, weight: .medium, design: .monospaced)

    // MARK: - Dynamic Type Scaling

    /// Returns a font that respects Dynamic Type settings
    static func scaled(_ size: CGFloat, weight: Font.Weight = .regular,
                       design: Font.Design = .rounded, relativeTo style: Font.TextStyle = .body) -> Font {
        .system(size: size, weight: weight, design: design)
    }

    /// Semantic text styles that map to app contexts
    enum Semantic {
        /// Score when fruit merges — attention-grabbing
        static let mergeScore: Font = .system(size: 28, weight: .heavy, design: .rounded)
        /// Combo counter — "+3 combo!"
        static let comboCounter: Font = .system(size: 20, weight: .bold, design: .rounded)
        /// Tutorial / onboarding text
        static let tutorial: Font = .system(size: 18, weight: .medium, design: .rounded)
        /// Button labels
        static let button: Font = .system(size: 16, weight: .semibold, design: .rounded)
        /// Badge text (level, rank)
        static let badge: Font = .system(size: 11, weight: .bold, design: .rounded)
    }
}

// MARK: - Typography View Modifier

struct TypeStyle: ViewModifier {
    let font: Font
    let color: Color
    let tracking: CGFloat
    let lineSpacing: CGFloat

    init(_ font: Font, color: Color = .primary, tracking: CGFloat = 0, lineSpacing: CGFloat = 0) {
        self.font = font
        self.color = color
        self.tracking = tracking
        self.lineSpacing = lineSpacing
    }

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
            .tracking(tracking)
            .lineSpacing(lineSpacing)
    }
}

// MARK: - Gradient Text Modifier

struct GradientText: ViewModifier {
    let gradient: Gradient
    let font: Font

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(
                LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
            )
    }
}

// MARK: - View Extensions

extension View {
    func typeStyle(_ font: Font, color: Color = .primary, tracking: CGFloat = 0, lineSpacing: CGFloat = 0) -> some View {
        modifier(TypeStyle(font, color: color, tracking: tracking, lineSpacing: lineSpacing))
    }

    /// Score display style — large, rounded, with slight letter spacing
    func scoreStyle() -> some View {
        modifier(TypeStyle(AppTypography.scoreDisplay, tracking: -1.5))
    }

    /// Hero title for game states
    func heroStyle() -> some View {
        modifier(TypeStyle(AppTypography.heroTitle, tracking: -0.5))
    }

    /// Merge score popup style
    func mergeScoreStyle() -> some View {
        modifier(TypeStyle(AppTypography.Semantic.mergeScore, color: DesignTokens.Colors.scoreGold, tracking: -0.3))
    }

    /// Gradient text for special moments
    func gradientText(font: Font, colors: [Color] = [.orange, .pink, .purple]) -> some View {
        modifier(GradientText(gradient: Gradient(colors: colors), font: font))
    }

    /// Combo counter with accent color
    func comboStyle() -> some View {
        modifier(TypeStyle(AppTypography.Semantic.comboCounter, color: DesignTokens.Colors.comboAccent))
    }
}

// MARK: - Text Convenience

extension Text {
    func score() -> Text {
        self.font(AppTypography.monoScore)
            .fontWeight(.black)
    }

    func sectionHeader() -> Text {
        self.font(AppTypography.sectionTitle)
            .foregroundColor(.secondary)
    }
}
