// AdaptiveLayout.swift — ViewThatFits + Dynamic Type helpers
// From Pixel knowledge (2/23): ViewThatFits replaces GeometryReader hacks

import SwiftUI

// MARK: - Adaptive Score Display

struct AdaptiveScoreDisplay: View {
    let score: Int
    let highScore: Int
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            // Wide layout
            HStack(spacing: DesignTokens.Spacing.lg) {
                scoreLabel("Score", value: score)
                Divider().frame(height: 24)
                scoreLabel("Best", value: highScore)
            }
            // Narrow layout
            VStack(spacing: DesignTokens.Spacing.xs) {
                scoreLabel("Score", value: score)
                scoreLabel("Best", value: highScore)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Score: \(score). High score: \(highScore)")
    }
    
    @ViewBuilder
    private func scoreLabel(_ title: String, value: Int) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(value)")
                .font(.title2.bold().monospacedDigit())
        }
    }
}

// MARK: - Adaptive Button Row

struct AdaptiveButtonRow<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: DesignTokens.Spacing.md) { content() }
            VStack(spacing: DesignTokens.Spacing.sm) { content() }
        }
    }
}
