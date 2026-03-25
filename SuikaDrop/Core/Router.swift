// Router.swift — Type-safe NavigationStack router
// From Pixel knowledge (2026-03-23): NavigationStack + NavigationPath pattern
// Enables deep linking, state restoration, programmatic navigation

import SwiftUI
import Observation

// MARK: - Route Definitions

enum SuikaRoute: Hashable {
    case game
    case settings
    case leaderboard
    case tutorial
}

// MARK: - Router

@Observable
final class Router {
    var path = NavigationPath()

    func navigate(to route: SuikaRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}

// MARK: - Environment Key

private struct RouterKey: EnvironmentKey {
    static let defaultValue = Router()
}

extension EnvironmentValues {
    var router: Router {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}
