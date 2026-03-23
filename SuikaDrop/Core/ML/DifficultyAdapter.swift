import Foundation

// MARK: - ML-Based Difficulty Adaptation

/// Tracks player performance metrics and adapts game difficulty in real-time
/// using a lightweight online learning approach (exponential moving average + threshold bands).
final class DifficultyAdapter: ObservableObject {
    
    // MARK: - Types
    
    struct PlayerMetrics {
        var mergeRate: Double        // merges per minute
        var avgDropAccuracy: Double  // 0-1, how close to intended target
        var survivalTime: TimeInterval
        var scorePerMinute: Double
        var comboFrequency: Double   // combos per minute
    }
    
    enum DifficultyLevel: String, CaseIterable {
        case easy, medium, hard, expert
        
        var dropSpeedMultiplier: Double {
            switch self {
            case .easy:   return 0.7
            case .medium: return 1.0
            case .hard:   return 1.3
            case .expert: return 1.6
            }
        }
        
        var fruitVariety: Int {
            switch self {
            case .easy:   return 5
            case .medium: return 7
            case .hard:   return 9
            case .expert: return 11
            }
        }
    }
    
    // MARK: - Properties
    
    @Published private(set) var currentDifficulty: DifficultyLevel = .medium
    @Published private(set) var skillEstimate: Double = 0.5 // 0 (beginner) to 1 (expert)
    
    private var emaAlpha: Double = 0.15
    private var performanceHistory: [Double] = []
    private let maxHistory = 50
    
    // Thresholds for difficulty transitions
    private let thresholds: [(range: ClosedRange<Double>, level: DifficultyLevel)] = [
        (0.0...0.25,  .easy),
        (0.25...0.55, .medium),
        (0.55...0.80, .hard),
        (0.80...1.0,  .expert),
    ]
    
    // MARK: - Methods
    
    /// Update skill estimate with new performance observation
    func recordPerformance(_ metrics: PlayerMetrics) {
        let normalized = normalizeMetrics(metrics)
        
        // EMA update
        skillEstimate = emaAlpha * normalized + (1 - emaAlpha) * skillEstimate
        skillEstimate = max(0, min(1, skillEstimate))
        
        // Track history for variance detection
        performanceHistory.append(normalized)
        if performanceHistory.count > maxHistory {
            performanceHistory.removeFirst()
        }
        
        // Update difficulty level
        updateDifficulty()
    }
    
    /// Compute a flow-state score (0-1). High = player is in the zone.
    var flowScore: Double {
        guard performanceHistory.count >= 5 else { return 0.5 }
        let recent = Array(performanceHistory.suffix(10))
        let mean = recent.reduce(0, +) / Double(recent.count)
        let variance = recent.map { ($0 - mean) * ($0 - mean) }.reduce(0, +) / Double(recent.count)
        
        // Low variance + moderate-high performance = flow state
        let stabilityScore = max(0, 1.0 - variance * 10)
        let performanceScore = mean
        return (stabilityScore * 0.4 + performanceScore * 0.6)
    }
    
    /// Suggest next fruit weights based on current skill (makes harder fruits rarer for beginners)
    func fruitSpawnWeights(fruitCount: Int) -> [Double] {
        let n = min(fruitCount, currentDifficulty.fruitVariety)
        return (0..<n).map { i in
            let baseProbability = 1.0 / Double(n)
            let difficultyBias = Double(i) / Double(n) * (1.0 - skillEstimate)
            return max(0.05, baseProbability - difficultyBias * 0.5)
        }
    }
    
    // MARK: - Private
    
    private func normalizeMetrics(_ m: PlayerMetrics) -> Double {
        // Weighted combination of normalized metrics
        let mergeScore = min(m.mergeRate / 12.0, 1.0)
        let accuracyScore = m.avgDropAccuracy
        let survivalScore = min(m.survivalTime / 300.0, 1.0)
        let comboScore = min(m.comboFrequency / 5.0, 1.0)
        
        return mergeScore * 0.25 + accuracyScore * 0.3 + survivalScore * 0.25 + comboScore * 0.2
    }
    
    private func updateDifficulty() {
        // Require stable estimate (low recent variance) before changing
        guard performanceHistory.count >= 5 else { return }
        
        for (range, level) in thresholds {
            if range.contains(skillEstimate) && level != currentDifficulty {
                currentDifficulty = level
                break
            }
        }
    }
}
