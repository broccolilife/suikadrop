// NavigationRouter.swift — Type-safe NavigationStack routing
// From Pixel knowledge (3/26): NavigationStack + NavigationPath for programmatic navigation
// @Observable macro (3/27): replaces ObservableObject boilerplate

import SwiftUI

// MARK: - Route Definitions

enum SuikaRoute: Hashable, Codable {
    case game
    case leaderboard
    case settings
    case about
}

// MARK: - Router (@Observable — no @Published needed)
// State restoration via Codable NavigationPath (from 3/28 knowledge)

@Observable
final class SuikaRouter {
    var path = NavigationPath()

    private static let stateKey = "suika_nav_state"

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

    // MARK: - State Restoration (Codable NavigationPath for deep links)

    func saveState() {
        guard let representation = path.codable else { return }
        if let data = try? JSONEncoder().encode(representation) {
            UserDefaults.standard.set(data, forKey: Self.stateKey)
        }
    }

    func restoreState() {
        guard let data = UserDefaults.standard.data(forKey: Self.stateKey),
              let representation = try? JSONDecoder().decode(
                  NavigationPath.CodableRepresentation.self, from: data
              ) else { return }
        path = NavigationPath(representation)
    }

    func clearSavedState() {
        UserDefaults.standard.removeObject(forKey: Self.stateKey)
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
