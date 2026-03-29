# Architecture Overview — SuikaDrop

## System Diagram

```
┌─────────────────────────────────────────────┐
│                  SwiftUI                     │
│         Views / Navigation / State           │
├─────────────────────────────────────────────┤
│              SpriteKit Scene                 │
│     Physics World / Contact Detection        │
│         Fruit Spawning / Merging             │
├─────────────────────────────────────────────┤
│              Core Layer                      │
│  DesignTokens │ Theme │ Accessibility        │
│  Animations   │ Error │ Navigation           │
└─────────────────────────────────────────────┘
```

## Layer Responsibilities

### Core Layer (`SuikaDrop/Core/`)

The foundation everything builds on. All UI decisions flow through centralized tokens.

| File | Purpose |
|------|---------|
| `DesignTokens.swift` | Spacing, sizing, timing — the single source of truth for layout constants |
| `SuikaTheme.swift` | Color palette with semantic naming (background, accent, fruit tiers) |
| `Typography.swift` | Font system respecting Dynamic Type for accessibility |
| `Accessibility.swift` | VoiceOver helpers, semantic grouping, accessibility labels |
| `ErrorState.swift` | Enum-driven errors with user-facing recovery suggestions |
| `SpringAnimations.swift` | Reusable spring presets (bouncy, snappy, gentle) |
| `PhaseAnimations.swift` | Multi-phase animations for merge effects (iOS 17+) |
| `FruitGlowModifier.swift` | ViewModifier for the glow effect during fruit merges |
| `MeshBackground.swift` | MeshGradient background (iOS 18+, graceful fallback) |
| `ReducedMotion.swift` | Detects and respects Reduce Motion accessibility setting |
| `AdaptiveLayout.swift` | Screen-size adaptation (iPhone SE → Pro Max) |
| `ContextualTips.swift` | TipKit-based contextual hints for new players |
| `NavigationRouter.swift` | Centralized navigation state with `@Observable` |
| `ColorTokens.swift` | Extended color definitions and fruit-tier color mappings |
| `ParticleAnimations.swift` | Particle effects for merge celebrations and combos |

### Views Layer (`SuikaDrop/Views/`)

SwiftUI views composed from Core tokens. Each view is a focused, single-responsibility component.

| View | Purpose |
|------|---------|
| `NextFruitPreview.swift` | Animated preview of the next fruit with bob animation, sized/colored by tier |
| `GameOverOverlay.swift` | Game over screen with score summary and replay option |
| `ComboPopup.swift` | Animated popup showing combo multiplier during chain merges |

### Physics (SpriteKit)

The game scene uses SpriteKit for:
- Gravity and collision physics
- Contact detection for merge triggers
- Fruit spawning at tap location
- Container boundary enforcement

## Data Flow

```
User Tap → SwiftUI captures gesture
         → SpriteKit spawns fruit at position
         → Physics simulation runs
         → Contact detected between matching fruits
         → Merge animation triggered (PhaseAnimator)
         → Score updated → SwiftUI state refreshes
```

## Accessibility Strategy

1. **VoiceOver** — every fruit announces its type and position
2. **Dynamic Type** — all text scales with user font size preference
3. **Reduced Motion** — animations replaced with fades when enabled
4. **Haptics** — tactile feedback on drop and merge events

## Future Considerations

- Multiple themes (beyond fruit — ocean, space, etc.)
- Game Center leaderboards
- Haptic patterns per fruit tier
- Widget for daily challenge
