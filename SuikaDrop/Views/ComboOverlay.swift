// ComboOverlay.swift — Animated combo counter for merge chains
// Uses PhaseAnimator (iOS 17+) for fever-mode pulsing

import SwiftUI

/// Animated combo counter that appears center-screen during merge chains.
/// Punches in with a spring, then floats up and fades out.
/// During fever mode, continuously pulses with a bouncy animation.
struct ComboOverlay: View {
    let combo: Int
    let feverActive: Bool

    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 0
    @State private var offsetY: CGFloat = 0

    var body: some View {
        if combo >= 2 {
            VStack(spacing: 4) {
                // Combo count — pulses continuously during fever
                Text("\(combo)× COMBO")
                    .font(.system(size: comboFontSize, weight: .black, design: .rounded))
                    .foregroundStyle(comboGradient)
                    .shadow(color: glowColor.opacity(0.8), radius: 12)
                    .shadow(color: glowColor.opacity(0.4), radius: 24)
                    .phaseAnimator(feverActive ? [false, true] : [false], trigger: feverActive) { content, phase in
                        content
                            .scaleEffect(phase ? 1.12 : 1.0)
                            .brightness(phase ? 0.15 : 0)
                    } animation: { _ in
                        .bouncy(duration: 0.6, extraBounce: 0.3)
                    }

                // Multiplier text
                Text(multiplierText)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))

                // Fever trigger hint
                if combo == 2 && !feverActive {
                    Text("one more for 🔥 FEVER!")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(.yellow.opacity(0.6))
                }
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(y: offsetY)
            .allowsHitTesting(false)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(combo) times combo, \(multiplierText)")
            .accessibilityAddTraits(.updatesFrequently)
            .onAppear { animateIn() }
            .onChange(of: combo) { _, _ in animateIn() }
        }
    }

    // MARK: - Computed Properties

    private var comboFontSize: CGFloat {
        switch combo {
        case 2: 28
        case 3: 34
        case 4: 40
        case 5...: 48
        default: 28
        }
    }

    private var comboGradient: some ShapeStyle {
        if feverActive {
            return AnyShapeStyle(
                LinearGradient(colors: [.yellow, .orange, .red], startPoint: .top, endPoint: .bottom)
            )
        }
        return switch combo {
        case 2: AnyShapeStyle(Color.white)
        case 3: AnyShapeStyle(
            LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing)
        )
        case 4: AnyShapeStyle(
            LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing)
        )
        default: AnyShapeStyle(
            LinearGradient(colors: [.yellow, .orange, .red], startPoint: .leading, endPoint: .trailing)
        )
        }
    }

    private var glowColor: Color {
        if feverActive { return .orange }
        return switch combo {
        case 2: .white
        case 3: .cyan
        case 4: .purple
        default: .orange
        }
    }

    private var multiplierText: String {
        let mult = max(1, combo) * (feverActive ? 2 : 1)
        return "×\(mult) points"
    }

    // MARK: - Animation

    private func animateIn() {
        scale = 0.3
        opacity = 0
        offsetY = 0

        withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
            scale = 1.0
            opacity = 1.0
        }

        withAnimation(.easeOut(duration: 1.5).delay(0.5)) {
            offsetY = -30
            opacity = 0
        }
    }
}

/// Floating "+N" score text that rises from merge position and fades
struct FloatingScoreText: View {
    let score: Int
    let position: CGPoint

    @State private var opacity: Double = 1
    @State private var offsetY: CGFloat = 0
    @State private var scale: CGFloat = 0.5

    var body: some View {
        Text("+\(score)")
            .font(.system(size: 20, weight: .heavy, design: .rounded))
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.5), radius: 2)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(y: offsetY)
            .position(position)
            .allowsHitTesting(false)
            .onAppear {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    scale = 1.2
                }
                withAnimation(.easeOut(duration: 1.0)) {
                    offsetY = -60
                }
                withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
                    opacity = 0
                    scale = 0.8
                }
            }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 40) {
            ComboOverlay(combo: 3, feverActive: false)
            ComboOverlay(combo: 5, feverActive: true)
        }
    }
}
