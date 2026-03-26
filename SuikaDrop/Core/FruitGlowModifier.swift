// FruitGlowModifier.swift — Radial glow effect for fruit items during merges
// Applies a pulsing glow halo around fruit views for visual feedback

import SwiftUI

/// Adds a radial glow halo around a view, with optional pulse animation.
/// Use on fruit views during merge events or level-up moments.
struct FruitGlowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let isActive: Bool

    @State private var glowPhase: Bool = false

    func body(content: Content) -> some View {
        content
            .shadow(
                color: isActive ? color.opacity(glowPhase ? 0.7 : 0.3) : .clear,
                radius: isActive ? radius * (glowPhase ? 1.2 : 0.8) : 0
            )
            .shadow(
                color: isActive ? color.opacity(glowPhase ? 0.4 : 0.15) : .clear,
                radius: isActive ? radius * 1.8 : 0
            )
            .onChange(of: isActive) { _, active in
                if active { startPulse() }
            }
            .onAppear {
                if isActive { startPulse() }
            }
    }

    private func startPulse() {
        withAnimation(
            .easeInOut(duration: 0.6)
            .repeatForever(autoreverses: true)
        ) {
            glowPhase = true
        }
    }
}

extension View {
    /// Applies a pulsing radial glow around the view.
    /// - Parameters:
    ///   - color: Glow color (match the fruit's theme color).
    ///   - radius: Base blur radius for the glow. Default 12.
    ///   - isActive: Whether the glow is currently visible.
    func fruitGlow(
        color: Color,
        radius: CGFloat = 12,
        isActive: Bool = true
    ) -> some View {
        modifier(FruitGlowModifier(color: color, radius: radius, isActive: isActive))
    }
}

// MARK: - Merge Burst Effect

/// A one-shot radial burst effect for when two fruits merge.
/// Place in a ZStack at the merge point and it auto-animates then removes itself.
struct MergeBurstView: View {
    let color: Color
    let onComplete: (() -> Void)?

    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 1.0

    init(color: Color, onComplete: (() -> Void)? = nil) {
        self.color = color
        self.onComplete = onComplete
    }

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        color.opacity(0.8),
                        color.opacity(0.3),
                        color.opacity(0)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 40
                )
            )
            .frame(width: 80, height: 80)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) {
                    scale = 1.5
                }
                withAnimation(.easeOut(duration: 0.5).delay(0.15)) {
                    opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    onComplete?()
                }
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 40) {
            // Glow demo
            Circle()
                .fill(.orange)
                .frame(width: 60, height: 60)
                .fruitGlow(color: .orange, radius: 14)

            Circle()
                .fill(.purple)
                .frame(width: 60, height: 60)
                .fruitGlow(color: .purple, radius: 14)

            // Burst demo
            MergeBurstView(color: .yellow)
        }
    }
}
