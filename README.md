# 🍉 SuikaDrop

A Suika-style fruit drop puzzle game for iOS — merge matching fruits, chain combos, and chase high scores with satisfying physics and juicy animations.

## Screenshots

<!-- TODO: Add gameplay screenshots/GIF -->

## Features

- **Physics-based gameplay** — SpriteKit powers realistic fruit dropping and merging
- **Combo system** — Chain merges for multiplied scores with visual combo feedback
- **Ambient particles** — Floating fruit emoji backgrounds on menu/idle screens
- **Haptic feedback** — Tactile responses for drops, merges, and combos
- **Full accessibility** — VoiceOver support, Dynamic Type, semantic grouping
- **Modern iOS** — PhaseAnimator (iOS 17+), MeshGradient backgrounds (iOS 18+)

## Architecture

```
SuikaDrop/
├── Core/                    # Foundation layer
│   ├── DesignTokens.swift   # Spacing, typography, radius, shadows
│   ├── SuikaTheme.swift     # Color palette and theming
│   ├── Typography.swift     # Font definitions with Dynamic Type
│   ├── SpringAnimations.swift # Reusable spring animation configs
│   ├── HapticEngine.swift   # Impact, notification, selection haptics
│   ├── Accessibility.swift  # VoiceOver helpers, AppSection, annotation modifier
│   └── ErrorState.swift     # Enum-driven error handling
│
└── Views/                   # UI layer
    ├── GameOverView.swift    # End-of-game screen with score + restart
    ├── ComboView.swift       # Combo counter and multiplier display
    └── AmbientParticlesView.swift # Floating emoji particle background
```

### Design Patterns

- **Design Tokens** — All spacing, radii, typography, and colors flow from `DesignTokens.swift` for consistency
- **View Decomposition** — `@ViewBuilder` private vars keep views readable (Ice/CodeEdit pattern)
- **Reusable Sections** — `AppSection` component for grouped content with optional headers
- **Annotation Modifier** — `.annotation("helper text")` for inline captions

## Getting Started

### Prerequisites

- **Xcode 16+**
- **iOS 17+** deployment target (iOS 18+ for MeshGradient backgrounds)
- macOS Sonoma or later recommended

### Run

```bash
git clone https://github.com/broccolilife/suikadrop.git
cd suikadrop
open SuikaDrop.xcodeproj
```

Select a simulator or device in Xcode, then **⌘R** to build and run.

### Project Setup Notes

- No external dependencies — pure SwiftUI + SpriteKit
- No CocoaPods/SPM packages required
- Runs on simulator, but haptics only work on physical devices

## Design System

The app uses a token-based design system inspired by Ice and CodeEdit:

| Token | Purpose |
|-------|---------|
| `DesignTokens.Spacing` | `.xs` through `.xl` for consistent padding/margins |
| `DesignTokens.Typography` | `.caption`, `.headline`, etc. with Dynamic Type |
| `DesignTokens.Radius` | Corner radii for cards and containers |
| `SuikaTheme` | Color palette — adapts to light/dark mode |

## Status

🟡 **In development** — Core gameplay and design system established

## Documentation

- **[Architecture Overview](docs/ARCHITECTURE.md)** — System design, design patterns, and platform requirements
- **[Getting Started Guide](docs/GETTING-STARTED.md)** — Setup, development workflow, and common tasks

## License

Private — not yet open source
