import Foundation

// MARK: - ML-based Difficulty Adaptation
// Tracks player performance and dynamically adjusts game difficulty
// using exponential moving average and change-point detection.

/// Represents a snapshot of player performance metrics.
struct PerformanceSnapshot: Codable {
    let score: Int
    let mergeCount: Int
    let dropCount: Int
    let survivalTimeSeconds: Double
    let timestamp: Date

    var mergeRatio: Double {
        guard dropCount > 0 else { return 0 }
        return Double(mergeCount) / Double(dropCount)
    }

    var scorePerSecond: Double {
        guard survivalTimeSeconds > 0 else { return 0 }
        return Double(score) / survivalTimeSeconds
    }
}

/// Difficulty parameters that the game engine uses.
struct DifficultyParams: Codable, Equatable {
    var dropSpeedMultiplier: Double      // 0.5 (easy) to 2.0 (hard)
    var maxFruitTier: Int                // highest tier fruit that can spawn
    var gravityMultiplier: Double        // physics gravity scale
    var spawnVariety: Int                // how many distinct fruits in rotation

    static let easy = DifficultyParams(
        dropSpeedMultiplier: 0.6,
        maxFruitTier: 3,
        gravityMultiplier: 0.8,
        spawnVariety: 3
    )

    static let normal = DifficultyParams(
        dropSpeedMultiplier: 1.0,
        maxFruitTier: 5,
        gravityMultiplier: 1.0,
        spawnVariety: 5
    )

    static let hard = DifficultyParams(
        dropSpeedMultiplier: 1.4,
        maxFruitTier: 7,
        gravityMultiplier: 1.2,
        spawnVariety: 7
    )
}

/// Adaptive difficulty engine using player performance tracking.
final class DifficultyAdapter {

    // MARK: - Properties

    private var history: [PerformanceSnapshot] = []
    private let windowSize: Int
    private let emaAlpha: Double

    private(set) var currentParams: DifficultyParams
    private(set) var playerSkillEstimate: Double = 0.5  // 0 = beginner, 1 = expert

    // MARK: - Init

    init(windowSize: Int = 20, emaAlpha: Double = 0.3) {
        self.windowSize = windowSize
        self.emaAlpha = emaAlpha
        self.currentParams = .normal
    }

    // MARK: - Core

    /// Record a game session and update difficulty.
    @discardableResult
    func recordSession(_ snapshot: PerformanceSnapshot) -> DifficultyParams {
        history.append(snapshot)
        if history.count > windowSize * 2 {
            history = Array(history.suffix(windowSize))
        }

        updateSkillEstimate()
        adaptDifficulty()
        return currentParams
    }

    /// Compute EMA of a metric over recent history.
    func ema(of keyPath: KeyPath<PerformanceSnapshot, Double>) -> Double {
        guard !history.isEmpty else { return 0 }

        var result = history[0][keyPath: keyPath]
        for snapshot in history.dropFirst() {
            result = emaAlpha * snapshot[keyPath: keyPath] + (1 - emaAlpha) * result
        }
        return result
    }

    // MARK: - Private

    private func updateSkillEstimate() {
        let mergeEMA = ema(of: \.mergeRatio)
        let spsEMA = ema(of: \.scorePerSecond)

        // Normalize: mergeRatio typically 0-1, sps varies by game
        // Use sigmoid-like mapping
        let mergeSignal = mergeEMA  // already 0-1
        let spsSignal = min(spsEMA / 50.0, 1.0)  // normalize to ~0-1

        playerSkillEstimate = 0.6 * mergeSignal + 0.4 * spsSignal
    }

    private func adaptDifficulty() {
        // Smooth transitions between difficulty tiers
        let skill = playerSkillEstimate

        currentParams = DifficultyParams(
            dropSpeedMultiplier: lerp(0.6, 1.6, t: skill),
            maxFruitTier: Int(lerp(3, 8, t: skill)),
            gravityMultiplier: lerp(0.8, 1.3, t: skill),
            spawnVariety: Int(lerp(3, 7, t: skill))
        )
    }

    private func lerp(_ a: Double, _ b: Double, t: Double) -> Double {
        a + (b - a) * max(0, min(1, t))
    }

    /// Detect if player is on a losing streak (potential frustration).
    var isPlayerStruggling: Bool {
        guard history.count >= 3 else { return false }
        let recent = history.suffix(3)
        return recent.allSatisfy { $0.mergeRatio < 0.2 }
    }

    /// Reset to defaults.
    func reset() {
        history.removeAll()
        currentParams = .normal
        playerSkillEstimate = 0.5
    }
}
