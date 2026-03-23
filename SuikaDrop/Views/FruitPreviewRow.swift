// FruitPreviewRow.swift — Next-fruit queue display with merge preview
// Pixel (Eva) — 2026-03-23

import SwiftUI

/// Displays the upcoming fruit queue with animated transitions
struct FruitPreviewRow: View {
    let nextFruits: [FruitKind]
    let currentScore: Int
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            scoreLabel
            Spacer()
            nextFruitQueue
        }
        .padding(.horizontal, DesignTokens.Spacing.md)
        .padding(.vertical, DesignTokens.Spacing.sm)
        .background(.ultraThinMaterial, in: Capsule())
    }
    
    @ViewBuilder
    private var scoreLabel: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            Text("\(currentScore)")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .contentTransition(.numericText(value: Double(currentScore)))
                .animation(.snappy, value: currentScore)
        }
    }
    
    @ViewBuilder
    private var nextFruitQueue: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            Text("Next")
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
            
            ForEach(Array(nextFruits.prefix(3).enumerated()), id: \.offset) { index, fruit in
                Circle()
                    .fill(fruit.color)
                    .frame(width: fruitSize(at: index), height: fruitSize(at: index))
                    .shadow(color: fruit.color.opacity(0.4), radius: 3, y: 1)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(SpringPreset.snappy, value: nextFruits.map(\.rawValue))
    }
    
    private func fruitSize(at index: Int) -> CGFloat {
        switch index {
        case 0: return 28
        case 1: return 22
        default: return 16
        }
    }
}

// MARK: - Fruit Kind

/// Represents the different fruit types in Suika Drop
enum FruitKind: String, CaseIterable, Identifiable {
    case cherry, strawberry, grape, orange, apple
    case pear, peach, pineapple, melon, watermelon
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .cherry:      return SuikaTheme.cherry
        case .strawberry:  return SuikaTheme.strawberry
        case .grape:       return SuikaTheme.grape
        case .orange:      return SuikaTheme.orange
        case .apple:       return SuikaTheme.apple
        case .pear:        return SuikaTheme.pear
        case .peach:       return SuikaTheme.peach
        case .pineapple:   return SuikaTheme.pineapple
        case .melon:       return SuikaTheme.melon
        case .watermelon:  return SuikaTheme.watermelon
        }
    }
    
    var displayName: String { rawValue.capitalized }
    
    /// Size multiplier relative to base fruit radius
    var sizeMultiplier: CGFloat {
        CGFloat(Self.allCases.firstIndex(of: self)! + 1) * 0.15 + 0.5
    }
}

#Preview {
    FruitPreviewRow(
        nextFruits: [.cherry, .grape, .orange],
        currentScore: 420
    )
    .padding()
}
