// HapticEngine.swift — Game-tuned haptic feedback system
// CoreHaptics patterns for drops, merges, combos, and game events

import SwiftUI
import CoreHaptics

/// Centralized haptic feedback for SuikaDrop game events.
/// Uses CoreHaptics for custom patterns and UIKit generators as fallback.
@MainActor
final class HapticEngine {
    static let shared = HapticEngine()

    private var engine: CHHapticEngine?
    private var supportsHaptics: Bool

    private init() {
        supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        prepareEngine()
    }

    // MARK: - Engine Setup

    private func prepareEngine() {
        guard supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            engine?.resetHandler = { [weak self] in
                try? self?.engine?.start()
            }
            engine?.stoppedHandler = { _ in }
            try engine?.start()
        } catch {
            supportsHaptics = false
        }
    }

    // MARK: - Game Events

    /// Light tap when a fruit is dropped.
    func fruitDrop() {
        playPattern(events: [
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3),
                ],
                relativeTime: 0
            )
        ])
    }

    /// Satisfying thud when a fruit lands/collides.
    func fruitLand(size: FruitSize) {
        let intensity = Float(size.rawValue) / Float(FruitSize.allCases.count)
        playPattern(events: [
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3 + intensity * 0.5),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.6),
                ],
                relativeTime: 0
            )
        ])
    }

    /// Pop + buzz when two fruits merge.
    func fruitMerge() {
        playPattern(events: [
            // Initial pop
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8),
                ],
                relativeTime: 0
            ),
            // Satisfying rumble
            CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2),
                ],
                relativeTime: 0.05,
                duration: 0.12
            ),
        ])
    }

    /// Escalating buzz pattern for combos. Intensity scales with combo count.
    func combo(count: Int) {
        let burstCount = min(count, 5)
        var events: [CHHapticEvent] = []
        for i in 0..<burstCount {
            let time = Double(i) * 0.08
            let intensity = Float(0.5) + Float(i) * 0.1
            events.append(CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: min(intensity, 1.0)),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.6 + Float(i) * 0.08),
                ],
                relativeTime: time
            ))
        }
        playPattern(events: events)
    }

    /// Heavy double-tap for game over.
    func gameOver() {
        playPattern(events: [
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5),
                ],
                relativeTime: 0
            ),
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3),
                ],
                relativeTime: 0.15
            ),
        ])
    }

    /// Celebratory pattern for new high score.
    func newHighScore() {
        var events: [CHHapticEvent] = []
        for i in 0..<6 {
            events.append(CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6 + Float(i) * 0.07),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4 + Float(i) * 0.1),
                ],
                relativeTime: Double(i) * 0.06
            ))
        }
        playPattern(events: events)
    }

    // MARK: - Player

    private func playPattern(events: [CHHapticEvent]) {
        guard supportsHaptics, let engine else {
            // Fallback to UIKit
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            return
        }
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
}

// MARK: - Fruit Size (for haptic intensity scaling)

enum FruitSize: Int, CaseIterable {
    case cherry = 1
    case strawberry = 2
    case grape = 3
    case orange = 4
    case apple = 5
    case pear = 6
    case peach = 7
    case pineapple = 8
    case melon = 9
    case watermelon = 10
}
