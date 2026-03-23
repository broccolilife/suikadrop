# AGENTS.md — SuikaDrop

## Overview
SuikaDrop is a physics-based fruit-merging game for iOS (SwiftUI + SpriteKit).

## Build
```bash
xcodebuild -scheme SuikaDrop -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16' build
```

## Architecture
- **UI Layer**: SwiftUI views with `NavigationStack` routing via `GameRouter`
- **Game Engine**: SpriteKit scene for physics simulation
- **Design System**: `DesignTokens.swift` (spacing, colors, elevation, typography, motion)
- **Core/**: Shared infrastructure — error states, accessibility, adaptive layout, typography, navigation

## Key Patterns
- `@Observable` for state management (not ObservableObject)
- `DesignTokens.Spacing.*` for all spacing (8pt grid)
- `DesignTokens.Typography.*` for all fonts
- `ErrorStateView` / `EmptyStateView` / `LoadingStateView` for all states
- `AccessibilityAnnouncements` for VoiceOver game events
- `ViewThatFits` via `AdaptiveStack` for responsive layouts

## Dependencies
- SpriteKit (system)
- No external package dependencies

## Testing
```bash
xcodebuild test -scheme SuikaDrop -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16'
```
