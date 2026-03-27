// MeshBackground.swift — Animated MeshGradient backgrounds
// From Pixel knowledge (2/23): MeshGradient for living backgrounds, iOS 18+
// PhaseAnimator for looping attention effects without Timer boilerplate

import SwiftUI

// MARK: - Animated Mesh Background

@available(iOS 18.0, *)
struct SuikaMeshBackground: View {
    @State private var animating = false
    
    var body: some View {
        MeshGradient(
            width: 3, height: 3,
            points: [
                [0, 0], [0.5, 0], [1, 0],
                [0, 0.5], [animating ? 0.6 : 0.4, 0.5], [1, 0.5],
                [0, 1], [0.5, 1], [1, 1]
            ],
            colors: [
                SuikaTheme.peach, SuikaTheme.pear, SuikaTheme.apple,
                SuikaTheme.strawberry, SuikaTheme.orange, SuikaTheme.melon,
                SuikaTheme.cherry, SuikaTheme.grape, SuikaTheme.watermelon
            ]
        )
        .ignoresSafeArea()
        .opacity(0.3)
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                animating = true
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Fallback Gradient (pre-iOS 18)

struct SuikaGradientBackground: View {
    var body: some View {
        LinearGradient(
            colors: SuikaTheme.backgroundColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

// MARK: - Adaptive Background (auto-selects best available)

struct AdaptiveGameBackground: View {
    var body: some View {
        if #available(iOS 18.0, *) {
            SuikaMeshBackground()
        } else {
            SuikaGradientBackground()
        }
    }
}
