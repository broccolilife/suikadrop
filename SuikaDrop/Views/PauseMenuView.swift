// PauseMenuView.swift — In-game pause overlay with glassmorphic buttons
// Animated entrance with staggered spring reveals

import SwiftUI

/// Pause menu overlay with blurred background and bouncy button entrance.
struct PauseMenuView: View {
    let currentScore: Int
    let onResume: () -> Void
    let onRestart: () -> Void
    let onHome: () -> Void

    @State private var showContent = false

    var body: some View {
        ZStack {
            backgroundDim

            VStack(spacing: DesignTokens.Spacing.lg) {
                Spacer()
                pauseIcon
                scoreDisplay
                Spacer()
                menuButtons
                Spacer()
            }
            .padding(.horizontal, DesignTokens.Spacing.xl)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showContent = true
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var backgroundDim: some View {
        Color.black.opacity(0.5)
            .background(.ultraThinMaterial)
            .ignoresSafeArea()
            .opacity(showContent ? 1 : 0)
    }

    @ViewBuilder
    private var pauseIcon: some View {
        Image(systemName: "pause.circle.fill")
            .font(.system(size: 72))
            .foregroundStyle(.white.opacity(0.9))
            .symbolEffect(.pulse, options: .repeating)
            .scaleEffect(showContent ? 1 : 0.3)
            .opacity(showContent ? 1 : 0)
    }

    @ViewBuilder
    private var scoreDisplay: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            Text("SCORE")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
                .tracking(3)

            Text("\(currentScore)")
                .font(.system(size: 48, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .monospacedDigit()
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 15)
    }

    @ViewBuilder
    private var menuButtons: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            pauseButton(
                title: "Resume",
                icon: "play.fill",
                style: .primary,
                action: onResume,
                delay: 0
            )

            pauseButton(
                title: "Restart",
                icon: "arrow.counterclockwise",
                style: .secondary,
                action: onRestart,
                delay: 0.05
            )

            pauseButton(
                title: "Home",
                icon: "house.fill",
                style: .secondary,
                action: onHome,
                delay: 0.1
            )
        }
    }

    // MARK: - Button Builder

    private enum ButtonStyle {
        case primary, secondary
    }

    private func pauseButton(
        title: String,
        icon: String,
        style: ButtonStyle,
        action: @escaping () -> Void,
        delay: Double
    ) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                        .fill(style == .primary ? AnyShapeStyle(Color.orange) : AnyShapeStyle(.ultraThinMaterial))
                )
                .foregroundStyle(.white)
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 30)
        .animation(
            .spring(response: 0.5, dampingFraction: 0.7).delay(0.15 + delay),
            value: showContent
        )
        .accessibilityLabel(title)
    }
}

#Preview {
    PauseMenuView(
        currentScore: 5280,
        onResume: {},
        onRestart: {},
        onHome: {}
    )
}
