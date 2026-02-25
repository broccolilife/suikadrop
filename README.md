# 🍉 SuikaDrop

Suika-style fruit drop puzzle game — merge matching fruits, score big.

## Architecture
- **SwiftUI + SpriteKit** for physics-based gameplay
- **Design Tokens** — `DesignTokens.swift` for consistent spacing, typography, animation
- **Error States** — `ErrorState.swift` with enum-driven error handling
- **Accessibility** — Full VoiceOver support, Dynamic Type, haptic feedback

## Design System
Built on learnings from Ice, CodeEdit, and TCA patterns:
- View decomposition via `@ViewBuilder` private vars
- Reusable `AppSection` components
- `.annotation()` modifier for helper text
- PhaseAnimator for fruit merge animations (iOS 17+)
- MeshGradient backgrounds (iOS 18+)

## Getting Started
Open `SuikaDrop.xcodeproj` in Xcode 16+ and run on iOS 17+.
