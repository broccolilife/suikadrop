// PhaseAnimations.swift — Declarative multi-phase animations
// From Pixel knowledge (2/23): PhaseAnimator eliminates Timer-based loops
// iOS 17+ — bouncy springs, attention-grabbing effects for game UI

import SwiftUI

// MARK: - Score Pop Animation

struct ScorePopModifier: ViewModifier {
    let trigger: Bool
    
    func body(content: Content) -> some View {
        content
            .phaseAnimator([false, true], trigger: trigger) { view, phase in
                view
                    .scaleEffect(phase ? SuikaTheme.scorePopScale : 1.0)
                    .opacity(phase ? 1.0 : 0.7)
            } animation: { phase in
                phase ? .bouncy(duration: 0.3, extraBounce: 0.4) : .easeOut(duration: 0.2)
            }
    }
}

// MARK: - Merge Celebration Pulse

struct MergePulseModifier: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .phaseAnimator([0.0, 1.0], trigger: isActive) { view, phase in
                view
                    .scaleEffect(1.0 + phase * 0.15)
                    .brightness(phase * 0.2)
            } animation: { _ in
                .bouncy(duration: 0.5, extraBounce: 0.6)
            }
    }
}

// MARK: - Game Over Transition

extension AnyTransition {
    static var gameOver: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 1.5).combined(with: .opacity),
            removal: .scale(scale: 0.5).combined(with: .opacity)
        )
    }
    
    static var fruitDrop: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .top).combined(with: .scale(scale: 0.3)),
            removal: .scale(scale: 0).combined(with: .opacity)
        )
    }
}

// MARK: - Attention Pulse (for tutorial/new feature indicators)

struct AttentionPulseModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .phaseAnimator([false, true]) { view, phase in
                view
                    .scaleEffect(phase ? 1.1 : 1.0)
                    .opacity(phase ? 1.0 : 0.8)
            } animation: { phase in
                .easeInOut(duration: phase ? 0.8 : 0.6)
            }
    }
}

// MARK: - View Extensions

extension View {
    func scorePopEffect(trigger: Bool) -> some View {
        modifier(ScorePopModifier(trigger: trigger))
    }
    
    func mergePulse(isActive: Bool) -> some View {
        modifier(MergePulseModifier(isActive: isActive))
    }
    
    func attentionPulse() -> some View {
        modifier(AttentionPulseModifier())
    }
}
