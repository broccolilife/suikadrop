# Architecture Overview — SuikaDrop

## High-Level Design

SuikaDrop is a native iOS app built with **SwiftUI** for UI and **SpriteKit** for physics-based gameplay. The architecture follows a clean separation between the core design system and game-specific views.

```
┌─────────────────────────────────────────┐
│              Views Layer                 │
│  GameOverView · ComboView               │
│  AmbientParticlesView                   │
│         (SwiftUI)                       │
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

## Directory Structure

```
SuikaDrop/
├── Core/                        # Foundation layer — shared across all views
│   ├── DesignTokens.swift       # Spacing (.xs–.xl), radii, shadows
│   ├── SuikaTheme.swift         # Color palette, light/dark mode adaptation
│   ├── Typography.swift         # Font definitions with Dynamic Type support
│   ├── SpringAnimations.swift   # Reusable spring animation configurations
│   ├── HapticEngine.swift       # Impact, notification, selection haptics
│   ├── Accessibility.swift      # VoiceOver helpers, AppSection, annotation modifier
│   └── ErrorState.swift         # Enum-driven error handling
│
└── Views/                       # UI components
    ├── GameOverView.swift       # End-of-game screen with score display + restart
    ├── ComboView.swift          # Combo counter and multiplier overlay
    └── AmbientParticlesView.swift # Floating emoji particle background effect
```

## Design System

All UI is driven by a centralized **token-based design system** inspired by Ice and CodeEdit:

- **`DesignTokens.Spacing`** — Consistent padding/margin scale (`.xs` through `.xl`)
- **`DesignTokens.Typography`** — Semantic text styles with Dynamic Type
- **`DesignTokens.Radius`** — Corner radii for cards and containers
- **`SuikaTheme`** — Full color palette that adapts to light/dark mode

**No magic numbers** — every dimension, color, and font flows through the token system.

## Key Patterns

### View Decomposition
Views use `@ViewBuilder` private computed properties to keep complex layouts readable and maintainable.

### Reusable Components
- **`AppSection`** — Grouped content with optional headers (consistent across screens)
- **`.annotation("text")`** — View modifier for inline helper captions

### Physics & Gameplay
- **SpriteKit** handles all physics simulation: gravity, collision detection, fruit merging
- **Combo system** tracks merge chains and applies score multipliers
- **Haptic feedback** via `HapticEngine` for drops, merges, and combo milestones

### Accessibility
- Full **VoiceOver** support with semantic grouping
- **Dynamic Type** throughout via the Typography system
- Meaningful accessibility labels on all interactive elements

## Platform Requirements

| Requirement | Minimum |
|------------|---------|
| iOS | 17.0 (18.0 for MeshGradient) |
| Xcode | 16+ |
| Swift | 5.9+ |
| Dependencies | None (pure SwiftUI + SpriteKit) |

## Future Architecture Considerations

- Game state persistence (high scores, progress)
- GameKit integration for leaderboards
- Additional fruit types and merge rules
- Sound effects and background music system
