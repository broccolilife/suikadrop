// ViewComponents.swift — Reusable view patterns for SuikaDrop
// Pixel+Muse — annotation modifier, section pattern from iOS best practices

import SwiftUI

// MARK: - Annotation Modifier

/// Adds helper text below a control (from Ice menu bar app pattern)
struct AnnotationModifier: ViewModifier {
    let text: String
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            content
            Text(text)
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
        }
    }
}

extension View {
    /// Add annotation/helper text below this view
    func annotation(_ text: String) -> some View {
        modifier(AnnotationModifier(text: text))
    }
}

// MARK: - App Section

/// Consistent section container with optional title (from CodeEdit pattern)
struct AppSection<Content: View>: View {
    let title: String?
    @ViewBuilder let content: () -> Content
    
    init(_ title: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            if let title {
                Text(title)
                    .font(AppTypography.sectionTitle)
                    .foregroundStyle(.secondary)
            }
            content()
        }
        .padding(DesignTokens.Spacing.md)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
    }
}

// MARK: - Matched Geometry Tab Indicator

/// Animated tab indicator using matchedGeometryEffect
struct AnimatedTabIndicator: View {
    let tabs: [String]
    @Binding var selected: Int
    let namespace: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button {
                    withAnimation(SpringPreset.snappy) {
                        selected = index
                    }
                } label: {
                    Text(tab)
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(selected == index ? .primary : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignTokens.Spacing.sm)
                        .background {
                            if selected == index {
                                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                                    .fill(.thinMaterial)
                                    .matchedGeometryEffect(id: "tab", in: namespace)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(DesignTokens.Spacing.xs)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
    }
}
