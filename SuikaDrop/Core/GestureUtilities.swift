// GestureUtilities.swift — Reusable gesture patterns for SuikaDrop
// Pixel+Muse — precise touch handling with spring-based feedback

import SwiftUI

// MARK: - Long Press with Scale Feedback

struct LongPressScale: ViewModifier {
    let minimumDuration: Double
    let action: () -> Void

    @State private var pressing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(pressing ? 0.92 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: pressing)
            .onLongPressGesture(minimumDuration: minimumDuration) {
                action()
            } onPressingChanged: { isPressing in
                pressing = isPressing
            }
    }
}

// MARK: - Tap Bounce

struct TapBounce: ViewModifier {
    let action: () -> Void
    @State private var tapped = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(tapped ? 0.88 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: tapped)
            .onTapGesture {
                tapped = true
                action()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    tapped = false
                }
            }
    }
}

// MARK: - Horizontal Swipe Detector

struct SwipeAction: ViewModifier {
    let onLeft: (() -> Void)?
    let onRight: (() -> Void)?
    let threshold: CGFloat

    init(threshold: CGFloat = 50, onLeft: (() -> Void)? = nil, onRight: (() -> Void)? = nil) {
        self.threshold = threshold
        self.onLeft = onLeft
        self.onRight = onRight
    }

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: threshold)
                    .onEnded { value in
                        if value.translation.width < -threshold { onLeft?() }
                        else if value.translation.width > threshold { onRight?() }
                    }
            )
    }
}

// MARK: - View Extensions

extension View {
    func longPressScale(minimumDuration: Double = 0.3, action: @escaping () -> Void) -> some View {
        modifier(LongPressScale(minimumDuration: minimumDuration, action: action))
    }

    func tapBounce(action: @escaping () -> Void) -> some View {
        modifier(TapBounce(action: action))
    }

    func onSwipe(threshold: CGFloat = 50, left: (() -> Void)? = nil, right: (() -> Void)? = nil) -> some View {
        modifier(SwipeAction(threshold: threshold, onLeft: left, onRight: right))
    }
}
