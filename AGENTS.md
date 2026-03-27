# AGENTS.md — SuikaDrop

## Overview
SuikaDrop is a Suika Game (watermelon game) clone for iOS built with SwiftUI + SpriteKit.

## Build
- Xcode 16+, iOS 17+ deployment target
- Open `SuikaDrop.xcodeproj` (or generate from Package.swift if applicable)
- Scheme: `SuikaDrop`
- Simulator: iPhone 15 Pro

## Architecture
- **Core/**: Design tokens, accessibility, animations, navigation router
- **Views/**: SwiftUI views (game, menus, settings)
- **@Observable** for state management (no ObservableObject)
- **NavigationStack** with type-safe routes via `SuikaRouter`

## Design System
- `DesignTokens.swift` — spacing, radius, motion, opacity, shadows
- `SuikaTheme.swift` — app-specific colors (fruit palette)
- `Typography.swift` — type scale
- `Accessibility.swift` — VoiceOver, Dynamic Type, haptics
- `PhaseAnimations.swift` — iOS 17+ declarative animations
- `MeshBackground.swift` — iOS 18+ ambient gradients

## Key Patterns
- View decomposition: max ~15 lines in `body`, extract `@ViewBuilder` private vars
- PhaseAnimator for looping effects (no Timer loops)
- ViewThatFits for adaptive layouts
- Contextual tips instead of onboarding screens
