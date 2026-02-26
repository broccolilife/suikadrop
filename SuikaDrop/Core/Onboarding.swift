// Onboarding.swift — TipKit-based contextual onboarding
// From Pixel knowledge (2023 web): TipKit for consistent contextual tooltips
import SwiftUI
import TipKit

// MARK: - Game Tips

struct DropFruitTip: Tip {
    var title: Text { Text("Drop to Merge") }
    var message: Text? { Text("Tap anywhere to drop a fruit. Match two of the same kind to merge them into a bigger fruit!") }
    var image: Image? { Image(systemName: "arrow.down.circle.fill") }
}

struct MergeChainTip: Tip {
    @Parameter static var mergeCount: Int = 0
    
    var title: Text { Text("Chain Reactions") }
    var message: Text? { Text("Merging fruits can trigger chain reactions for bonus points. Plan your drops!") }
    var image: Image? { Image(systemName: "sparkles") }
    
    var rules: [Rule] {
        #Rule(Self.$mergeCount) { $0 >= 3 }
    }
}

struct HighScoreTip: Tip {
    var title: Text { Text("New High Score!") }
    var message: Text? { Text("Check the leaderboard to see how you rank.") }
    var image: Image? { Image(systemName: "trophy.fill") }
}

// MARK: - Tip Configuration Helper

enum OnboardingManager {
    static func configure() {
        try? Tips.configure([
            .displayFrequency(.weekly),
            .datastoreLocation(.applicationDefault)
        ])
    }
}
