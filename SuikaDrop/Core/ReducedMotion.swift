// ReducedMotion.swift — Accessibility: respect Reduce Motion & Reduce Transparency
// From Pixel knowledge (2026-02-28): Apple HIG — system materials & vibrancy,
// but always provide fallbacks for accessibility settings

import SwiftUI

// MARK: - Reduced Motion Support

extension Animation {
    /// Returns self or .default based on user's Reduce Motion preference
    static func accessibleSpring(response: Double = 0.4, dampingFraction: Double = 0.7) -> Animation {
        .spring(response: response, dampingFraction: dampingFraction)
    }
}

struct ReducedMotionModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    let animation: Animation
    let reducedAnimation: Animation

    func body(content: Content) -> some View {
        content.animation(reduceMotion ? reducedAnimation : animation)
    }
}

extension View {
    /// Applies animation respecting Reduce Motion preference
    func motionSafe(_ animation: Animation, reduced: Animation = .easeInOut(duration: 0.01)) -> some View {
        modifier(ReducedMotionModifier(animation: animation, reducedAnimation: reduced))
    }

    /// Glass material that degrades gracefully with Reduce Transparency
    func adaptiveMaterial(_ material: Material = .ultraThinMaterial) -> some View {
        modifier(AdaptiveMaterialModifier(material: material))
    }
}

// MARK: - Adaptive Material (Reduce Transparency)

struct AdaptiveMaterialModifier: ViewModifier {
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    let material: Material

    func body(content: Content) -> some View {
        if reduceTransparency {
            content.background(Color(.secondarySystemBackground))
        } else {
            content.background(material)
        }
    }
}
