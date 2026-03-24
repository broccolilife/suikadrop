// ScoreHUDView.swift — Floating in-game score display with combo multiplier
// Animates score changes with numericText transition and combo pulse

import SwiftUI

/// Compact floating HUD showing current score with animated transitions.
struct ScoreHUDView: View {
    let score: Int
    let comboMultiplier: Int

    @State private var scoreChanged = false

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            scoreLabel
            if comboMultiplier > 1 {
                comboBadge
            }
        }
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .padding(.vertical, DesignTokens.Spacing.sm)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
        )
        .onChange(of: score) { _, _ in
            triggerScorePulse()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Score \(score), combo times \(comboMultiplier)")
    }

    // MARK: - Score Label

    @ViewBuilder
    private var scoreLabel: some View {
        Text("\(score)")
            .font(.system(size: 24, weight: .black, design: .rounded))
            .foregroundStyle(.white)
            .monospacedDigit()
            .contentTransition(.numericText(value: Double(score)))
            .scaleEffect(scoreChanged ? 1.15 : 1.0)
            .animation(.bouncy(duration: 0.3, extraBounce: 0.4), value: scoreChanged)
    }

    // MARK: - Combo Badge

    @ViewBuilder
    private var comboBadge: some View {
        Text("×\(comboMultiplier)")
            .font(.system(size: 16, weight: .heavy, design: .rounded))
            .foregroundStyle(.yellow)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(.yellow.opacity(0.2))
            )
            .phaseAnimator([false, true]) { content, phase in
                content
                    .scaleEffect(phase ? 1.08 : 1.0)
            } animation: { _ in
                .bouncy(duration: 1.0, extraBounce: 0.3)
            }
            .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Animation

    private func triggerScorePulse() {
        scoreChanged = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            scoreChanged = false
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            ScoreHUDView(score: 12450, comboMultiplier: 3)
            Spacer()
        }
        .padding(.top, 60)
    }
}
