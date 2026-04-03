# Getting Started — SuikaDrop

## Prerequisites

| Requirement | Version | Notes |
|-------------|---------|-------|
| Xcode | 16+ | Download from [developer.apple.com](https://developer.apple.com/xcode/) |
| iOS target | 17.0+ | 18.0+ recommended for MeshGradient effects |
| macOS | Sonoma 14.0+ | Required for Xcode 16 |
| Swift | 5.9+ | Bundled with Xcode 16 |

## Setup

```bash
# Clone the repo
git clone https://github.com/broccolilife/suikadrop.git
cd suikadrop

# Open in Xcode
open SuikaDrop.xcodeproj
```

**No package resolution needed** — there are zero external dependencies. No CocoaPods, no SPM packages, no Carthage.

## Running the App

1. Select a simulator (iPhone 15 Pro recommended) or connected physical device
2. Press **⌘R** to build and run
3. The game launches directly into the play screen — tap to drop fruits!

### Running on a Physical Device

1. Connect iPhone via USB or Wi-Fi
2. Select it in Xcode's device picker
3. If prompted, trust the developer certificate: **Settings → General → VPN & Device Management**
4. Press **⌘R**

> **Note:** Haptic feedback only works on physical devices with a Taptic Engine.

## Project Structure

```
suikadrop/
├── SuikaDrop/
│   ├── Core/               # 16 files — design tokens, theme, accessibility,
│   │   │                   #   animations, haptics, navigation, errors
│   │   ├── DesignTokens.swift
│   │   ├── SuikaTheme.swift
│   │   ├── ColorTokens.swift
│   │   ├── Typography.swift
│   │   ├── Accessibility.swift
│   │   ├── HapticManager.swift
│   │   ├── SpringAnimations.swift
│   │   ├── PhaseAnimations.swift
│   │   ├── ParticleAnimations.swift
│   │   ├── FruitGlowModifier.swift
│   │   ├── MeshBackground.swift
│   │   ├── ReducedMotion.swift
│   │   ├── AdaptiveLayout.swift
│   │   ├── ContextualTips.swift
│   │   ├── NavigationRouter.swift
│   │   └── ErrorState.swift
│   │
│   └── Views/              # 4 files — composable SwiftUI views
│       ├── NextFruitPreview.swift
│       ├── GameOverOverlay.swift
│       ├── ComboPopup.swift
│       └── ScoreHistoryChart.swift
│
├── SuikaDrop.xcodeproj
├── docs/
│   ├── ARCHITECTURE.md
│   └── GETTING-STARTED.md
└── README.md
```

## Development Workflow

### Modifying the Design System

All visual constants live in `SuikaDrop/Core/DesignTokens.swift`:

```swift
enum DesignTokens {
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        // ...
    }
}
```

Changes here propagate automatically to all views that reference the tokens.

### Adding a New View

1. Create the file in `SuikaDrop/Views/`
2. Use design tokens for all spacing and sizing:
   ```swift
   .padding(DesignTokens.Spacing.md)
   .cornerRadius(DesignTokens.Radius.lg)
   ```
3. Use `SuikaTheme` / `ColorTokens` for colors
4. Add VoiceOver labels via the `Accessibility` helpers
5. Respect reduced motion:
   ```swift
   @Environment(\.accessibilityReduceMotion) private var reduceMotion
   // Use simple fades when reduceMotion is true
   ```

### Adding a New Animation

1. For **spring animations** — add a named preset to `SpringAnimations.swift`
2. For **multi-phase effects** — add to `PhaseAnimations.swift` (iOS 17+)
3. For **particle effects** — add to `ParticleAnimations.swift`
4. Always provide a reduced-motion fallback

### Tuning Physics

Physics constants (gravity, restitution, friction, fruit sizes) are centralized. Adjust these to change how the game feels — heavier gravity makes the game faster, lower restitution reduces bouncing.

### Adding Haptic Feedback

Use the `HapticManager` singleton:

```swift
HapticManager.shared.fruitDropped()   // Light impact
HapticManager.shared.fruitMerged()    // Medium impact
// Add new events as methods on HapticManager
```

## Testing Accessibility

SuikaDrop has extensive accessibility support. Verify with:

### VoiceOver
1. Enable on simulator: **Settings → Accessibility → VoiceOver**
2. Navigate through the game — fruits should announce their type
3. Score changes and combos should be announced

### Dynamic Type
1. **Settings → Accessibility → Display & Text Size → Larger Text**
2. Verify all text in overlays and score displays scales correctly

### Reduced Motion
1. **Settings → Accessibility → Motion → Reduce Motion**
2. All spring/phase/particle animations should be replaced with simple fades

### Accessibility Inspector
Use Xcode's built-in tool: **Xcode → Open Developer Tool → Accessibility Inspector**

## Common Issues

| Issue | Solution |
|-------|---------|
| MeshGradient not rendering | Requires iOS 18+. Falls back to solid gradient on iOS 17 — this is expected |
| No haptics in simulator | Haptics only work on physical devices with Taptic Engine |
| Physics feel too fast/slow | Tune gravity and timing constants in DesignTokens |
| Tips not appearing | TipKit tips may require a reset: `Tips.resetDatastore()` in debug |
| Build fails on Xcode 15 | Xcode 16+ is required — uses Swift 5.9+ features and @Observable |

## Next Steps

- Read [ARCHITECTURE.md](ARCHITECTURE.md) for the full system design, state flow diagram, and design decisions
- Check the main [README](../README.md) for feature overview and gameplay guide
