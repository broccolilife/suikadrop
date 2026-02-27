# Architecture Overview — SuikaDrop

## High-Level Design

SuikaDrop follows a clean two-layer architecture: a **Core** foundation layer and a **Views** presentation layer, both built on SwiftUI with SpriteKit for physics simulation.

```
┌─────────────────────────────────────┐
│           Views Layer               │
│  ComboOverlay · NewBestCelebration  │
│  (SwiftUI + PhaseAnimator)          │
├─────────────────────────────────────┤
│           Core Layer                │
│  DesignTokens · Theme · Typography  │
│  SpringAnimations · Accessibility   │
│  ErrorState                         │
├─────────────────────────────────────┤
│        SpriteKit Engine             │
│  Physics simulation · Collisions    │
│  Fruit merging · Score tracking     │
└─────────────────────────────────────┘
```

## Core Layer

### Design Token System

All visual constants are centralized in `DesignTokens.swift`:

- **Spacing** — `xs` (4pt) through `xxl` (48pt)
- **Corner Radius** — `sm` (8pt) through `pill` (999pt)
- **Typography** — Defined scale with semantic naming
- **Colors** — Theme-aware color palette via `SuikaTheme`

This prevents magic numbers and ensures visual consistency across all views.

### Error Handling

`ErrorState.swift` uses Swift enums for type-safe error states with associated recovery actions. Views can pattern-match on error types to show appropriate UI.

### Accessibility

Built-in support for:
- VoiceOver labels and hints on all interactive elements
- Dynamic Type scaling via the typography system
- Haptic feedback for merges, combos, and game events

## Views Layer

### ComboOverlay

Renders an animated combo counter during merge chains:
- Springs in with scale animation on combo start
- Floats up and fades out on completion
- During **fever mode**, continuously pulses using `PhaseAnimator` (iOS 17+)
- Font size and glow color scale with combo count

### NewBestCelebration

Triggered when the player beats their high score. Full-screen celebration with particle effects.

## Animation System

Spring animations are centralized in `SpringAnimations.swift` with presets for:
- Fruit drop and bounce
- Merge explosion
- UI element transitions
- Combo overlay entrance/exit

## iOS Version Strategy

- **iOS 17+** — Base target. PhaseAnimator for combo animations.
- **iOS 18+** — Enhanced. MeshGradient backgrounds for richer visuals.
- Graceful degradation for features unavailable on older versions.
