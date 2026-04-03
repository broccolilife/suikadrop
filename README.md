# 🍉 SuikaDrop

A Suika-style fruit drop puzzle game for iOS — merge matching fruits to score big. Built with SwiftUI + SpriteKit for smooth physics-based gameplay.

> 🟡 **Status:** In development — core gameplay and design system built

## ✨ Features

- **Physics-based gameplay** — SpriteKit handles realistic fruit dropping, bouncing, and merging
- **11 fruit tiers** — merge matching fruits to evolve up the chain (🍒 → 🍇 → 🍊 → … → 🍉)
- **Combo system** — chain merges for multiplied scores with animated combo popups
- **Score history** — bar chart tracking your progress across games
- **Next fruit preview** — plan your strategy with an animated preview
- **Beautiful visuals** — MeshGradient backgrounds (iOS 18+), glow effects, particle animations, spring animations
- **Full accessibility** — VoiceOver support, Dynamic Type, haptic feedback, reduced motion support
- **Contextual tips** — TipKit-based in-game hints guide new players

## 🎮 How to Play

1. **Tap** to drop a fruit into the container
2. When **two identical fruits** touch, they merge into the next tier
3. **Chain merges** for combo multipliers — the popup shows your streak
4. Don't let fruits overflow the container — **game over** if they spill!
5. Check your **score history chart** to track improvement over time

## 🚀 Quick Start

```bash
git clone https://github.com/broccolilife/suikadrop.git
cd suikadrop
open SuikaDrop.xcodeproj
# Select iPhone simulator → ⌘R to build and run
```

**Zero dependencies** — no CocoaPods, no SPM packages, no configuration needed.

### Requirements

| Requirement | Version |
|-------------|---------|
| Xcode | 16+ |
| iOS target | 17.0+ (18.0+ for MeshGradient effects) |
| macOS | Sonoma 14.0+ |
| Swift | 5.9+ |

## 🏗 Architecture

SuikaDrop follows a **two-layer architecture** — a Core foundation layer providing design tokens, accessibility, and animation primitives, consumed by a thin Views layer of composable SwiftUI components. SpriteKit handles the physics simulation in a separate scene.

```
┌──────────────────────────────────────────────────────────┐
│                     SwiftUI Views                        │
│  NextFruitPreview · GameOverOverlay · ComboPopup         │
│  ScoreHistoryChart                                       │
├──────────────────────────────────────────────────────────┤
│                   SpriteKit Scene                        │
│    Physics World · Contact Detection · Fruit Merging     │
├──────────────────────────────────────────────────────────┤
│                    Core Layer                            │
│  DesignTokens · SuikaTheme · ColorTokens                │
│  Typography · Accessibility · ReducedMotion              │
│  SpringAnimations · PhaseAnimations · ParticleAnimations │
│  FruitGlowModifier · MeshBackground · HapticManager     │
│  ContextualTips · AdaptiveLayout · NavigationRouter      │
│  ErrorState                                              │
└──────────────────────────────────────────────────────────┘
```

### Project Structure

```
suikadrop/
├── SuikaDrop/
│   ├── Core/                          # Foundation layer (16 files)
│   │   ├── DesignTokens.swift         # Spacing, sizing, timing constants
│   │   ├── SuikaTheme.swift           # Color palette and semantic theming
│   │   ├── ColorTokens.swift          # Extended colors and fruit-tier mappings
│   │   ├── Typography.swift           # Font system with Dynamic Type
│   │   ├── Accessibility.swift        # VoiceOver helpers, semantic grouping
│   │   ├── HapticManager.swift        # CoreHaptics engine for game events
│   │   ├── SpringAnimations.swift     # Reusable spring presets (bouncy/snappy/gentle)
│   │   ├── PhaseAnimations.swift      # Multi-phase merge effects (iOS 17+)
│   │   ├── ParticleAnimations.swift   # Particle effects for merges and combos
│   │   ├── FruitGlowModifier.swift    # Glow ViewModifier for merge moments
│   │   ├── MeshBackground.swift       # MeshGradient backgrounds (iOS 18+)
│   │   ├── ReducedMotion.swift        # Respects Reduce Motion preference
│   │   ├── AdaptiveLayout.swift       # iPhone SE → Pro Max layout adaptation
│   │   ├── ContextualTips.swift       # TipKit contextual hints for new players
│   │   ├── NavigationRouter.swift     # @Observable navigation state
│   │   └── ErrorState.swift           # Enum-driven error handling
│   │
│   └── Views/                         # UI components (4 files)
│       ├── NextFruitPreview.swift     # Animated next fruit with bob animation
│       ├── GameOverOverlay.swift      # Game over screen with score + replay
│       ├── ComboPopup.swift           # Animated combo multiplier popup
│       └── ScoreHistoryChart.swift    # Bar chart of recent game scores
│
├── docs/
│   ├── ARCHITECTURE.md                # Detailed architecture overview
│   └── GETTING-STARTED.md            # Development setup guide
└── README.md
```

### Design Principles

- **Token-driven** — all spacing, colors, sizing, and timing flow through `DesignTokens.swift` and `SuikaTheme.swift`. Zero magic numbers.
- **Accessibility-first** — VoiceOver labels, Dynamic Type scaling, reduced motion alternatives, and haptic feedback are built in from the start.
- **Progressive enhancement** — MeshGradient (iOS 18+) and PhaseAnimator (iOS 17+) gracefully degrade on older versions.
- **Zero dependencies** — pure Apple frameworks only (SwiftUI, SpriteKit, CoreHaptics, TipKit).

### Key Patterns

| Pattern | Implementation |
|---------|---------------|
| Design tokens | `DesignTokens.swift` — single source for all UI constants |
| Theming | `SuikaTheme.swift` + `ColorTokens.swift` — semantic colors with fruit-tier mappings |
| Haptics | `HapticManager` singleton with CoreHaptics engine — per-event feedback |
| Animation | Spring presets + PhaseAnimator + particles for merge effects |
| Error handling | `ErrorState` enum with user-facing recovery messages |
| Navigation | `NavigationRouter` with `@Observable` state management |

### Data Flow

```
User Tap → SwiftUI captures gesture
         → SpriteKit spawns fruit at position
         → Physics simulation runs (gravity, collision)
         → Contact detected between matching fruits
         → Merge triggered → ParticleAnimations + FruitGlow
         → HapticManager fires tactile feedback
         → Score updated + combo check
         → ComboPopup shown if chain
         → SwiftUI state refreshes
         → ScoreHistoryChart updates on game over
```

## ♿ Accessibility

SuikaDrop is designed to be playable by everyone:

| Feature | Implementation |
|---------|---------------|
| **VoiceOver** | Every fruit announces type and position; combo/score changes announced |
| **Dynamic Type** | All text scales with user font size preference |
| **Reduced Motion** | Animations replaced with simple fades when enabled |
| **Haptics** | Tactile feedback on drop, merge, combo, and game over |
| **Adaptive Layout** | UI scales from iPhone SE to Pro Max |

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI Framework | SwiftUI (iOS 17+) |
| Physics Engine | SpriteKit |
| Haptics | CoreHaptics |
| Hints | TipKit |
| Animations | PhaseAnimator, Spring, MeshGradient, Particles |
| Dependencies | None — pure Apple frameworks |

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [Architecture Overview](docs/ARCHITECTURE.md) | System design, layer responsibilities, data flow |
| [Getting Started](docs/GETTING-STARTED.md) | Setup, development workflow, adding views, testing accessibility |

## License

Private
