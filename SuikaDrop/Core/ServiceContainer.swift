// ServiceContainer.swift — Dependency Injection via @Observable
// From Pixel knowledge (3/30): ServiceContainer DI pattern (CodeEdit-inspired)
// Inject via @Environment for testability, lazy init for performance

import SwiftUI

@Observable
final class ServiceContainer {
    static let shared = ServiceContainer()

    // MARK: - Services (lazy-loaded)

    lazy var hapticService: HapticServiceProtocol = HapticService()
    lazy var scoreService: ScoreServiceProtocol = ScoreService()
    lazy var settingsService: SettingsServiceProtocol = SettingsService()

    private init() {}
}

// MARK: - Service Protocols (for testability)

protocol HapticServiceProtocol {
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle)
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType)
}

protocol ScoreServiceProtocol {
    func save(score: Int) async
    func topScores() async -> [Int]
}

protocol SettingsServiceProtocol {
    var soundEnabled: Bool { get set }
    var hapticEnabled: Bool { get set }
}

// MARK: - Default Implementations

struct HapticService: HapticServiceProtocol {
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}

struct ScoreService: ScoreServiceProtocol {
    func save(score: Int) async {
        UserDefaults.standard.set(score, forKey: "suika_last_score")
    }
    func topScores() async -> [Int] {
        let scores = UserDefaults.standard.array(forKey: "suika_top_scores") as? [Int] ?? []
        return scores.sorted(by: >)
    }
}

@Observable
final class SettingsService: SettingsServiceProtocol {
    var soundEnabled: Bool {
        didSet { UserDefaults.standard.set(soundEnabled, forKey: "suika_sound") }
    }
    var hapticEnabled: Bool {
        didSet { UserDefaults.standard.set(hapticEnabled, forKey: "suika_haptic") }
    }

    init() {
        self.soundEnabled = UserDefaults.standard.object(forKey: "suika_sound") as? Bool ?? true
        self.hapticEnabled = UserDefaults.standard.object(forKey: "suika_haptic") as? Bool ?? true
    }
}

// MARK: - Environment Key

private struct ServiceContainerKey: EnvironmentKey {
    static let defaultValue = ServiceContainer.shared
}

extension EnvironmentValues {
    var services: ServiceContainer {
        get { self[ServiceContainerKey.self] }
        set { self[ServiceContainerKey.self] = newValue }
    }
}
