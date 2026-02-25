// DesignTokens.swift — Shared Design Token System
// Applied from Pixel+Flow iOS UI knowledge base

import SwiftUI

// MARK: - Design Tokens

enum DesignTokens {
    
    // MARK: Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: Corner Radius
    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let pill: CGFloat = 999
    }
    
    // MARK: Typography
    enum Typography {
        static let caption: Font = .caption
        static let body: Font = .body
        static let headline: Font = .headline
        static let title: Font = .title2
        static let largeTitle: Font = .largeTitle
    }
    
    // MARK: Animation
    enum Motion {
        static let quick: Animation = .easeOut(duration: 0.15)
        static let standard: Animation = .easeInOut(duration: 0.3)
        static let bouncy: Animation = .bouncy(duration: 0.5, extraBounce: 0.3)
        static let spring: Animation = .spring(response: 0.4, dampingFraction: 0.7)
    }
    
    // MARK: Shadows
    enum Shadow {
        static let sm: (color: Color, radius: CGFloat, y: CGFloat) = (.black.opacity(0.08), 4, 2)
        static let md: (color: Color, radius: CGFloat, y: CGFloat) = (.black.opacity(0.12), 8, 4)
        static let lg: (color: Color, radius: CGFloat, y: CGFloat) = (.black.opacity(0.16), 16, 8)
    }
}
