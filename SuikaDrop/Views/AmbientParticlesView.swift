// AmbientParticlesView.swift — Floating fruit emoji particles for menu/idle screens
// Lightweight ambient animation using TimelineView for smooth 60fps rendering

import SwiftUI

/// Floating fruit emoji particles that drift across the screen.
/// Use as a background layer on menu, pause, or game-over screens.
struct AmbientParticlesView: View {
    let particleCount: Int
    let emojis: [String]

    @State private var particles: [Particle] = []

    init(count: Int = 12, emojis: [String] = ["🍉", "🍊", "🍇", "🍓", "🍑", "🍒", "🫐", "🍋"]) {
        self.particleCount = count
        self.emojis = emojis
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for particle in particles {
                    let x = particle.x * size.width
                    let progress = (time - particle.startTime).truncatingRemainder(dividingBy: particle.duration) / particle.duration
                    let y = size.height * (1.0 + particle.size / size.height) - progress * (size.height + particle.size * 2)
                    let wobble = sin(time * particle.wobbleSpeed + particle.wobbleOffset) * particle.wobbleAmount

                    var resolvedText = context.resolve(
                        Text(particle.emoji)
                            .font(.system(size: particle.size))
                    )
                    let opacity = min(1, min(progress * 4, (1 - progress) * 4)) * particle.opacity
                    resolvedText.opacity = opacity

                    let point = CGPoint(x: x + wobble, y: y)
                    context.draw(resolvedText, at: point)
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear { generateParticles() }
    }

    private func generateParticles() {
        let now = Date.timeIntervalSinceReferenceDate
        particles = (0..<particleCount).map { _ in
            Particle(
                emoji: emojis.randomElement() ?? "🍉",
                x: CGFloat.random(in: 0.05...0.95),
                size: CGFloat.random(in: 16...32),
                opacity: Double.random(in: 0.15...0.4),
                duration: Double.random(in: 8...16),
                startTime: now - Double.random(in: 0...12),
                wobbleSpeed: Double.random(in: 0.5...1.5),
                wobbleAmount: CGFloat.random(in: 8...20),
                wobbleOffset: Double.random(in: 0...(.pi * 2))
            )
        }
    }
}

private struct Particle {
    let emoji: String
    let x: CGFloat
    let size: CGFloat
    let opacity: Double
    let duration: Double
    let startTime: Double
    let wobbleSpeed: Double
    let wobbleAmount: CGFloat
    let wobbleOffset: Double
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AmbientParticlesView()
    }
}
