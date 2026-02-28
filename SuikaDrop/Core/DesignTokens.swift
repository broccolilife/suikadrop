// DesignTokens.swift — Shared Design Token System
// Applied from Pixel+Flow iOS UI knowledge base

import SwiftUI

// MARK: - Design Tokens

enum DesignTokens {
    
    // MARK: Spacing (8pt grid)
    enum Spacing {
        static let xxxs: CGFloat = 2
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }

    // MARK: Semantic Colors
    enum Colors {
        static let primary = Color("AccentColor")
        static let secondary = Color.secondary
        static let background = Color(.systemBackground)
        static let surfacePrimary = Color(.secondarySystemBackground)
        static let surfaceSecondary = Color(.tertiarySystemBackground)
        static let textPrimary = Color(.label)
        static let textSecondary = Color(.secondaryLabel)
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
    }

    // MARK: Elevation
    enum Elevation {
        static let card = ShadowStyle(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        static let popup = ShadowStyle(color: .black.opacity(0.15), radius: 20, x: 0, y: -4)
    }
    
    // MARK: Corner Radius
    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let pill: CGFloat = 999
    }
    
    // MARK: Typography (see Typography.swift for full type system)
    enum Typography {
        static let caption: Font = .caption
        static let body: Font = .body
        static let headline: Font = .headline
        static let title: Font = .title2
        static let largeTitle: Font = .largeTitle
        
        // Line heights (multipliers)
        static let tightLeading: CGFloat = 1.1
        static let normalLeading: CGFloat = 1.4
        static let relaxedLeading: CGFloat = 1.6
    }
    
    // MARK: Animation (see SpringAnimations.swift for spring presets)
    enum Motion {
        static let quick: Animation = .easeOut(duration: 0.15)
        static let standard: Animation = .easeInOut(duration: 0.3)
        static let bouncy: Animation = .bouncy(duration: 0.5, extraBounce: 0.3)
        static let spring: Animation = .spring(response: 0.4, dampingFraction: 0.7)
        static let snappySpring: Animation = .spring(response: 0.2, dampingFraction: 0.7)
        static let gentleSpring: Animation = .spring(response: 0.55, dampingFraction: 0.9)
    }
    
    // MARK: Opacity
    enum Opacity {
        static let disabled: Double = 0.4
        static let secondary: Double = 0.6
        static let overlay: Double = 0.8
        static let full: Double = 1.0
    }
    
    // MARK: Layout
    enum Layout {
        static let maxContentWidth: CGFloat = 428
        static let buttonHeight: CGFloat = 50
        static let iconSize: CGFloat = 24
        static let iconSizeLg: CGFloat = 32
    }
    
    // MARK: Shadows
    enum Shadow {
        static let sm: (color: Color, radius: CGFloat, y: CGFloat) = (.black.opacity(0.08), 4, 2)
        static let md: (color: Color, radius: CGFloat, y: CGFloat) = (.black.opacity(0.12), 8, 4)
        static let lg: (color: Color, radius: CGFloat, y: CGFloat) = (.black.opacity(0.16), 16, 8)
    }
}

// MARK: - Elevation Support

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

extension View {
    func elevation(_ style: ShadowStyle) -> some View {
        self.shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}
