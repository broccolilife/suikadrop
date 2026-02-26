// AdaptiveLayout.swift — Adaptive layout utilities + Liquid Glass prep
// From Pixel knowledge: ViewThatFits (2023 web), Liquid Glass (2025-02-25)
import SwiftUI

// MARK: - ViewThatFits Wrappers

/// Adaptive stack that switches between HStack/VStack based on available space
struct AdaptiveStack<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content
    
    init(spacing: CGFloat = DesignTokens.Spacing.md, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: spacing, content: content)
            VStack(spacing: spacing, content: content)
        }
    }
}

// MARK: - Liquid Glass Prep (iOS 26+)
// When targeting iOS 26, apply glass effects to floating controls and toolbars.
// SuikaDrop: game controls (pause, restart) are ideal glass candidates.

struct GlassCard<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        content()
            .padding(DesignTokens.Spacing.md)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
    }
}

// MARK: - Phase Animator Utilities (iOS 17+)

struct PulsingModifier: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        if isActive {
            content
                .phaseAnimator([false, true]) { view, phase in
                    view
                        .scaleEffect(phase ? 1.08 : 1.0)
                        .opacity(phase ? 1.0 : 0.7)
                } animation: { _ in
                    .easeInOut(duration: 1.2)
                }
        } else {
            content
        }
    }
}

extension View {
    /// Pulsing attention effect using PhaseAnimator (iOS 17+)
    func pulsing(when active: Bool = true) -> some View {
        modifier(PulsingModifier(isActive: active))
    }
}
