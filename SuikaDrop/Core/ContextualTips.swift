// ContextualTips.swift — In-context learning hints for SuikaDrop
// NNGroup: skip onboarding, teach in context instead
// Pixel+Muse — applied from UX knowledge base

import SwiftUI

// MARK: - Tip Model

struct GameTip: Identifiable, Equatable {
    let id: String
    let message: String
    let icon: String

    static let mergeFruits = GameTip(
        id: "tip_merge",
        message: "Drop matching fruits together to merge them!",
        icon: "arrow.triangle.merge"
    )

    static let biggerFruits = GameTip(
        id: "tip_bigger",
        message: "Merged fruits grow bigger — aim for the watermelon!",
        icon: "arrow.up.circle"
    )

    static let wallBounce = GameTip(
        id: "tip_walls",
        message: "Fruits bounce off walls — use angles to your advantage",
        icon: "arrow.triangle.branch"
    )

    static let combo = GameTip(
        id: "tip_combo",
        message: "Chain merges for combo multipliers!",
        icon: "star.circle"
    )
}

// MARK: - Tip Storage

@Observable
final class TipTracker {
    private let defaults = UserDefaults.standard
    private let prefix = "tip_seen_"

    func hasSeen(_ tip: GameTip) -> Bool {
        defaults.bool(forKey: prefix + tip.id)
    }

    func markSeen(_ tip: GameTip) {
        defaults.set(true, forKey: prefix + tip.id)
    }

    func shouldShow(_ tip: GameTip) -> Bool {
        !hasSeen(tip)
    }

    func reset() {
        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix(prefix) {
            defaults.removeObject(forKey: key)
        }
    }
}

// MARK: - Tip Bubble View

struct TipBubble: View {
    let tip: GameTip
    let onDismiss: () -> Void

    @State private var isVisible = false

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: tip.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)

            Text(tip.message)
                .font(AppTypography.secondary)
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)

            Button {
                withAnimation(SpringPreset.snappy) {
                    isVisible = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onDismiss()
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(.ultraThinMaterial.opacity(0.9))
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .scaleEffect(isVisible ? 1 : 0.8)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .onAppear {
            withAnimation(SpringPreset.gentle) {
                isVisible = true
            }
        }
    }
}

// MARK: - Tip Overlay Modifier

struct ContextualTipModifier: ViewModifier {
    let tip: GameTip
    let tracker: TipTracker
    @State private var showTip = false

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if showTip {
                    TipBubble(tip: tip) {
                        tracker.markSeen(tip)
                        showTip = false
                    }
                    .padding(.bottom, DesignTokens.Spacing.xxl)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .opacity
                    ))
                }
            }
            .onAppear {
                if tracker.shouldShow(tip) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(SpringPreset.gentle) {
                            showTip = true
                        }
                    }
                }
            }
    }
}

extension View {
    func contextualTip(_ tip: GameTip, tracker: TipTracker) -> some View {
        modifier(ContextualTipModifier(tip: tip, tracker: tracker))
    }
}
