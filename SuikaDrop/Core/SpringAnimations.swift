// SpringAnimations.swift — Physics-based motion for SuikaDrop
// Pixel+Muse — spring presets, transitions, haptic-coupled animations

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

    /// Chain reaction — cascading merge effects
    static let chainReaction: Animation = .spring(response: 0.3, dampingFraction: 0.55, blendDuration: 0.05)

    /// Victory — end-screen celebration burst
    static let victory: Animation = .spring(response: 0.7, dampingFraction: 0.4)
}

// MARK: - Transition Presets

enum TransitionPreset {
    /// Card-style pop in
    static let cardPresent: AnyTransition = .asymmetric(
        insertion: .scale(scale: 0.85).combined(with: .opacity),
        removal: .scale(scale: 0.95).combined(with: .opacity)
    )

    /// Slide up from bottom edge
    static let slideUp: AnyTransition = .move(edge: .bottom).combined(with: .opacity)

    /// Score popup — scale up then fade out
    static let scorePopup: AnyTransition = .asymmetric(
        insertion: .scale(scale: 0.5).combined(with: .opacity),
        removal: .opacity
    )

    /// Fruit appear — bounce in from nothing
    static let fruitAppear: AnyTransition = .scale(scale: 0.1).combined(with: .opacity)

    /// Blur dissolve
    static let blur: AnyTransition = .opacity
}

// MARK: - Haptic-Coupled Animations

struct HapticSpring {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium,
                       animation: Animation = SpringPreset.buttonPress,
                       _ body: @escaping () -> Void) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
        withAnimation(animation, body)
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType,
                             animation: Animation = SpringPreset.mergePop,
                             _ body: @escaping () -> Void) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
        withAnimation(animation, body)
    }

    static func selection(animation: Animation = SpringPreset.snappy,
                          _ body: @escaping () -> Void) {
        UISelectionFeedbackGenerator().selectionChanged()
        withAnimation(animation, body)
    }
}

// MARK: - Animated Modifiers

struct BounceOnAppear: ViewModifier {
    @State private var appeared = false
    let delay: Double
    let spring: Animation

    init(delay: Double = 0, spring: Animation = SpringPreset.mergePop) {
        self.delay = delay
        self.spring = spring
    }

    func body(content: Content) -> some View {
        content
            .scaleEffect(appeared ? 1 : 0.3)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(spring.delay(delay)) {
                    appeared = true
                }
            }
    }
}

struct StaggeredAppear: ViewModifier {
    let index: Int
    let baseDelay: Double
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .offset(y: appeared ? 0 : 20)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(SpringPreset.gentle.delay(baseDelay + Double(index) * 0.06)) {
                    appeared = true
                }
            }
    }
}

struct PressableStyle: ButtonStyle {
    let scale: CGFloat

    init(scale: CGFloat = 0.92) {
        self.scale = scale
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
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

struct PulseEffect: ViewModifier {
    @State private var pulsing = false
    let scale: CGFloat
    let duration: TimeInterval

    func body(content: Content) -> some View {
        content
            .scaleEffect(pulsing ? scale : 1.0)
            .animation(.easeInOut(duration: duration).repeatForever(autoreverses: true), value: pulsing)
            .onAppear { pulsing = true }
    }
}

// MARK: - View Extensions

extension View {
    func bounceOnAppear(delay: Double = 0) -> some View {
        modifier(BounceOnAppear(delay: delay))
    }

    func staggeredAppear(index: Int, baseDelay: Double = 0) -> some View {
        modifier(StaggeredAppear(index: index, baseDelay: baseDelay))
    }

    func pressable(scale: CGFloat = 0.92) -> some View {
        buttonStyle(PressableStyle(scale: scale))
    }

    func pulse(scale: CGFloat = 1.05, duration: TimeInterval = 0.8) -> some View {
        modifier(PulseEffect(scale: scale, duration: duration))
    }

    func withSpring(_ preset: Animation, value: some Equatable) -> some View {
        animation(preset, value: value)
    }

    /// Animate with spring and trigger haptic
    func springWithHaptic(_ preset: Animation = SpringPreset.buttonPress, value: some Equatable) -> some View {
        animation(preset, value: value)
            .sensoryFeedback(.impact(flexibility: .rigid), trigger: value)
    }
}
