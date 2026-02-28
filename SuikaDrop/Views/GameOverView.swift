// GameOverView.swift — Animated game-over overlay with staggered score reveal
// Uses spring animations and PhaseAnimator for polished end-game UX

import SwiftUI

/// Full-screen game-over overlay with staggered score reveal animation.
/// Score digits count up, best score comparison fades in, and action buttons slide up.
struct GameOverView: View {
    let finalScore: Int
    let bestScore: Int
    let isNewBest: Bool
    let onRestart: () -> Void
    let onHome: () -> Void

    @State private var showScore = false
    @State private var showBest = false
    @State private var showButtons = false
    @State private var displayedScore: Int = 0

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Game Over title
                gameOverTitle

                // Score reveal
                scoreSection

                // Best score comparison
                bestScoreSection

                Spacer()

                // Action buttons
                actionButtons
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
        .onAppear { animateSequence() }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var gameOverTitle: some View {
        Text("GAME OVER")
            .font(.system(size: 36, weight: .black, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [.white, .white.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .opacity(showScore ? 1 : 0)
            .scaleEffect(showScore ? 1 : 0.5)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showScore)
    }

    @ViewBuilder
    private var scoreSection: some View {
        VStack(spacing: 8) {
            Text("SCORE")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
                .tracking(4)

            Text("\(displayedScore)")
                .font(.system(size: 64, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .contentTransition(.numericText(value: Double(displayedScore)))
                .monospacedDigit()

            if isNewBest {
                newBestBadge
            }
        }
        .opacity(showScore ? 1 : 0)
        .offset(y: showScore ? 0 : 20)
        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2), value: showScore)
    }

    @ViewBuilder
    private var newBestBadge: some View {
        Text("🎉 NEW BEST!")
            .font(.system(size: 16, weight: .heavy, design: .rounded))
            .foregroundStyle(.yellow)
            .phaseAnimator([false, true]) { content, phase in
                content
                    .scaleEffect(phase ? 1.1 : 1.0)
                    .brightness(phase ? 0.2 : 0)
            } animation: { _ in
                .bouncy(duration: 0.8, extraBounce: 0.4)
            }
    }

    @ViewBuilder
    private var bestScoreSection: some View {
        HStack(spacing: 4) {
            Image(systemName: "trophy.fill")
                .foregroundStyle(.yellow.opacity(0.7))
            Text("Best: \(bestScore)")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
        }
        .opacity(showBest ? 1 : 0)
        .animation(.easeOut(duration: 0.4), value: showBest)
    }

    @ViewBuilder
    private var actionButtons: some View {
        VStack(spacing: 14) {
            Button(action: onRestart) {
                Label("Play Again", systemImage: "arrow.counterclockwise")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.orange)
                    )
                    .foregroundStyle(.white)
            }

            Button(action: onHome) {
                Text("Home")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .opacity(showButtons ? 1 : 0)
        .offset(y: showButtons ? 0 : 30)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showButtons)
    }

    // MARK: - Animation Sequence

    private func animateSequence() {
        // Step 1: Show title + score area
        withAnimation { showScore = true }

        // Step 2: Count up score digits
        let steps = min(30, max(10, finalScore / 10))
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 + Double(i) * 0.02) {
                withAnimation(.snappy) {
                    displayedScore = Int(Double(finalScore) * Double(i) / Double(steps))
                }
            }
        }
        // Ensure final value
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 + Double(steps) * 0.02 + 0.05) {
            withAnimation(.snappy) { displayedScore = finalScore }
        }

        // Step 3: Show best score
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showBest = true
        }

        // Step 4: Show buttons
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showButtons = true
        }
    }
}

#Preview {
    GameOverView(
        finalScore: 12450,
        bestScore: 10200,
        isNewBest: true,
        onRestart: {},
        onHome: {}
    )
}
