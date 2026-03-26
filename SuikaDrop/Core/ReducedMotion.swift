// ReducedMotion.swift — Motion accessibility for SuikaDrop
// From Pixel knowledge: respect user motion preferences, especially in games
// Doherty Threshold: 60fps target, but reduced motion users need alternatives

import SwiftUI

// MARK: - Reduced Motion Wrapper

struct MotionSafe<Content: View, Fallback: View>: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    let animated: () -> Content
    let reduced: () -> Fallback
    
    var body: some View {
        if reduceMotion {
            reduced()
        } else {
            animated()
        }
    }
}

// MARK: - Convenience Extension

extension View {
    /// Applies animation only when reduced motion is OFF
    func animationSafe<V: Equatable>(_ animation: Animation, value: V) -> some View {
        modifier(MotionSafeAnimationModifier(animation: animation, value: value))
    }
    
    /// Cross-fade transition safe for reduced motion
    func transitionSafe() -> some View {
        self.transition(.opacity)
    }
}

private struct MotionSafeAnimationModifier<V: Equatable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let animation: Animation
    let value: V
    
    func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            content.animation(animation, value: value)
        }
    }
}

// MARK: - Game-Specific: Merge Effect

enum MergeEffect {
    /// Returns appropriate merge animation respecting accessibility
    static func animation(reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.6)
    }
    
    /// Scale for score pop: reduced for motion-sensitive users
    static func scorePopScale(reduceMotion: Bool) -> CGFloat {
        reduceMotion ? 1.0 : SuikaTheme.scorePopScale
    }
}
