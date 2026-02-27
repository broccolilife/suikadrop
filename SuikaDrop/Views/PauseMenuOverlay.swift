// PauseMenuOverlay.swift — Glass-style pause menu for SuikaDrop
// Applies translucent material background with spring animations

import SwiftUI

/// Full-screen pause menu overlay with glass-effect buttons.
/// Slides in with a spring animation when the game is paused.
struct PauseMenuOverlay: View {
    @Binding var isPaused: Bool
    var onResume: () -> Void
    var onRestart: () -> Void
    var onQuit: () -> Void

    @State private var buttonsVisible = false

    var body: some View {
        ZStack {
            // Dimmed backdrop
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { resume() }

            // Glass card
            VStack(spacing: 24) {
                pauseTitle
                menuButtons
            }
            .padding(32)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
            .padding(.horizontal, 40)
            .scaleEffect(buttonsVisible ? 1 : 0.8)
            .opacity(buttonsVisible ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                buttonsVisible = true
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Pause menu")
    }

    // MARK: - Subviews

    @ViewBuilder
    private var pauseTitle: some View {
        VStack(spacing: 8) {
            Image(systemName: "pause.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.9))
                .symbolEffect(.pulse, options: .repeating)

            Text("PAUSED")
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundStyle(.white)
        }
    }

    @ViewBuilder
    private var menuButtons: some View {
        VStack(spacing: 12) {
            PauseButton(title: "Resume", icon: "play.fill", style: .primary) {
                resume()
            }
            PauseButton(title: "Restart", icon: "arrow.counterclockwise", style: .secondary) {
                onRestart()
            }
            PauseButton(title: "Quit", icon: "xmark", style: .destructive) {
                onQuit()
            }
        }
    }

    private func resume() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
            buttonsVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isPaused = false
            onResume()
        }
    }
}

// MARK: - Pause Button

struct PauseButton: View {
    let title: String
    let icon: String
    let style: ButtonStyle
    let action: () -> Void

    enum ButtonStyle {
        case primary, secondary, destructive

        var background: Color {
            switch self {
            case .primary: .white
            case .secondary: .white.opacity(0.15)
            case .destructive: .red.opacity(0.2)
            }
        }

        var foreground: Color {
            switch self {
            case .primary: .black
            case .secondary: .white
            case .destructive: .red
            }
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                Text(title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(style.background, in: RoundedRectangle(cornerRadius: 14))
            .foregroundStyle(style.foreground)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.indigo, .purple], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        PauseMenuOverlay(
            isPaused: .constant(true),
            onResume: {},
            onRestart: {},
            onQuit: {}
        )
    }
}
