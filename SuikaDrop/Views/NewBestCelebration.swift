// NewBestCelebration.swift — Confetti burst for new high scores
// Uses Canvas + TimelineView for performant particle rendering

import SwiftUI

/// Full-screen confetti celebration overlay triggered on new best score.
/// Renders particles via Canvas for 60fps performance.
struct NewBestCelebration: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var elapsed: TimeInterval = 0
    @State private var startDate = Date.now
    
    private let duration: TimeInterval = 3.0
    private let particleCount = 80
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let now = timeline.date.timeIntervalSince(startDate)
            
            Canvas { context, size in
                for particle in particles {
                    let age = now - particle.birthTime
                    guard age >= 0, age < duration else { continue }
                    
                    let progress = age / duration
                    let x = particle.startX * size.width + particle.drift * CGFloat(age)
                    let y = particle.startY * size.height
                        + particle.velocity * CGFloat(age)
                        + 400 * CGFloat(age * age) // gravity
                    let opacity = 1.0 - max(0, progress - 0.6) / 0.4
                    let rotation = Angle.degrees(particle.spin * age)
                    
                    context.opacity = opacity
                    context.translateBy(x: x, y: y)
                    context.rotate(by: rotation)
                    
                    let rect = CGRect(
                        x: -particle.size / 2,
                        y: -particle.size / 2,
                        width: particle.size,
                        height: particle.size
                    )
                    context.fill(
                        RoundedRectangle(cornerRadius: 2).path(in: rect),
                        with: .color(particle.color)
                    )
                    
                    // Reset transforms
                    context.rotate(by: -rotation)
                    context.translateBy(x: -x, y: -y)
                    context.opacity = 1
                }
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
        .onAppear { spawnParticles() }
        .accessibilityHidden(true)
    }
    
    private func spawnParticles() {
        startDate = .now
        particles = (0..<particleCount).map { i in
            let stagger = Double(i) / Double(particleCount) * 0.4
            return ConfettiParticle(
                birthTime: stagger,
                startX: CGFloat.random(in: 0.1...0.9),
                startY: CGFloat.random(in: -0.1...0.15),
                velocity: CGFloat.random(in: 60...180),
                drift: CGFloat.random(in: -40...40),
                spin: Double.random(in: -360...360),
                size: CGFloat.random(in: 4...10),
                color: ConfettiParticle.celebrationColors.randomElement()!
            )
        }
    }
}

private struct ConfettiParticle: Identifiable {
    let id = UUID()
    let birthTime: TimeInterval
    let startX: CGFloat
    let startY: CGFloat
    let velocity: CGFloat
    let drift: CGFloat
    let spin: Double
    let size: CGFloat
    let color: Color
    
    static let celebrationColors: [Color] = [
        .yellow, .orange, .red, .pink, .purple,
        .blue, .cyan, .mint, .green
    ]
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        NewBestCelebration()
        Text("🎉 New Best!")
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
    }
}
