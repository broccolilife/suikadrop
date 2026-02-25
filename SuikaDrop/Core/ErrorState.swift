// ErrorState.swift — Reusable Error State Views
// From Pixel knowledge: enum-driven layouts, view decomposition, accessibility

import SwiftUI

// MARK: - App Error Model

enum AppError: LocalizedError, Equatable {
    case network(String)
    case notFound
    case unauthorized
    case generic(String)
    
    var errorDescription: String? {
        switch self {
        case .network(let msg): return msg
        case .notFound: return "Not Found"
        case .unauthorized: return "Unauthorized"
        case .generic(let msg): return msg
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .network: return "Check your connection and try again."
        case .notFound: return "The item may have been removed."
        case .unauthorized: return "Please sign in again."
        case .generic: return "Please try again later."
        }
    }
    
    var systemImage: String {
        switch self {
        case .network: return "wifi.slash"
        case .notFound: return "magnifyingglass"
        case .unauthorized: return "lock.fill"
        case .generic: return "exclamationmark.triangle.fill"
        }
    }
}

// MARK: - Error State View

struct ErrorStateView: View {
    let error: AppError
    var retryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            errorIcon
            errorText
            if let retryAction {
                retryButton(action: retryAction)
            }
        }
        .padding(DesignTokens.Spacing.xl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }
    
    // MARK: - View Decomposition (from Ice pattern)
    
    @ViewBuilder
    private var errorIcon: some View {
        Image(systemName: error.systemImage)
            .font(.system(size: 48))
            .foregroundStyle(.secondary)
            .symbolEffect(.pulse)
            .accessibilityHidden(true)
    }
    
    @ViewBuilder
    private var errorText: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            Text(error.localizedDescription)
                .font(DesignTokens.Typography.headline)
                .multilineTextAlignment(.center)
            
            if let suggestion = error.recoverySuggestion {
                Text(suggestion)
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    @ViewBuilder
    private func retryButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label("Try Again", systemImage: "arrow.clockwise")
                .font(DesignTokens.Typography.body.bold())
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.vertical, DesignTokens.Spacing.sm)
                .background(.tint, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.pill))
                .foregroundStyle(.white)
        }
        .accessibilityHint("Retries the failed action")
    }
    
    private var accessibilityDescription: String {
        var desc = "Error: \(error.localizedDescription)."
        if let suggestion = error.recoverySuggestion {
            desc += " \(suggestion)"
        }
        if retryAction != nil {
            desc += " Retry button available."
        }
        return desc
    }
}

// MARK: - Empty State View

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String
    var action: (() -> Void)?
    var actionLabel: String = "Get Started"
    
    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            Text(message)
        } actions: {
            if let action {
                Button(actionLabel, action: action)
                    .buttonStyle(.borderedProminent)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Loading State

struct LoadingStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            ProgressView()
                .scaleEffect(1.2)
            Text(message)
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading: \(message)")
    }
}
