// NavigationRouter.swift — Type-safe NavigationStack routing
// From Pixel knowledge (3/26): NavigationStack + NavigationPath for programmatic navigation
// @Observable macro (3/27): replaces ObservableObject boilerplate

import SwiftUI

// MARK: - Route Definitions

enum SuikaRoute: Hashable {
    case game
    case leaderboard
    case settings
    case about
}

// MARK: - Router (@Observable — no @Published needed)

@Observable
final class SuikaRouter {
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
}

// MARK: - Navigation Destination Modifier

extension View {
    func withSuikaDestinations() -> some View {
        self.navigationDestination(for: SuikaRoute.self) { route in
            switch route {
            case .game:
                Text("Game View") // Replace with actual GameView
            case .leaderboard:
                Text("Leaderboard") // Replace with actual view
            case .settings:
                Text("Settings")
            case .about:
                Text("About")
            }
        }
    }
}
