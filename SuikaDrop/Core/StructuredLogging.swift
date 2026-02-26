// StructuredLogging.swift — OSLog structured categories for agent-debuggable logging
// From Pixel knowledge (2026-02-26): Structure error handling + logging so coding agents can debug SwiftUI apps
import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.broccolilife.suikadrop"
    
    /// Game physics and collision events
    static let physics = Logger(subsystem: subsystem, category: "Physics")
    /// Score calculations and leaderboard
    static let scoring = Logger(subsystem: subsystem, category: "Scoring")
    /// UI state transitions and navigation
    static let ui = Logger(subsystem: subsystem, category: "UI")
    /// Persistence: saves, loads, data migration
    static let persistence = Logger(subsystem: subsystem, category: "Persistence")
    /// Network: Game Center, leaderboards
    static let network = Logger(subsystem: subsystem, category: "Network")
    /// Audio and haptic feedback
    static let feedback = Logger(subsystem: subsystem, category: "Feedback")
}
