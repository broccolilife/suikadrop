# 🍉 SuikaDrop

A Suika-style fruit drop puzzle game built with SwiftUI and SpriteKit. Merge matching fruits to score big — with satisfying physics, combo chains, and fever mode.

## Screenshots

*Coming soon*

## Features

- 🎮 **Physics-based gameplay** — SpriteKit handles realistic fruit collisions and merging
- 🔥 **Combo system** — Chain merges trigger animated combo overlays with fever mode
- 🏆 **New best celebration** — Animated celebration when you beat your high score
- ♿ **Full accessibility** — VoiceOver support, Dynamic Type, haptic feedback
- 🎨 **Design token system** — Consistent spacing, typography, colors, and animations
- ✨ **Modern iOS** — PhaseAnimator (iOS 17+), MeshGradient backgrounds (iOS 18+)

## Architecture Overview

```
SuikaDrop/
├── Core/                    # Foundation layer
│   ├── DesignTokens.swift   # Spacing, radius, typography, color tokens
│   ├── SuikaTheme.swift     # Theme configuration
│   ├── Typography.swift     # Type scale system
│   ├── SpringAnimations.swift # Reusable spring configs
│   ├── Accessibility.swift  # VoiceOver & Dynamic Type helpers
│   └── ErrorState.swift     # Enum-driven error handling
│
└── Views/                   # UI layer
    ├── ComboOverlay.swift   # Animated combo counter (fever pulsing)
    └── NewBestCelebration.swift # High score celebration
```

### Design Patterns

- **Design Tokens** — All spacing, radii, typography, and colors flow through `DesignTokens.swift` for consistency
- **View Decomposition** — `@ViewBuilder` private vars keep views modular (inspired by Ice, CodeEdit, TCA patterns)
- **Reusable Components** — `AppSection` wrappers, `.annotation()` modifier for helper text
- **Enum-driven Errors** — `ErrorState` provides type-safe error handling with recovery actions
- **Spring Animations** — Centralized spring configs for merge, drop, and UI transitions

## Getting Started

### Prerequisites

- **Xcode 16+**
- **iOS 17.0+** deployment target (iOS 18+ for MeshGradient backgrounds)
- macOS Sonoma or later recommended

### Build & Run

```bash
# Clone the repository
git clone https://github.com/broccolilife/suikadrop.git
cd suikadrop

# Open in Xcode
open SuikaDrop.xcodeproj

# Select an iOS 17+ simulator or device, then ⌘R to run
```

No additional dependencies or package managers required — pure SwiftUI + SpriteKit.

### Project Setup

The project uses a standard Xcode project structure (`SuikaDrop.xcodeproj`). No CocoaPods, SPM packages, or external dependencies.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | SwiftUI |
| Physics | SpriteKit |
| Animations | PhaseAnimator, Spring |
| Platform | iOS 17+ |
| Language | Swift 5.9+ |

## License

Private — not yet open source.
