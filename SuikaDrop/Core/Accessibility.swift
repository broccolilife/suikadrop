// Accessibility.swift — Accessibility Utilities & View Modifiers
// From Pixel knowledge: every interactive element needs accessibilityLabel,
// accessibilityAction for custom gestures, Dynamic Type support

import SwiftUI

// MARK: - Accessibility Helpers

extension View {
    /// Annotation modifier (from Ice pattern) with accessibility support
    func annotation(_ text: String) -> some View {
        modifier(AnnotationModifier(text: text))
    }
    
    /// Semantic card grouping with accessibility
    func accessibleCard(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
    }
    
    /// Dynamic Type scaled padding
    func scaledPadding(_ edges: Edge.Set = .all, _ length: CGFloat = DesignTokens.Spacing.md) -> some View {
        self.padding(edges, length)
    }
}

// MARK: - Annotation Modifier (from Ice repo pattern)

struct AnnotationModifier: ViewModifier {
    let text: String
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            content
            Text(text)
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(.secondary)
                .accessibilityLabel(text)
        }
    }
}

// MARK: - Reusable Section Pattern (from Ice/CodeEdit)

struct AppSection<Content: View>: View {
    let title: String?
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            if let title {
                Text(title)
                    .font(DesignTokens.Typography.headline)
                    .foregroundStyle(.secondary)
                    .accessibilityAddTraits(.isHeader)
            }
            content()
        }
        .padding(DesignTokens.Spacing.md)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
    }
}

// MARK: - Haptic Feedback

enum HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
