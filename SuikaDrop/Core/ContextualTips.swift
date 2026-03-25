// ContextualTips.swift — Contextual onboarding tips (not front-loaded tutorials)
// From Pixel knowledge (2026-03-25 NNGroup): Skip onboarding when possible.
// Use contextual tips instead of tutorial screens.
// Error messages as teaching moments.

import SwiftUI
import TipKit

// MARK: - Game Tips

/// Shown when the player first encounters a merge opportunity
struct MergeTip: Tip {
    static let mergeAttempted = Event(id: "mergeAttempted")

    var title: Text { Text("Merge Fruits!") }
    var message: Text? { Text("Drop matching fruits together to combine them into bigger ones.") }
    var image: Image? { Image(systemName: "arrow.triangle.merge") }

    var rules: [Rule] {
        #Rule(Self.mergeAttempted) { $0.donations.count == 0 }
    }
}

/// Shown after first game over to teach combo strategy
struct ComboStrategyTip: Tip {
    static let gameOverCount = Event(id: "gameOverCount")

    var title: Text { Text("Chain Combos") }
    var message: Text? { Text("Stack same fruits near each other for chain reactions and bonus points.") }
    var image: Image? { Image(systemName: "sparkles") }

    var rules: [Rule] {
        #Rule(Self.gameOverCount) { $0.donations.count >= 1 }
    }
}

/// Shown when score passes a threshold — teaches pause/restart
struct PauseMenuTip: Tip {
    @Parameter
    static var hasSeenPause: Bool = false

    var title: Text { Text("Need a Break?") }
    var message: Text? { Text("Tap the pause button to take a break or restart.") }
    var image: Image? { Image(systemName: "pause.circle") }

    var rules: [Rule] {
        #Rule(Self.$hasSeenPause) { !$0 }
    }
}

// MARK: - Tip Configuration

enum TipConfiguration {
    static func setup() {
        try? Tips.configure([
            .displayFrequency(.weekly),
            .datastoreLocation(.applicationDefault)
        ])
    }
}

// MARK: - Tip View Modifier

extension View {
    /// Attaches a contextual tip popover to any view
    func contextualTip<T: Tip>(_ tip: T, arrowEdge: Edge = .bottom) -> some View {
        self.popoverTip(tip, arrowEdge: arrowEdge)
    }
}
