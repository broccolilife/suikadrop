import SwiftUI

// MARK: - Spring Animation Presets for SuikaDrop

/// Reusable spring configurations for game interactions.
enum SpringPreset {
    case snappy, bouncy, gentle, fruitDrop, merge, scorePop

    var animation: Animation {
        switch self {
        case .snappy:    return .spring(response: 0.2, dampingFraction: 0.7)
        case .bouncy:    return .bouncy(duration: 0.5, extraBounce: 0.3)
        case .gentle:    return .spring(response: 0.55, dampingFraction: 0.9)
        case .fruitDrop: return .spring(response: 0.35, dampingFraction: 0.6)
        case .merge:     return .spring(response: 0.25, dampingFraction: 0.5, blendDuration: 0.1)
        case .scorePop:  return .spring(response: 0.3, dampingFraction: 0.4)
        }
    }
}

// MARK: - Spring View Modifiers

extension View {
    /// Applies a spring scale effect triggered by a boolean.
    func springScale(isActive: Bool, preset: SpringPreset = .bouncy, activeScale: CGFloat = 1.15) -> some View {
        self
            .scaleEffect(isActive ? activeScale : 1.0)
            .animation(preset.animation, value: isActive)
    }

    /// Fruit merge pop animation — scales up then back.
    func mergePopEffect(trigger: Bool) -> some View {
        self
            .scaleEffect(trigger ? 1.4 : 1.0)
            .opacity(trigger ? 0.0 : 1.0)
            .animation(SpringPreset.merge.animation, value: trigger)
    }

    /// Score increment pulse — brief scale bump.
    func scorePulse(trigger: Int) -> some View {
        self
            .scaleEffect(1.0)
            .animation(SpringPreset.scorePop.animation, value: trigger)
    }

    /// Fruit drop entrance — slides in from top with spring.
    func fruitDropEntrance(isVisible: Bool) -> some View {
        self
            .offset(y: isVisible ? 0 : -80)
            .opacity(isVisible ? 1.0 : 0.0)
            .animation(SpringPreset.fruitDrop.animation, value: isVisible)
    }

    /// Gentle breathing/idle animation for UI elements.
    func breathingEffect(isActive: Bool) -> some View {
        self
            .scaleEffect(isActive ? 1.03 : 1.0)
            .animation(
                isActive
                    ? .easeInOut(duration: 2.0).repeatForever(autoreverses: true)
                    : .default,
                value: isActive
            )
    }

    /// Combo chain shake — horizontal wiggle for combo feedback.
    func comboShake(trigger: Int) -> some View {
        let amount: CGFloat = trigger > 0 ? 6 : 0
        return self
            .offset(x: amount)
            .animation(SpringPreset.snappy.animation, value: trigger)
    }
}

// MARK: - Spring Transition Helpers

extension AnyTransition {
    /// Pop-in from small scale with spring.
    static var springPopIn: AnyTransition {
        .scale(scale: 0.5)
        .combined(with: .opacity)
    }

    /// Slide up with spring bounce.
    static var springSlideUp: AnyTransition {
        .move(edge: .bottom)
        .combined(with: .opacity)
    }

    /// Game over curtain — fade from top.
    static var curtainDrop: AnyTransition {
        .move(edge: .top)
        .combined(with: .opacity)
    }
}
