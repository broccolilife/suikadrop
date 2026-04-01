// ScorePopupView.swift — Animated floating score popup on fruit merge
// Pixel (Eva) — 2026-04-01

import SwiftUI

/// Floating "+N" score label that animates upward and fades out on merge events.
/// Usage: overlay this on the game scene, trigger via `show(points:at:)`.
struct ScorePopupView: View {
    let points: Int
    let position: CGPoint
    let mergeLevel: Int // 1=small fruit, 5=watermelon — scales visual intensity
    
    @State private var opacity: Double = 1
    @State private var offsetY: CGFloat = 0
    @State private var scale: CGFloat = 0.5
    
    private var pointColor: Color {
        switch mergeLevel {
        case 1...2: return DesignTokens.Colors.textSecondary
        case 3: return DesignTokens.Colors.primary
        case 4: return .orange
        default: return .red
        }
    }
    
    private var fontSize: Font {
        mergeLevel >= 4 ? AppTypography.displayLarge : AppTypography.cardTitle
    }
    
    var body: some View {
        Text("+\(points)")
            .font(fontSize)
            .fontWeight(.heavy)
            .foregroundStyle(pointColor)
            .shadow(color: pointColor.opacity(0.4), radius: mergeLevel >= 3 ? 8 : 2)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(y: offsetY)
            .position(position)
            .allowsHitTesting(false)
            .onAppear {
                withAnimation(SpringPreset.bouncy) {
                    scale = mergeLevel >= 4 ? 1.4 : 1.0
                }
                withAnimation(.easeOut(duration: 1.2)) {
                    offsetY = -80
                }
                withAnimation(.easeIn(duration: 0.8).delay(0.5)) {
                    opacity = 0
                }
            }
            .accessibilityLabel("Scored \(points) points")
    }
}

/// Manages a queue of score popups, auto-removing after animation completes.
@Observable
final class ScorePopupManager {
    struct Popup: Identifiable {
        let id = UUID()
        let points: Int
        let position: CGPoint
        let mergeLevel: Int
        let createdAt = Date()
    }
    
    private(set) var activePopups: [Popup] = []
    
    func show(points: Int, at position: CGPoint, mergeLevel: Int = 1) {
        let popup = Popup(points: points, position: position, mergeLevel: mergeLevel)
        activePopups.append(popup)
        
        // Auto-remove after animation duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.activePopups.removeAll { $0.id == popup.id }
        }
    }
}

/// Overlay container that renders all active score popups.
struct ScorePopupOverlay: View {
    let manager: ScorePopupManager
    
    var body: some View {
        ZStack {
            ForEach(manager.activePopups) { popup in
                ScorePopupView(
                    points: popup.points,
                    position: popup.position,
                    mergeLevel: popup.mergeLevel
                )
                .transition(.identity)
            }
        }
        .animation(.default, value: manager.activePopups.count)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ScorePopupView(points: 500, position: CGPoint(x: 200, y: 400), mergeLevel: 4)
    }
}
