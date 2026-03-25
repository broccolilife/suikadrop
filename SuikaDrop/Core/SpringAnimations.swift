// SpringAnimations.swift — Spring animation presets for SuikaDrop
// Pixel+Muse — physics-based motion for game interactions

import SwiftUI

// MARK: - Spring Presets

enum SpringPreset {
    
    /// Fruit drop — heavy, satisfying landing
    static let fruitDrop: Animation = .spring(response: 0.45, dampingFraction: 0.6, blendDuration: 0.1)
    
    /// Merge celebration — bouncy pop when fruits combine
    static let mergePop: Animation = .spring(response: 0.35, dampingFraction: 0.5, blendDuration: 0)
    
    /// Score float — gentle rise for score popups
    static let scoreFloat: Animation = .spring(response: 0.6, dampingFraction: 0.8)
    
    /// Button press — snappy tactile feedback
    static let buttonPress: Animation = .spring(response: 0.25, dampingFraction: 0.65)
    
    /// Menu slide — smooth panel transitions
    static let menuSlide: Animation = .spring(response: 0.5, dampingFraction: 0.85)
    
    /// Wobble — playful idle animation for fruits
    static let wobble: Animation = .spring(response: 0.3, dampingFraction: 0.35)
    
    /// Gentle — subtle UI state changes
    static let gentle: Animation = .spring(response: 0.55, dampingFraction: 0.9)
    
    /// Snappy — instant-feel interactions
    static let snappy: Animation = .spring(response: 0.2, dampingFraction: 0.7)
    
    /// Combo cascade — escalating bounce for consecutive merges
    static let comboCascade: Animation = .spring(response: 0.3, dampingFraction: 0.45, blendDuration: 0.05)
    
    /// Container settle — physics-based settling after fruit lands
    static let containerSettle: Animation = .spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.2)
    
    /// Game over — dramatic slow reveal
    static let gameOver: Animation = .spring(response: 0.8, dampingFraction: 0.6)
}

// MARK: - Animated Modifiers

struct BounceOnAppear: ViewModifier {
    @State private var appeared = false
    let delay: Double
    
    init(delay: Double = 0) {
        self.delay = delay
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(appeared ? 1 : 0.3)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(SpringPreset.mergePop.delay(delay)) {
                    appeared = true
                }
            }
    }
}

struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(SpringPreset.buttonPress, value: configuration.isPressed)
    }
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 6
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(
            translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0
        ))
    }
}

// MARK: - View Extensions

extension View {
    /// Bounce in on appear with optional stagger delay
    func bounceOnAppear(delay: Double = 0) -> some View {
        modifier(BounceOnAppear(delay: delay))
    }
    
    /// Apply pressable button style
    func pressable() -> some View {
        buttonStyle(PressableStyle())
    }
    
    /// Animate with a named spring preset
    func withSpring(_ preset: Animation, value: some Equatable) -> some View {
        animation(preset, value: value)
    }
    
    /// Staggered scale-in for lists of items (e.g., fruit selection, leaderboard)
    func staggerIn(index: Int, baseDelay: Double = 0.04) -> some View {
        modifier(BounceOnAppear(delay: Double(index) * baseDelay))
    }
}

// MARK: - Combo Pulse (PhaseAnimator pattern)

struct ComboPulse: ViewModifier {
    let comboCount: Int
    @State private var pulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(pulsing ? 1.0 + CGFloat(min(comboCount, 5)) * 0.05 : 1.0)
            .animation(SpringPreset.comboCascade, value: pulsing)
            .onChange(of: comboCount) { _, _ in
                pulsing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { pulsing = false }
            }
    }
}

extension View {
    /// Pulse effect that intensifies with combo count
    func comboPulse(count: Int) -> some View {
        modifier(ComboPulse(comboCount: count))
    }
}
