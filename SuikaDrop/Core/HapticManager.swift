// HapticManager.swift — Centralized haptic feedback for SuikaDrop
// Maps game events to appropriate haptic patterns

import SwiftUI
import CoreHaptics

/// Centralized haptic feedback manager for game events.
/// Uses UIImpactFeedbackGenerator for simple taps and CoreHaptics for complex patterns.
@Observable
final class HapticManager {
    static let shared = HapticManager()

    private var engine: CHHapticEngine?
    private var isEnabled = true

    private init() {
        prepareEngine()
    }

    // MARK: - Simple Haptics

    /// Light tap for UI interactions (button presses, selections)
    func tap(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        guard isEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    /// Selection feedback for scrolling/picking
    func selection() {
        guard isEnabled else { return }
        UISelectionFeedbackGenerator().selectionChanged()
    }

    /// Notification feedback for game events
    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }

    // MARK: - Game-Specific Haptics

    /// Fruit drop — medium impact
    func fruitDrop() {
        tap(.medium)
    }

    /// Fruit merge — satisfying double-tap with increasing intensity
    func fruitMerge(comboLevel: Int) {
        let intensity = min(1.0, 0.4 + Double(comboLevel) * 0.15)
        guard isEnabled, CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            tap(.heavy)
            return
        }
        playPattern(intensity: Float(intensity), sharpness: 0.6, duration: 0.15)
    }

    /// Combo achieved — escalating buzz
    func combo(level: Int) {
        switch level {
        case 2: tap(.medium)
        case 3: tap(.heavy)
        case 4...: notify(.success)
        default: break
        }
    }

    /// Fever mode activated — strong rumble
    func feverActivated() {
        notify(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [self] in
            tap(.heavy)
        }
    }

    /// Game over — error buzz
    func gameOver() {
        notify(.error)
    }

    /// New high score celebration
    func newHighScore() {
        notify(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            notify(.success)
        }
    }

    // MARK: - Settings

    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }

    // MARK: - Core Haptics

    private func prepareEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            engine?.resetHandler = { [weak self] in
                try? self?.engine?.start()
            }
            try engine?.start()
        } catch {
            engine = nil
        }
    }

    private func playPattern(intensity: Float, sharpness: Float, duration: TimeInterval) {
        guard let engine else { return }
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
            ],
            relativeTime: 0,
            duration: duration
        )
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            // Silently fail — haptics are non-critical
        }
    }
}
