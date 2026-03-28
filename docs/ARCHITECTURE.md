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

### Views Layer (`SuikaDrop/Views/`)

SwiftUI views composed from Core tokens. Each view is a focused, single-responsibility component.

- `NextFruitPreview.swift` — Compact animated preview showing the next fruit, with a gentle bob animation and size/color based on fruit tier.

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
