// ComboPopup.swift — Animated combo multiplier popup
// Shows a satisfying popup when fruits merge in quick succession

import SwiftUI

/// Floating combo indicator that appears on consecutive merges.
/// Scales up with spring, floats upward, then fades out.
struct ComboPopup: View {
    let comboCount: Int
    let position: CGPoint
    var onComplete: (() -> Void)?

    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 1.0
    @State private var yOffset: CGFloat = 0

    private var comboText: String {
        switch comboCount {
        case 2: return "NICE!"
        case 3: return "GREAT!"
        case 4: return "AMAZING!"
        case 5...: return "LEGENDARY!"
        default: return "×\(comboCount)"
        }
    }

    private var comboColor: Color {
        switch comboCount {
        case 2: return .yellow
        case 3: return .orange
        case 4: return .pink
        case 5...: return .purple
        default: return .white
        }
    }

    private var fontSize: CGFloat {
        min(CGFloat(18 + comboCount * 4), 36)
    }

    var body: some View {
        VStack(spacing: 2) {
            Text(comboText)
                .font(.system(size: fontSize, weight: .black, design: .rounded))
                .foregroundStyle(
                    comboColor.gradient
                )

            Text("×\(comboCount) COMBO")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
                .tracking(2)
        }
        .shadow(color: comboColor.opacity(0.6), radius: 12, y: 0)
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
        .scaleEffect(scale)
        .opacity(opacity)
        .offset(y: yOffset)
        .position(position)
        .allowsHitTesting(false)
        .onAppear {
            // Phase 1: Spring in
            withAnimation(.spring(response: 0.25, dampingFraction: 0.5, blendDuration: 0)) {
                scale = 1.2
            }

            // Phase 2: Settle
            withAnimation(.spring(response: 0.15, dampingFraction: 0.8).delay(0.2)) {
                scale = 1.0
            }

            // Phase 3: Float up and fade
            withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
                yOffset = -60
                opacity = 0
            }

            // Cleanup
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onComplete?()
            }
        }
        .accessibilityLabel("\(comboCount) combo")
    }
}

// MARK: - Combo Popup Container

/// Manages multiple combo popups, handling their lifecycle.
struct ComboPopupContainer: View {
    let combos: [ComboEvent]
    var onDismiss: ((UUID) -> Void)?

    var body: some View {
        ZStack {
            ForEach(combos) { combo in
                ComboPopup(
                    comboCount: combo.count,
                    position: combo.position
                ) {
                    onDismiss?(combo.id)
                }
            }
        }
    }
}

struct ComboEvent: Identifiable {
    let id = UUID()
    let count: Int
    let position: CGPoint
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 40) {
            ComboPopup(comboCount: 2, position: CGPoint(x: 200, y: 100))
            ComboPopup(comboCount: 3, position: CGPoint(x: 200, y: 200))
            ComboPopup(comboCount: 5, position: CGPoint(x: 200, y: 300))
        }
    }
}
