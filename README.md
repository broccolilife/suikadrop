# 🍉 SuikaDrop

A Suika-style fruit drop puzzle game for iOS — merge matching fruits to score big. Built with SwiftUI + SpriteKit for smooth physics-based gameplay.

## ✨ Features

- **Physics-based gameplay** — SpriteKit handles realistic fruit dropping, bouncing, and merging
- **11 fruit tiers** — merge matching fruits to evolve up the chain
- **Next fruit preview** — plan your strategy with an animated preview
- **Beautiful visuals** — MeshGradient backgrounds (iOS 18+), glow effects, spring animations
- **Full accessibility** — VoiceOver support, Dynamic Type, haptic feedback, reduced motion support
- **Contextual tips** — in-game hints guide new players

## 🏗 Architecture

```
SuikaDrop/
├── Core/                          # Foundation layer
│   ├── DesignTokens.swift         # Centralized spacing, sizing, timing constants
│   ├── SuikaTheme.swift           # Color palette and theming
│   ├── Typography.swift           # Font system with Dynamic Type
│   ├── Accessibility.swift        # VoiceOver helpers, semantic grouping
│   ├── ErrorState.swift           # Enum-driven error handling
│   ├── SpringAnimations.swift     # Reusable spring animation presets
│   ├── PhaseAnimations.swift      # Phase-based animations (iOS 17+)
│   ├── FruitGlowModifier.swift    # Glow effect for fruit merge moments
│   ├── MeshBackground.swift       # MeshGradient backgrounds (iOS 18+)
│   ├── ReducedMotion.swift        # Respects user motion preferences
│   ├── AdaptiveLayout.swift       # Layout adaptation for different screens
│   ├── ContextualTips.swift       # In-game contextual hints
│   └── NavigationRouter.swift     # Navigation state management
│
└── Views/
    └── NextFruitPreview.swift     # Animated preview of next fruit to drop
```

### Design Principles

- **Token-driven** — all spacing, colors, and sizing flow through `DesignTokens.swift` and `SuikaTheme.swift`. No magic numbers.
- **Accessibility-first** — VoiceOver labels, Dynamic Type scaling, and reduced motion alternatives are built in from the start.
- **Progressive enhancement** — MeshGradient (iOS 18+) and PhaseAnimator (iOS 17+) gracefully degrade on older versions.

### Key Patterns

| Pattern | Implementation |
|---------|---------------|
| Design tokens | `DesignTokens.swift` — single source for all UI constants |
| Theming | `SuikaTheme.swift` — color palette, adaptable to future theme support |
| Animation | Spring presets + PhaseAnimator for merge effects |
| Error handling | `ErrorState` enum with user-facing messages |
| Navigation | `NavigationRouter` with `@Observable` state |

## 🚀 Getting Started

### Prerequisites

- **Xcode 16+**
- **iOS 17+** deployment target (iOS 18+ recommended for full visual effects)
- macOS Sonoma or later

### Build & Run

```bash
git clone https://github.com/broccolilife/suikadrop.git
cd suikadrop
open SuikaDrop.xcodeproj
```

1. Select an iPhone simulator or connected device
2. Press **⌘R** to build and run
3. Drop fruits and start merging!

### Project Notes

- **No external dependencies** — pure SwiftUI + SpriteKit
- **No CocoaPods/SPM packages** — everything is first-party
- Physics tuning constants are in `DesignTokens.swift`

## 🎮 How to Play

1. Tap to drop a fruit into the container
2. When two identical fruits touch, they merge into a larger fruit
3. Chain merges for combo points
4. Don't let fruits overflow the container!

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI Framework | SwiftUI (iOS 17+) |
| Physics Engine | SpriteKit |
| Animations | PhaseAnimator, Spring, MeshGradient |
| Accessibility | VoiceOver, Dynamic Type, Haptics |

## Status

🟡 **In development** — Core gameplay and design system built

## License

Private
