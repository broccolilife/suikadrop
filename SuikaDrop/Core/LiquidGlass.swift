// LiquidGlass.swift — iOS 26 Liquid Glass Preparation
// From Pixel knowledge (2026-02-25): glassEffect modifier + GlassEffectContainer
// Perfect for floating game controls in SuikaDrop

import SwiftUI

// MARK: - Glass Effect Utilities

extension View {
    /// Applies glass material styling, forward-compatible with iOS 26 Liquid Glass
    /// Use for toolbars, FABs, floating controls — NOT for list rows
    func glassCard(cornerRadius: CGFloat = DesignTokens.Radius.lg) -> some View {
        self
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: DesignTokens.Shadow.sm.color, radius: DesignTokens.Shadow.sm.radius, y: DesignTokens.Shadow.sm.y)
    }
    
    /// Floating action button style with glass material
    func glassFAB() -> some View {
        self
            .font(.title2.bold())
            .frame(width: 56, height: 56)
            .background(.ultraThinMaterial, in: Circle())
            .shadow(color: DesignTokens.Shadow.md.color, radius: DesignTokens.Shadow.md.radius, y: DesignTokens.Shadow.md.y)
            .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Mesh Gradient Background (iOS 18+)

struct MeshGradientBackground: View {
    let colors: [Color]
    @State private var animating = false
    
    var body: some View {
        if #available(iOS 18.0, *) {
            MeshGradient(
                width: 3, height: 3,
                points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [animating ? 0.6 : 0.4, 0.5], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ],
                colors: colors.count >= 9 ? Array(colors.prefix(9)) : paddedColors
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    animating.toggle()
                }
            }
            .accessibilityHidden(true)
        } else {
            LinearGradient(colors: colors.prefix(2).map { $0 }, startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .accessibilityHidden(true)
        }
    }
    
    private var paddedColors: [Color] {
        var padded = colors
        while padded.count < 9 { padded.append(padded.last ?? .clear) }
        return padded
    }
}

// MARK: - Phase Animator Helpers (iOS 17+)

extension View {
    /// Pulsing attention effect for score popups, power-ups
    func pulseEffect(active: Bool = true) -> some View {
        self.phaseAnimator([false, true], trigger: active) { content, phase in
            content
                .scaleEffect(phase ? 1.15 : 1.0)
                .opacity(phase ? 1.0 : 0.8)
        } animation: { _ in
            .easeInOut(duration: 0.8)
        }
    }
    
    /// Bounce-in entrance for game elements
    func bounceEntrance() -> some View {
        self.transition(
            .asymmetric(
                insertion: .scale(scale: 1.5).combined(with: .opacity),
                removal: .scale(scale: 0.5).combined(with: .opacity)
            )
        )
    }
}
