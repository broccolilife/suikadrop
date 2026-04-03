# Architecture Overview — SuikaDrop

## Overview

SuikaDrop is a Suika Game (watermelon game) clone for iOS built with **SwiftUI** for the UI layer and **SpriteKit** for physics simulation. The architecture is split into a shared Core foundation and thin, composable Views — with the physics engine running as a separate SpriteKit scene embedded in SwiftUI.

## System Diagram

```
┌──────────────────────────────────────────────────────────┐
│                     USER INTERACTION                     │
│                  Tap to drop · View scores               │
├──────────────────────────────────────────────────────────┤
│                     SwiftUI VIEWS                        │
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │NextFruitPre- │  │ GameOver     │  │ ScoreHistory  │  │
│  │view          │  │ Overlay      │  │ Chart         │  │
│  └──────┬───────┘  └──────┬───────┘  └───────┬───────┘  │
│         │                 │                   │          │
│  ┌──────┴─────────────────┴───────────────────┘          │
│  │              ComboPopup                               │
│  └───────────────────────────────────────────────────────│
├──────────────────────────────────────────────────────────┤
│                   SPRITEKIT SCENE                        │
│                                                          │
│  Physics World ←→ Contact Delegate ←→ Merge Logic       │
│       ↕                                    ↕             │
│  Gravity/Bounds              Score + Combo Tracking      │
├──────────────────────────────────────────────────────────┤
│                     CORE LAYER                           │
│                                                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │
│  │ Design      │  │ Animation   │  │ Accessibility   │  │
│  │ Tokens      │  │ System      │  │ System          │  │
│  │             │  │             │  │                 │  │
│  │DesignTokens │  │Spring       │  │Accessibility    │  │
│  │SuikaTheme   │  │Phase        │  │ReducedMotion    │  │
│  │ColorTokens  │  │Particle     │  │HapticManager    │  │
│  │Typography   │  │FruitGlow    │  │AdaptiveLayout   │  │
│  │             │  │MeshBg       │  │ContextualTips   │  │
│  └─────────────┘  └─────────────┘  └─────────────────┘  │
│                                                          │
│  ┌─────────────┐  ┌─────────────┐                        │
│  │ Navigation  │  │ Error       │                        │
│  │ Router      │  │ State       │                        │
│  └─────────────┘  └─────────────┘                        │
└──────────────────────────────────────────────────────────┘
```

## Layer Responsibilities

### Core Layer (`SuikaDrop/Core/` — 16 files)

The foundation everything builds on. All UI decisions flow through centralized tokens.

#### Design System

| File | Purpose |
|------|---------|
| `DesignTokens.swift` | Spacing (`xs`–`xxl`), corner radii, timing — single source of truth for layout constants |
| `SuikaTheme.swift` | Semantic color palette (background, accent, fruit tiers). Supports future theme variants |
| `ColorTokens.swift` | Extended color definitions including per-fruit-tier color mappings |
| `Typography.swift` | Font system that respects Dynamic Type for full accessibility |

#### Animation System

| File | Purpose |
|------|---------|
| `SpringAnimations.swift` | Named spring presets: bouncy, snappy, gentle — used across all animated views |
| `PhaseAnimations.swift` | Multi-phase animations for merge effects using PhaseAnimator (iOS 17+) |
| `ParticleAnimations.swift` | Particle burst effects for merge celebrations and combo streaks |
| `FruitGlowModifier.swift` | `ViewModifier` that adds a pulsing glow effect during fruit merges |
| `MeshBackground.swift` | MeshGradient background (iOS 18+) with graceful fallback to solid gradient |

#### Accessibility System

| File | Purpose |
|------|---------|
| `Accessibility.swift` | VoiceOver helper functions, semantic grouping, accessibility labels |
| `ReducedMotion.swift` | Detects and respects the Reduce Motion accessibility setting |
| `HapticManager.swift` | `@Observable` singleton wrapping CoreHaptics — provides `fruitDropped()`, `fruitMerged()`, `comboHit()`, `gameOver()` |
| `AdaptiveLayout.swift` | Screen-size adaptation for iPhone SE through Pro Max |
| `ContextualTips.swift` | TipKit-based contextual hints shown to new players |

#### Infrastructure

| File | Purpose |
|------|---------|
| `NavigationRouter.swift` | Centralized `@Observable` navigation state management |
| `ErrorState.swift` | Enum-driven errors with user-facing recovery suggestions |

