// GameOverOverlay.swift — Animated game over screen with score breakdown
// Slides in with a dramatic blur, shows stats, offers retry

import SwiftUI

/// Full-screen game over overlay with score summary and retry action.
struct GameOverOverlay: View {
    let score: Int
    let highScore: Int
    let maxCombo: Int
    let fruitsDropped: Int
    let onRetry: () -> Void
    let onHome: () -> Void

    @State private var showContent = false
    @State private var countedScore: Int = 0
    @State private var showButtons = false

    private var isNewHighScore: Bool { score >= highScore && score > 0 }

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(showContent ? 0.7 : 0)
                .ignoresSafeArea()
                .animation(.easeIn(duration: 0.4), value: showContent)

            VStack(spacing: DesignTokens.Spacing.lg) {
                Spacer()

                // Game Over Title
                Text("GAME OVER")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .tracking(4)
                    .scaleEffect(showContent ? 1 : 0.5)
                    .opacity(showContent ? 1 : 0)

                // New high score badge
                if isNewHighScore {
                    Label("NEW HIGH SCORE", systemImage: "crown.fill")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(.yellow)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(.yellow.opacity(0.15))
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.yellow.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .transition(.scale.combined(with: .opacity))
                }

                // Score display
                Text("\(countedScore)")
                    .font(.system(size: 64, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: isNewHighScore ? [.yellow, .orange] : [.white, .white.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .contentTransition(.numericText())
                    .monospacedDigit()

                // Stats row
                HStack(spacing: DesignTokens.Spacing.xl) {
                    statItem(icon: "flame.fill", label: "Max Combo", value: "\(maxCombo)×", color: .orange)
                    statItem(icon: "circle.circle.fill", label: "Fruits", value: "\(fruitsDropped)", color: .green)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                Spacer()

                // Action buttons
                VStack(spacing: 12) {
                    Button(action: onRetry) {
                        Label("Play Again", systemImage: "arrow.counterclockwise")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                                    .fill(.white)
                            )
                            .foregroundStyle(.black)
                    }

                    Button(action: onHome) {
                        Text("Home")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)
                .opacity(showButtons ? 1 : 0)
                .offset(y: showButtons ? 0 : 30)

                Spacer()
                    .frame(height: 40)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showContent = true
            }

            // Animate score counting
            animateScoreCount()

            withAnimation(.easeOut(duration: 0.4).delay(1.2)) {
                showButtons = true
            }
        }
    }

    private func animateScoreCount() {
        let steps = min(score, 40)
        guard steps > 0 else { return }
        let interval = 0.8 / Double(steps)

        for i in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 + interval * Double(i)) {
                withAnimation(.easeOut(duration: 0.05)) {
                    countedScore = Int(Double(score) * Double(i) / Double(steps))
                }
            }
        }
    }

    private func statItem(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)

            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
        }
    }
}

#Preview {
    GameOverOverlay(
        score: 12450,
        highScore: 10000,
        maxCombo: 5,
        fruitsDropped: 87,
        onRetry: {},
        onHome: {}
    )
}
