# Getting Started — SuikaDrop

## Prerequisites

| Requirement | Version |
|-------------|---------|
| Xcode | 16+ |
| iOS target | 17.0+ (18.0+ for full effects) |
| macOS | Sonoma 14.0+ |
| Swift | 5.9+ |

## Setup

```bash
# Clone the repo
git clone https://github.com/broccolilife/suikadrop.git
cd suikadrop

# Open in Xcode
open SuikaDrop.xcodeproj
```

No package resolution needed — there are zero external dependencies.

## Running

1. Select a simulator (iPhone 15 Pro recommended) or connected device
2. **⌘R** to build and run
3. The game launches directly into the play screen

## Project Structure

```
suikadrop/
├── SuikaDrop/
│   ├── Core/           # Design tokens, theme, accessibility, animations
│   └── Views/          # SwiftUI view components
├── SuikaDrop.xcodeproj
└── README.md
```

## Development Workflow

### Modifying the Design System

All visual constants live in `SuikaDrop/Core/DesignTokens.swift`. To change spacing, sizing, or timing:

```swift
// DesignTokens.swift
enum SDSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    // ...
}
```

### Adding a New View

1. Create the file in `SuikaDrop/Views/`
2. Import design tokens: use `SDSpacing`, `SuikaTheme` colors, `SDTypography`
3. Add VoiceOver labels via the `Accessibility` helpers
4. Respect reduced motion via `ReducedMotion` checks

### Testing Accessibility

1. Enable VoiceOver in Simulator: **Settings → Accessibility → VoiceOver**
2. Enable Dynamic Type: **Settings → Accessibility → Display & Text Size → Larger Text**
3. Enable Reduce Motion: **Settings → Accessibility → Motion → Reduce Motion**

## Common Issues

| Issue | Solution |
|-------|---------|
| MeshGradient not rendering | Requires iOS 18+. Falls back to solid gradient on iOS 17. |
| Physics feel off | Tune constants in `DesignTokens.swift` |
| No haptics in simulator | Haptics only work on physical devices |

## Next Steps

- Read [ARCHITECTURE.md](ARCHITECTURE.md) for system design details
- Check the main [README](../README.md) for feature overview
