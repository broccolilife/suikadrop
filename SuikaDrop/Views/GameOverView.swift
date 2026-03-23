// GameOverView.swift — Game over overlay with score + replay
// Pixel (Eva) — 2026-03-23

import SwiftUI

struct GameOverView: View {
    let score: Int
    let highScore: Int
    let onReplay: () -> Void
    let onHome: () -> Void
    
    @State private var appeared = false
    @State private var scoreCountUp = 0
    
    private var isNewHighScore: Bool { score >= highScore && score > 0 }
    
    var body: some View {
        ZStack {
            // Dimmed backdrop
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture {} // absorb taps
            
            VStack(spacing: DesignTokens.Spacing.lg) {
                gameOverHeader
                scoreSection
                actionButtons
            }
            .padding(DesignTokens.Spacing.xl)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
            .padding(.horizontal, DesignTokens.Spacing.xl)
            .scaleEffect(appeared ? 1.0 : 0.7)
            .opacity(appeared ? 1.0 : 0)
        }
        .onAppear {
            withAnimation(SpringPreset.bouncy) {
                appeared = true
            }
            animateScoreCountUp()
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var gameOverHeader: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            Text("Game Over")
                .font(AppTypography.largeTitle)
                .fontWeight(.bold)
            
            if isNewHighScore {
                Text("🎉 New High Score!")
                    .font(AppTypography.callout)
                    .foregroundStyle(SuikaTheme.orange)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    @ViewBuilder
    private var scoreSection: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            Text("\(scoreCountUp)")
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundStyle(isNewHighScore ? SuikaTheme.orange : .primary)
                .contentTransition(.numericText(value: Double(scoreCountUp)))
            
            if !isNewHighScore {
                HStack(spacing: DesignTokens.Spacing.xs) {
                    Image(systemName: "trophy.fill")
                        .foregroundStyle(.yellow)
                    Text("Best: \(highScore)")
                        .font(AppTypography.body)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    @ViewBuilder
    private var actionButtons: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            Button(action: onReplay) {
                Label("Play Again", systemImage: "arrow.counterclockwise")
                    .font(AppTypography.cardTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignTokens.Spacing.sm)
            }
            .buttonStyle(.borderedProminent)
            .tint(SuikaTheme.watermelon)
            
            Button(action: onHome) {
                Label("Home", systemImage: "house")
                    .font(AppTypography.body)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignTokens.Spacing.xs)
            }
            .buttonStyle(.bordered)
        }
    }
    
    // MARK: - Animation
    
    private func animateScoreCountUp() {
        let steps = min(score, 30)
        guard steps > 0 else { return }
        for i in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.03) {
                withAnimation(.snappy) {
                    scoreCountUp = score * i / steps
                }
            }
        }
    }
}

#Preview {
    GameOverView(score: 1250, highScore: 800, onReplay: {}, onHome: {})
}
