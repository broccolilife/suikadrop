// HapticManager.swift — Centralized haptic feedback for game events
// SuikaDrop

import SwiftUI
import CoreHaptics

/// Provides consistent haptic feedback across the game.
/// Respects system haptic settings and gracefully degrades on unsupported devices.
@Observable
final class HapticManager {
    
    // MARK: - Singleton
    
    static let shared = HapticManager()
    
    // MARK: - State
    
    private var engine: CHHapticEngine?
    private var supportsHaptics: Bool
    
    private init() {
        supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        prepareEngine()
    }
    
    // MARK: - Game Events
    
    /// Light tap when a fruit is dropped
    func fruitDropped() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred(intensity: 0.5)
    }
    
    /// Satisfying merge feedback — intensity scales with fruit tier
    func fruitMerged(tier: Int) {
        let intensity = min(1.0, 0.3 + Double(tier) * 0.1)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred(intensity: intensity)
    }
    
    /// Multi-hit combo — rapid successive taps
    func comboTriggered(count: Int) {
        guard supportsHaptics, let engine else {
            // Fallback to simple notification
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            return
        }
        
        do {
            let events = (0..<min(count, 5)).map { i in
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(0.4 + Double(i) * 0.12)),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(0.3 + Double(i) * 0.1))
                    ],
                    relativeTime: Double(i) * 0.08
                )
            }
            
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            // Silent fallback — haptics are non-critical
        }
    }
    
    /// Game over — heavy thud
    func gameOver() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    /// New high score celebration
    func newHighScore() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// Selection tick for menus
    func selectionTick() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    // MARK: - Engine
    
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
}
