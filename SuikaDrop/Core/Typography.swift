import SwiftUI

// MARK: - Typography System for SuikaDrop

/// Semantic type styles with Dynamic Type support.
/// Uses SF Rounded for the playful game aesthetic.

enum AppTypography {

    // MARK: - Font Definitions

    /// Display — large score, game over title
    static let display = Font.system(.largeTitle, design: .rounded, weight: .black)

    /// Score — in-game score counter
    static let score = Font.system(size: 48, weight: .heavy, design: .rounded)

    /// Title — screen titles, section headers
    static let title = Font.system(.title2, design: .rounded, weight: .bold)

    /// Subtitle — secondary headers
    static let subtitle = Font.system(.title3, design: .rounded, weight: .semibold)

    /// Headline — card titles, list headers
    static let headline = Font.system(.headline, design: .rounded, weight: .semibold)

    /// Body — descriptions, instructions
    static let body = Font.system(.body, design: .rounded)

    /// Callout — hints, tips
    static let callout = Font.system(.callout, design: .rounded)

    /// Caption — metadata, timestamps
    static let caption = Font.system(.caption, design: .rounded)

    /// Micro — tiny labels, badges
    static let micro = Font.system(.caption2, design: .rounded, weight: .medium)

    // MARK: - Line Height Multipliers

    static let tightLeading: CGFloat = 1.1
    static let normalLeading: CGFloat = 1.4
    static let relaxedLeading: CGFloat = 1.6

    // MARK: - Letter Spacing

    static let tightTracking: CGFloat = -0.5
    static let normalTracking: CGFloat = 0
    static let wideTracking: CGFloat = 1.5
    static let superWide: CGFloat = 3.0  // "GAME OVER", "NEW RECORD"
}

// MARK: - View Modifiers

extension View {
    /// Apply a semantic text style with optional color.
    func textStyle(_ font: Font, color: Color = DesignTokens.Colors.textPrimary) -> some View {
        self
            .font(font)
            .foregroundStyle(color)
    }

    /// Mono-spaced digits for score displays.
    func monospacedScore() -> some View {
        self
            .font(AppTypography.score)
            .monospacedDigit()
            .foregroundStyle(DesignTokens.Colors.scoreAccent)
    }

    /// Game-over / announcement style — large, tracked out, dramatic.
    func announcementStyle() -> some View {
        self
            .font(AppTypography.display)
            .tracking(AppTypography.superWide)
            .foregroundStyle(DesignTokens.Colors.textPrimary)
            .multilineTextAlignment(.center)
    }
}

// MARK: - Text Convenience

extension Text {
    /// Score text with monospaced digits and rounded font.
    func scoreStyle() -> Text {
        self
            .font(AppTypography.score)
            .monospacedDigit()
            .fontDesign(.rounded)
    }

    /// Caption with secondary color.
    func captionSecondary() -> Text {
        self
            .font(AppTypography.caption)
            .foregroundStyle(DesignTokens.Colors.textSecondary)
    }
}
