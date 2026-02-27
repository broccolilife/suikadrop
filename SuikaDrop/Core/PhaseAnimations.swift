// PhaseAnimations.swift — iOS 17+ PhaseAnimator patterns for SuikaDrop
// Pixel+Muse — modern cyclic animations for game elements

import SwiftUI

// MARK: - Phase Animator Presets

/// Pulsing attention effect for new fruit or power-ups
@available(iOS 17.0, *)
struct PulsePhase: View {
    let systemImage: String
    
    var body: some View {
        Image(systemName: systemImage)
            .phaseAnimator([false, true]) { icon, pulse in
                icon
                    .scaleEffect(pulse ? 1.15 : 1.0)
                    .opacity(pulse ? 0.8 : 1.0)
            } animation: { pulse in
                pulse ? .bouncy(duration: 0.8, extraBounce: 0.4) : .easeOut(duration: 0.6)
            }
    }
}

/// Wobble idle animation for waiting fruits
@available(iOS 17.0, *)
struct WobblePhase: ViewModifier {
    func body(content: Content) -> some View {
        content
            .phaseAnimator([0.0, -6.0, 6.0, 0.0]) { view, angle in
                view.rotationEffect(.degrees(angle), anchor: .bottom)
            } animation: { _ in
                .bouncy(duration: 1.2, extraBounce: 0.3)
            }
    }
}

/// Score pop — number flies up and fades
@available(iOS 17.0, *)
struct ScorePopPhase: ViewModifier {
    enum Phase: CaseIterable {
        case initial, pop, fade
    }
    
    func body(content: Content) -> some View {
        content
            .phaseAnimator(Phase.allCases) { view, phase in
                view
                    .scaleEffect(phase == .pop ? 1.4 : 1.0)
                    .offset(y: phase == .fade ? -30 : 0)
                    .opacity(phase == .fade ? 0 : 1)
            } animation: { phase in
                switch phase {
                case .initial: .bouncy(duration: 0.3, extraBounce: 0.5)
                case .pop: .easeOut(duration: 0.4)
                case .fade: .easeIn(duration: 0.3)
                }
            }
    }
}

// MARK: - View Extensions

@available(iOS 17.0, *)
extension View {
    /// Apply wobble idle animation
    func wobblePhase() -> some View {
        modifier(WobblePhase())
    }
    
    /// Apply score pop phase animation
    func scorePopPhase() -> some View {
        modifier(ScorePopPhase())
    }
}
