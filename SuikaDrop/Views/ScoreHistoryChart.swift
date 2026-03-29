// ScoreHistoryChart.swift — Visual score history with animated bar chart
// SuikaDrop

import SwiftUI

/// A lightweight bar chart showing recent game scores with animated reveal.
/// Supports Dynamic Type and reduced motion preferences.
struct ScoreHistoryChart: View {
    let scores: [Int]
    let maxVisible: Int
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var revealed = false
    
    init(scores: [Int], maxVisible: Int = 10) {
        self.scores = scores
        self.maxVisible = maxVisible
    }
    
    private var visibleScores: [Int] {
        Array(scores.suffix(maxVisible))
    }
    
    private var maxScore: Int {
        visibleScores.max() ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Label("Score History", systemImage: "chart.bar.fill")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            if visibleScores.isEmpty {
                emptyState
            } else {
                chartContent
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
        .onAppear {
            withAnimation(reduceMotion ? .none : .spring(duration: 0.6, bounce: 0.2)) {
                revealed = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Score history, \(visibleScores.count) games")
        .accessibilityValue(visibleScores.isEmpty ? "No scores yet" : "Best: \(maxScore)")
    }
    
    // MARK: - Chart Content
    
    private var chartContent: some View {
        HStack(alignment: .bottom, spacing: DesignTokens.Spacing.xs) {
            ForEach(Array(visibleScores.enumerated()), id: \.offset) { index, score in
                VStack(spacing: 2) {
                    if score == maxScore {
                        Image(systemName: "crown.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                            .transition(.scale)
                    }
                    
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                        .fill(barGradient(for: score))
                        .frame(height: revealed ? barHeight(for: score) : 4)
                        .frame(maxWidth: .infinity)
                        .animation(
                            reduceMotion ? .none : .spring(
                                duration: 0.5,
                                bounce: 0.3
                            ).delay(Double(index) * 0.05),
                            value: revealed
                        )
                }
            }
        }
        .frame(height: 120)
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: "gamecontroller")
                .font(.largeTitle)
                .foregroundStyle(.tertiary)
            Text("Play a game to see your scores!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
    }
    
    // MARK: - Helpers
    
    private func barHeight(for score: Int) -> CGFloat {
        let ratio = CGFloat(score) / CGFloat(maxScore)
        return max(8, ratio * 112)
    }
    
    private func barGradient(for score: Int) -> LinearGradient {
        let ratio = Double(score) / Double(maxScore)
        let color: Color = ratio > 0.8 ? .orange : ratio > 0.5 ? .green : .blue
        return LinearGradient(
            colors: [color.opacity(0.7), color],
            startPoint: .bottom,
            endPoint: .top
        )
    }
}

// MARK: - Preview

#Preview("Score History") {
    ScoreHistoryChart(scores: [120, 340, 250, 500, 410, 380, 620, 550, 480, 710])
        .padding()
        .background(Color(.systemGroupedBackground))
}

#Preview("Empty") {
    ScoreHistoryChart(scores: [])
        .padding()
        .background(Color(.systemGroupedBackground))
}
