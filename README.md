# 🍉 SuikaDrop

**A Suika-style fruit drop puzzle game for iOS** — merge matching fruits, chain combos, and chase high scores with satisfying physics and juicy animations.

> 🟡 **Status:** In development — core gameplay and design system established.

## Gameplay

Drop fruits into the container. When two identical fruits touch, they merge into the next larger fruit. Chain merges together for combo multipliers. Fill the container and it's game over — aim for the highest score!

<!-- TODO: Add gameplay screenshots/GIF -->

## Features

- 🎮 **Physics-based gameplay** — SpriteKit powers realistic fruit dropping and merging
- 🔥 **Combo system** — chain merges for multiplied scores with visual combo feedback
- ✨ **Ambient particles** — floating fruit emoji backgrounds on menu and idle screens
- 📳 **Haptic feedback** — tactile responses for drops, merges, and combo milestones
- ♿ **Full accessibility** — VoiceOver support, Dynamic Type, semantic grouping
- 🎨 **Design token system** — centralized spacing, typography, colors (inspired by Ice/CodeEdit)
- 🌗 **Light & dark mode** — automatic adaptation via SuikaTheme

## Quick Start

```bash
git clone https://github.com/broccolilife/suikadrop.git
cd suikadrop
open SuikaDrop.xcodeproj
```

Select a simulator or device in Xcode, then **⌘R** to build and run.

**Zero dependencies** — pure SwiftUI + SpriteKit. No CocoaPods, no SPM, no configuration.

### Requirements

| Requirement | Minimum |
|------------|---------|
| iOS | 17.0 (18.0 for MeshGradient backgrounds) |
| Xcode | 16+ |
| macOS | Sonoma or later recommended |
| Dependencies | None |

## Architecture

```
┌─────────────────────────────────────────┐
│              Views Layer                 │
│  GameOverView · ComboView · ScoreHUD    │
│  PauseMenuView · AmbientParticlesView   │
│              (SwiftUI)                   │
├─────────────────────────────────────────┤
│           Core Layer                     │
│  DesignTokens · SuikaTheme · Typography │
│  SpringAnimations · HapticEngine        │
│  Accessibility · ErrorState             │
├─────────────────────────────────────────┤
│          SpriteKit Engine               │
│  Physics simulation · Collision detect  │
│  Fruit merging · Combo chaining         │
└─────────────────────────────────────────┘
```

**Tech stack:** Swift 5.9 · SwiftUI · SpriteKit · PhaseAnimator (iOS 17) · MeshGradient (iOS 18)

## Project Structure

```
SuikaDrop/
├── Core/                        # Foundation — shared across all views
│   ├── DesignTokens.swift       # Spacing (.xs–.xl), radii, shadows
│   ├── SuikaTheme.swift         # Color palette, light/dark adaptation
│   ├── Typography.swift         # Font definitions with Dynamic Type
│   ├── SpringAnimations.swift   # Reusable spring animation configs
│   ├── HapticEngine.swift       # Impact, notification, selection haptics
│   ├── Accessibility.swift      # VoiceOver helpers, AppSection component
│   └── ErrorState.swift         # Enum-driven error handling
│
└── Views/                       # SwiftUI game UI
    ├── GameOverView.swift       # End-of-game screen with score + restart
    ├── ScoreHUDView.swift       # In-game score display
    ├── ComboView.swift          # Combo counter and multiplier overlay
    ├── PauseMenuView.swift      # Pause menu
    └── AmbientParticlesView.swift # Floating emoji particle background
```

## Design System

All UI is driven by a **token-based design system** — no magic numbers anywhere:

| Token | Purpose |
|-------|---------|
| `DesignTokens.Spacing` | `.xs` through `.xl` for consistent padding/margins |
| `DesignTokens.Typography` | `.caption`, `.headline`, etc. with Dynamic Type |
| `DesignTokens.Radius` | Corner radii for cards and containers |
| `SuikaTheme` | Color palette — adapts to light/dark mode automatically |

### Key Patterns

- **View Decomposition** — `@ViewBuilder` private vars keep complex layouts readable
- **Reusable Components** — `AppSection` for grouped content, `.annotation()` modifier for captions
- **Centralized Haptics** — `HapticEngine` handles all tactile feedback consistently

## Development

### Running on Device

1. Connect iPhone via USB or Wi-Fi
2. Select device in Xcode toolbar
3. Trust developer certificate: **Settings → General → VPN & Device Management**
4. **⌘R** to build and run

> **Note:** Haptic feedback only works on physical devices, not simulators.

### Adding a New View

1. Create `.swift` file in `Views/`
2. Use `DesignTokens` for all spacing, radii, typography
3. Use `SuikaTheme` for colors
4. Add VoiceOver labels via `Accessibility` helpers

### Testing Accessibility

Open **Accessibility Inspector** (Xcode → Open Developer Tool) and point it at the running simulator to verify all elements have meaningful labels.

## Documentation

- **[Architecture Overview](docs/ARCHITECTURE.md)** — system design, design patterns, platform requirements
- **[Getting Started Guide](docs/GETTING-STARTED.md)** — setup, development workflow, common tasks

## License

Private — not yet open source.
