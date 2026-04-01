// ComboStreakBanner.swift — Animated combo streak indicator
// Pixel (Eva) — 2026-04-01

import SwiftUI

/// Displays a combo multiplier banner when the player chains multiple merges quickly.
/// Slides in from top, pulses on increment, slides out on timeout.
struct ComboStreakBanner: View {
    let comboCount: Int
    let isActive: Bool
    
    @State private var pulseScale: CGFloat = 1.0
    
    private var comboText: String {
        switch comboCount {
        case 2: return "Double!"
        case 3: return "Triple!"
        case 4: return "Amazing!"
        default: return "\(comboCount)x Combo!"
        }
    }
    
    private var bannerGradient: LinearGradient {
        let intensity = min(Double(comboCount) / 8.0, 1.0)
        return LinearGradient(
            colors: [
                .orange.opacity(0.6 + intensity * 0.4),
                .red.opacity(0.4 + intensity * 0.6)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    var body: some View {
        if isActive && comboCount >= 2 {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Image(systemName: "flame.fill")
                    .symbolEffect(.variableColor.iterative, options: .repeating, value: comboCount)
                    .foregroundStyle(.yellow)
                
                Text(comboText)
                    .font(AppTypography.cardTitle)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                
                Text("×\(comboCount)")
                    .font(AppTypography.displayLarge)
                    .fontWeight(.black)
                    .foregroundStyle(.yellow)
                    .scaleEffect(pulseScale)
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(bannerGradient, in: Capsule())
            .shadow(color: .orange.opacity(0.3), radius: 12, y: 4)
            .transition(.move(edge: .top).combined(with: .opacity))
            .onChange(of: comboCount) {
                withAnimation(SpringPreset.bouncy) {
                    pulseScale = 1.3
                }
                withAnimation(SpringPreset.bouncy.delay(0.15)) {
                    pulseScale = 1.0
                }
            }
            .accessibilityLabel("\(comboCount) combo streak")
        }
    }
}

#Preview {
    VStack {
        ComboStreakBanner(comboCount: 3, isActive: true)
        ComboStreakBanner(comboCount: 6, isActive: true)
    }
    .padding()
    .background(Color.black)
}
