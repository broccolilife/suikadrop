// NavigationPatterns.swift — Modern Navigation (NavigationStack)
// From Pixel knowledge (2026-02-27): Migrate from NavigationView to NavigationStack
// Use navigationDestination(for:) with typed path values for deep linking

import SwiftUI

// MARK: - Navigation Destinations

enum GameDestination: Hashable {
    case game
    case leaderboard
    case settings
    case tutorial
}

// MARK: - NavigationStack Router

@Observable
final class GameRouter {
    var path = NavigationPath()
    
    func navigate(to destination: GameDestination) {
        path.append(destination)
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}

// MARK: - ViewThatFits Adaptive Layout (from 2026-02-23 learnings)

struct AdaptiveStack<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content
    
    init(spacing: CGFloat = DesignTokens.Spacing.md, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: spacing, content: content)
            VStack(spacing: spacing, content: content)
        }
    }
}
