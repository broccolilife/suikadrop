// ParticleAnimations.swift — SuikaDrop particle & physics animation system
// Pixel+Muse — juice, particles, screen shake for fruit merging

import SwiftUI

// MARK: - Merge Particle System

struct MergeParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var scale: CGFloat
    var opacity: Double
    var color: Color
    var lifetime: TimeInterval
}

@Observable
class ParticleEmitter {
    var particles: [MergeParticle] = []
    
    /// Emit burst of particles at merge point
    func emitMergeBurst(at point: CGPoint, fruitTier: Int, count: Int = 12) {
        let color = SDColor.forFruitTier(fruitTier)
        let newParticles = (0..<count).map { _ in
            let angle = Double.random(in: 0...(2 * .pi))
            let speed = Double.random(in: 80...200)
            return MergeParticle(
                position: point,
                velocity: CGVector(dx: cos(angle) * speed, dy: sin(angle) * speed),
                scale: CGFloat.random(in: 0.3...1.0),
                opacity: 1.0,
                color: color,
                lifetime: Double.random(in: 0.4...0.8)
            )
        }
        particles.append(contentsOf: newParticles)
    }
    
    /// Emit sparkle trail for combo chain
    func emitComboSparkle(at point: CGPoint) {
        let sparkles = (0..<6).map { _ in
            MergeParticle(
                position: point,
                velocity: CGVector(
                    dx: Double.random(in: -40...40),
                    dy: Double.random(in: -120...(-60))
                ),
                scale: CGFloat.random(in: 0.2...0.5),
                opacity: 1.0,
                color: SDColor.comboGlow,
                lifetime: Double.random(in: 0.3...0.6)
            )
        }
        particles.append(contentsOf: sparkles)
    }
    
    func pruneExpired() {
        particles.removeAll { $0.opacity <= 0 }
    }
}

// MARK: - Screen Shake

struct ScreenShake: GeometryEffect {
    var intensity: CGFloat
    var animatableData: CGFloat
    
    init(intensity: CGFloat = 8, progress: CGFloat) {
        self.intensity = intensity
        self.animatableData = progress
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let dx = intensity * sin(animatableData * .pi * 6) * (1 - animatableData)
        let dy = intensity * cos(animatableData * .pi * 4) * (1 - animatableData)
        return ProjectionTransform(CGAffineTransform(translationX: dx, y: dy))
    }
}

// MARK: - Juice Animations

extension View {
    /// Scale punch — quick scale up then back, for merge feedback
    func scalePunch(trigger: Bool, intensity: CGFloat = 1.2) -> some View {
        self
            .scaleEffect(trigger ? intensity : 1.0)
            .animation(SpringPreset.mergePop, value: trigger)
    }
    
    /// Wobble idle animation for waiting fruits
    func fruitWobble(isActive: Bool, amount: Angle = .degrees(3)) -> some View {
        self
            .rotationEffect(isActive ? amount : .zero)
            .animation(
                isActive
                    ? SpringPreset.wobble.repeatForever(autoreverses: true)
                    : .default,
                value: isActive
            )
    }
    
    /// Floating score popup that rises and fades
    func scorePopup(isVisible: Bool, offset: CGFloat = -40) -> some View {
        self
            .offset(y: isVisible ? offset : 0)
            .opacity(isVisible ? 0 : 1)
            .scaleEffect(isVisible ? 1.3 : 0.8)
            .animation(SpringPreset.scoreFloat, value: isVisible)
    }
    
    /// Landing squash & stretch
    func landingSquash(isLanded: Bool) -> some View {
        self
            .scaleEffect(
                x: isLanded ? 1.15 : 1.0,
                y: isLanded ? 0.85 : 1.0
            )
            .animation(SpringPreset.fruitDrop, value: isLanded)
    }
}

// MARK: - Reduced Motion Aware

extension View {
    /// Applies animation only when reduced motion is off
    func motionSafe<V: Equatable>(_ animation: Animation, value: V) -> some View {
        self.animation(
            UIAccessibility.isReduceMotionEnabled ? nil : animation,
            value: value
        )
    }
}