### Views Layer (`SuikaDrop/Views/` — 4 files)

Thin SwiftUI views composed entirely from Core tokens. Each is focused and single-responsibility.

| View | Purpose |
|------|---------|
| `NextFruitPreview.swift` | Animated preview of the next fruit with bob animation, sized and colored by tier using `ColorTokens` |
| `GameOverOverlay.swift` | Game over screen showing final score, high score comparison, and replay button |
| `ComboPopup.swift` | Animated popup showing combo multiplier during chain merges with particle effects |
| `ScoreHistoryChart.swift` | Lightweight bar chart of recent game scores with animated reveal. Supports Dynamic Type and reduced motion |

### Physics Layer (SpriteKit)

The game scene uses SpriteKit for:
- **Gravity simulation** — realistic fruit falling physics
- **Collision detection** — `SKPhysicsContactDelegate` triggers merge logic
- **Fruit spawning** — creates physics bodies at tap location
- **Container boundaries** — invisible walls prevent fruit escape
- **Merge logic** — when matching fruits collide, replaces both with next tier

## Game State Flow

```
                    ┌──────────┐
                    │  READY   │
                    │(showing  │
                    │next fruit│
                    └────┬─────┘
                         │ User taps
                         ▼
                    ┌──────────┐
                    │ DROPPING │
                    │(physics  │
                    │ active)  │
                    └────┬─────┘
                         │ Fruit lands / contacts
                         ▼
              ┌─────────────────────┐
              │   CONTACT CHECK     │
              │ Matching fruit?     │
              └──┬──────────────┬───┘
                 │ Yes          │ No
                 ▼              ▼
           ┌──────────┐  ┌──────────┐
           │  MERGE   │  │  SETTLE  │
           │+ combo   │  │(wait for │
           │+ score   │  │ physics) │
           │+ effects │  └────┬─────┘
           └────┬─────┘       │
                │             │
                ▼             ▼
           ┌──────────────────────┐
           │   OVERFLOW CHECK     │
           │ Fruits above line?   │
           └──┬───────────────┬───┘
              │ Yes           │ No
              ▼               ▼
        ┌──────────┐    ┌──────────┐
        │GAME OVER │    │  READY   │
        │(overlay) │    │(next     │
        │          │    │ fruit)   │
        └──────────┘    └──────────┘
```

## Haptic Feedback Map

| Game Event | Haptic Type | Implementation |
|-----------|-------------|----------------|
| Fruit dropped | Light impact | `UIImpactFeedbackGenerator(.light)` |
| Fruits merged | Medium impact | `UIImpactFeedbackGenerator(.medium)` |
| Combo streak | Custom pattern | `CHHapticPattern` with increasing intensity |
| Game over | Heavy notification | `UINotificationFeedbackGenerator(.error)` |

## Accessibility Strategy

1. **VoiceOver** — every fruit announces its type and relative position. Score changes and combos are announced via `UIAccessibility.post(notification:)`.
2. **Dynamic Type** — all text (scores, tips, overlays) scales with user font size preference using `Typography.swift`.
3. **Reduced Motion** — when enabled, spring/phase/particle animations are replaced with simple opacity fades.
4. **Haptics** — tactile feedback provides non-visual game state cues. Gracefully disabled on unsupported hardware.
5. **Adaptive Layout** — `AdaptiveLayout.swift` adjusts spacing and sizing for all iPhone screen sizes.

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| SpriteKit for physics | Native Apple framework, excellent performance for 2D physics, no third-party dependency |
| Token-based design system | Single source of truth eliminates inconsistency, makes theming trivial |
| `@Observable` over `ObservableObject` | Modern Swift Observation framework, less boilerplate, better performance |
| CoreHaptics over UIFeedbackGenerator | Supports custom haptic patterns for combo streaks, not just preset taps |
| Zero dependencies | Simplifies builds, eliminates supply chain risk, leverages Apple's optimized frameworks |

## Future Considerations

- **Multiple themes** — ocean, space, candy (hot-swap via `SuikaTheme`)
- **Game Center** — leaderboards and achievements
- **Per-tier haptic patterns** — unique feel for each fruit tier
- **Home Screen widget** — daily challenge prompt
- **iCloud sync** — score history across devices
- **iPad support** — adaptive layout already in place, needs larger container sizing
