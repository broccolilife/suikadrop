// HapticEngine.swift — Structured haptic feedback patterns for SuikaDrop
// Pixel+Muse — tactile feedback aligned with spring animations

import SwiftUI
import CoreHaptics

enum HapticEngine {

    // MARK: - Simple Patterns

    static func fruitDrop() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    static func fruitMerge() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 0.8)
    }

    static func comboHit(_ count: Int) {
        let intensity = min(1.0, 0.5 + Double(count) * 0.1)
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: intensity)
    }

    static func gameOver() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    static func newHighScore() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    // MARK: - CoreHaptics Pattern (merge celebration)

    static func mergeCelebration() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            let engine = try CHHapticEngine()
            try engine.start()

            let events: [CHHapticEvent] = [
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.6)
                    ],
                    relativeTime: 0
                ),
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.9)
                    ],
                    relativeTime: 0.1
                ),
                CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
                    ],
                    relativeTime: 0.15,
                    duration: 0.2
                )
            ]

            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            // Fallback to simple haptic
            fruitMerge()
        }
    }
}
