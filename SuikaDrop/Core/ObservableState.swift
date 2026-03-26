// ObservableState.swift — @Observable macro patterns for SuikaDrop
// Pixel+Muse — fine-grained reactivity, iOS 17+

import SwiftUI
import Observation

// MARK: - Game State (@Observable replaces ObservableObject)

@Observable
final class GameState {
    // All stored properties auto-observed — no @Published needed
    var score: Int = 0
    var highScore: Int = 0
    var currentFruit: FruitType = .cherry
    var nextFruit: FruitType = .grape
    var comboCount: Int = 0
    var isGameOver: Bool = false
    var isPaused: Bool = false
    
    // Computed properties are automatically tracked
    var comboMultiplier: Double {
        1.0 + Double(min(comboCount, 10)) * 0.15
    }
    
    var isNewHighScore: Bool {
        score > highScore
    }
    
    func resetGame() {
        score = 0
        comboCount = 0
        isGameOver = false
        isPaused = false
    }
}

// Placeholder — replace with actual fruit enum
enum FruitType: String, CaseIterable {
    case cherry, grape, orange, apple, pear, peach, pineapple, melon, watermelon
}

// MARK: - Settings State

@Observable
final class SettingsState {
    var hapticEnabled: Bool = true
    var soundEnabled: Bool = true
    var musicVolume: Double = 0.7
    var difficulty: Difficulty = .normal
    
    enum Difficulty: String, CaseIterable {
        case easy, normal, hard
    }
}

// MARK: - Environment Registration

extension EnvironmentValues {
    @Entry var gameState: GameState = GameState()
    @Entry var settingsState: SettingsState = SettingsState()
}

// MARK: - Usage Patterns

/*
 // Root injection (App.swift):
 @State private var gameState = GameState()
 
 var body: some Scene {
     WindowGroup {
         ContentView()
             .environment(\.gameState, gameState)
     }
 }
 
 // Consuming view — only re-renders when READ properties change:
 struct ScoreView: View {
     @Environment(\.gameState) private var game
     
     var body: some View {
         Text("\(game.score)")  // Only re-renders when score changes
     }
 }
 
 // Bindings with @Bindable:
 struct SettingsView: View {
     @Bindable var settings: SettingsState
     
     var body: some View {
         Toggle("Haptics", isOn: $settings.hapticEnabled)
     }
 }
*/
