# Getting Started — SuikaDrop

## Prerequisites

- **Xcode 16+** (download from the Mac App Store or [developer.apple.com](https://developer.apple.com/xcode/))
- **macOS Sonoma** or later recommended
- An Apple Developer account (optional — only needed for physical device testing)

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/broccolilife/suikadrop.git
cd suikadrop

# 2. Open in Xcode
open SuikaDrop.xcodeproj
```

3. Select a simulator or connected device in the Xcode toolbar
4. Press **⌘R** to build and run

That's it! No package managers, no dependencies, no configuration files.

## Project Setup Notes

| Topic | Details |
|-------|---------|
| **Dependencies** | None — pure SwiftUI + SpriteKit |
| **Package managers** | No CocoaPods, SPM, or Carthage required |
| **Simulator** | Full gameplay works on simulator |
| **Haptics** | Haptic feedback only works on physical devices |
| **iOS version** | iOS 17+ required; iOS 18+ unlocks MeshGradient backgrounds |

## Development Workflow

### Building
Standard Xcode build (⌘B). No code generation or build scripts required.

### Running on Device
1. Connect your iPhone via USB or Wi-Fi
2. Select it in the Xcode device picker
3. You may need to trust the developer certificate on the device: **Settings → General → VPN & Device Management**
4. Press **⌘R**

### Debugging
- Use Xcode's built-in debugger and console
- SpriteKit scene debugging: **Debug → View Debugging → Show SpriteKit Statistics**
- Accessibility Inspector: **Xcode → Open Developer Tool → Accessibility Inspector**

## Code Organization

The project follows a simple two-layer structure:

- **`Core/`** — Design tokens, theme, typography, animations, haptics, accessibility, errors. These are the building blocks shared across all views.
- **`Views/`** — SwiftUI views that compose the game UI. Each view uses Core tokens exclusively — no hardcoded values.

See [ARCHITECTURE.md](ARCHITECTURE.md) for the full architecture overview.

## Common Tasks

### Adding a New View
1. Create a new `.swift` file in `Views/`
2. Use `DesignTokens` for all spacing, radii, and typography
3. Use `SuikaTheme` for colors
4. Add VoiceOver labels via `Accessibility` helpers

### Modifying the Design System
Edit `Core/DesignTokens.swift` — changes propagate automatically to all views that reference the tokens.

### Testing Accessibility
1. Open **Accessibility Inspector** (Xcode → Open Developer Tool)
2. Point it at the running simulator
3. Navigate through the app — verify all elements have meaningful labels

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Build fails on Xcode 15 | Xcode 16+ is required for Swift 5.9 and PhaseAnimator |
| MeshGradient not rendering | Requires iOS 18+; falls back gracefully on iOS 17 |
| Haptics not working | Haptics only work on physical devices, not simulators |
| Simulator performance | SpriteKit physics may run slower on simulator; test on device for accurate feel |

## Tips

- Use **SpriteKit Statistics** (Debug → View Debugging → Show SpriteKit Statistics) to monitor frame rate and node count during development
- The token system means global design changes (spacing, colors) only need edits in `Core/` — all views update automatically
