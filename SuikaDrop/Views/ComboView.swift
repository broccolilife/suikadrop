// ComboView.swift — Celebration overlay for fruit merge combos
// Confetti burst + score popup with phaseAnimator for looping sparkle

import SwiftUI

/// Overlay shown when a player achieves a multi-merge combo.
/// Confetti particles burst outward, score floats up and fades.
struct ComboView: View {
    let comboCount: Int
    let points: Int
    let position: CGPoint  // screen position of the merge

    @State private var particles: [ConfettiParticle] = []
    @State private var scoreOpacity: Double = 1
    @State private var scoreOffset: CGFloat = 0
    @State private var scoreScale: CGFloat = 0.3
    @State private var showContent = false

    private let fruitEmojis = ["🍎", "🍊", "🍋", "🍇", "🍉", "🍑", "🫐", "🍓"]

    var body: some View {
        ZStack {
            // Confetti particles
            ForEach(particles) { particle in
                Text(particle.emoji)
                    .font(.system(size: particle.size))
                    .position(particle.position)
                    .opacity(particle.opacity)
                    .rotationEffect(.degrees(particle.rotation))
            }

            // Combo text
            if showContent {
                VStack(spacing: 4) {
                    // Combo multiplier
                    Text("\(comboCount)x COMBO!")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: comboGradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .phaseAnimator([false, true]) { content, phase in
                            content
                                .scaleEffect(phase ? 1.05 : 1.0)
                                .brightness(phase ? 0.15 : 0)
                        } animation: { _ in
                            .bouncy(duration: 0.6, extraBounce: 0.3)
                        }

                    // Points
                    Text("+\(points)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .position(position)
                .offset(y: scoreOffset)
                .opacity(scoreOpacity)
                .scaleEffect(scoreScale)
            }
        }
        .allowsHitTesting(false)
        .onAppear { startAnimation() }
    }

    // MARK: - Colors

    private var comboGradientColors: [Color] {
        switch comboCount {
        case 2: return [.yellow, .orange]
        case 3: return [.orange, .red]
        case 4: return [.red, .purple]
        default: return [.purple, .pink, .yellow]  // 5+ rainbow
        }
    }

    // MARK: - Animation

    private func startAnimation() {
        // Generate confetti
        particles = (0..<(comboCount * 6)).map { _ in
            ConfettiParticle(
                emoji: fruitEmojis.randomElement()!,
                position: position,
                size: CGFloat.random(in: 14...24),
                rotation: 0,
                opacity: 1
            )
        }

        // Show score
        showContent = true
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            scoreScale = 1.0
        }

        // Burst particles outward
        withAnimation(.easeOut(duration: 0.6)) {
            for i in particles.indices {
                let angle = Double.random(in: 0...(2 * .pi))
                let distance = CGFloat.random(in: 60...160)
                particles[i].position = CGPoint(
                    x: position.x + distance * CGFloat(cos(angle)),
                    y: position.y + distance * CGFloat(sin(angle))
                )
                particles[i].rotation = Double.random(in: -180...180)
            }
        }

        // Fade particles
        withAnimation(.easeIn(duration: 0.4).delay(0.5)) {
            for i in particles.indices {
                particles[i].opacity = 0
            }
        }

        // Float score upward and fade
        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            scoreOffset = -60
        }
        withAnimation(.easeIn(duration: 0.4).delay(0.8)) {
            scoreOpacity = 0
        }
    }
}

// MARK: - Confetti Particle

struct ConfettiParticle: Identifiable {
    let id = UUID()
    let emoji: String
    var position: CGPoint
    let size: CGFloat
    var rotation: Double
    var opacity: Double
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ComboView(comboCount: 3, points: 450, position: CGPoint(x: 200, y: 400))
    }
}
