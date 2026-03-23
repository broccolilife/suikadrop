import Foundation

// MARK: - Fruit Drop Outcome Predictor

/// Predicts likely merge outcomes using a simple Markov chain model
/// built from observed gameplay. Used to provide "ghost" merge previews.
final class FruitPredictor {
    
    // MARK: - Types
    
    typealias FruitType = Int // 0 = smallest, N = largest
    
    struct Prediction {
        let likelyMerges: [(from: FruitType, to: FruitType, probability: Double)]
        let expectedScore: Double
        let chainLength: Int
    }
    
    // MARK: - Properties
    
    /// Transition matrix: transitionCounts[from][to] = observed count
    private var transitionCounts: [[Int]]
    private let maxFruitTypes: Int
    
    // MARK: - Init
    
    init(maxFruitTypes: Int = 11) {
        self.maxFruitTypes = maxFruitTypes
        self.transitionCounts = Array(
            repeating: Array(repeating: 0, count: maxFruitTypes),
            count: maxFruitTypes
        )
    }
    
    // MARK: - Learning
    
    /// Record an observed merge event
    func recordMerge(from: FruitType, to: FruitType) {
        guard from >= 0, from < maxFruitTypes, to >= 0, to < maxFruitTypes else { return }
        transitionCounts[from][to] += 1
    }
    
    // MARK: - Prediction
    
    /// Predict chain of merges starting from a given fruit type
    func predict(from fruit: FruitType, maxChain: Int = 3) -> Prediction {
        var merges: [(FruitType, FruitType, Double)] = []
        var current = fruit
        var totalScore: Double = 0
        
        for _ in 0..<maxChain {
            let row = transitionCounts[current]
            let total = row.reduce(0, +)
            guard total > 0 else { break }
            
            // Find most likely next merge
            let bestNext = row.enumerated().max(by: { $0.element < $1.element })!
            let prob = Double(bestNext.element) / Double(total)
            
            guard prob > 0.1 else { break } // Low confidence, stop
            
            merges.append((current, bestNext.offset, prob))
            totalScore += Double(bestNext.offset + 1) * 10 * prob
            current = bestNext.offset
        }
        
        return Prediction(likelyMerges: merges, expectedScore: totalScore, chainLength: merges.count)
    }
    
    /// Get the full transition probability matrix (normalized)
    func transitionMatrix() -> [[Double]] {
        transitionCounts.map { row in
            let total = Double(row.reduce(0, +))
            guard total > 0 else { return Array(repeating: 0.0, count: maxFruitTypes) }
            return row.map { Double($0) / total }
        }
    }
}
