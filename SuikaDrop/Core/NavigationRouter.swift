// NavigationRouter.swift — Value-based navigation for SuikaDrop
// Pixel+Muse — NavigationPath router with deep link support (from 2026-03-28 research)

import SwiftUI

// MARK: - Route Definition

enum SuikaRoute: Hashable, Codable {
    case game
    case settings
    case leaderboard
    case tutorial
    case stats
}

// MARK: - Router

@Observable
final class NavigationRouter {
    var path = NavigationPath()

    func push(_ route: SuikaRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }

    // MARK: - State Restoration (Codable)

    var encoded: Data? {
        try? JSONEncoder().encode(path.codable)
    }

    func restore(from data: Data) {
        guard let codable = try? JSONDecoder().decode(
            NavigationPath.CodableRepresentation.self, from: data
        ) else { return }
        path = NavigationPath(codable)
    }
}

// MARK: - Environment Key

private struct RouterKey: EnvironmentKey {
    static let defaultValue = NavigationRouter()
}

extension EnvironmentValues {
    var router: NavigationRouter {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}
