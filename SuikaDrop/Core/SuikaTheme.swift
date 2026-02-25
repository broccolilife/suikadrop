// SuikaTheme.swift — App-specific design tokens for SuikaDrop
import SwiftUI

enum SuikaTheme {
    // Fruit colors for game pieces
    static let cherry = Color(red: 0.89, green: 0.15, blue: 0.21)
    static let strawberry = Color(red: 0.96, green: 0.26, blue: 0.35)
    static let grape = Color(red: 0.58, green: 0.24, blue: 0.68)
    static let orange = Color(red: 1.0, green: 0.58, blue: 0.0)
    static let apple = Color(red: 0.3, green: 0.78, blue: 0.35)
    static let pear = Color(red: 0.85, green: 0.92, blue: 0.31)
    static let peach = Color(red: 1.0, green: 0.8, blue: 0.6)
    static let pineapple = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let melon = Color(red: 0.56, green: 0.83, blue: 0.38)
    static let watermelon = Color(red: 0.17, green: 0.63, blue: 0.17)
    
    // Background gradient (MeshGradient-ready for iOS 18+)
    static let backgroundColors: [Color] = [
        .init(red: 0.98, green: 0.95, blue: 0.88),
        .init(red: 0.95, green: 0.90, blue: 0.82)
    ]
    
    // Game-specific tokens
    static let dropZoneOpacity: Double = 0.3
    static let mergeAnimationDuration: Double = 0.35
    static let scorePopScale: CGFloat = 1.4
}

// MARK: - Game Error States
enum GameError: LocalizedError, Equatable {
    case physicsFailure
    case saveCorrupted
    case leaderboardUnavailable
    
    var errorDescription: String? {
        switch self {
        case .physicsFailure: return "Physics Engine Error"
        case .saveCorrupted: return "Save Data Corrupted"
        case .leaderboardUnavailable: return "Leaderboard Unavailable"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .physicsFailure: return "Restarting the game should fix this."
        case .saveCorrupted: return "Your save data may need to be reset."
        case .leaderboardUnavailable: return "Check your Game Center connection."
        }
    }
}
