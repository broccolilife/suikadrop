// AnimationChoreography.swift — Coordinated multi-element animation sequences
// Pixel+Muse — orchestrated motion for polished game feel

import SwiftUI

// MARK: - Staggered Group Animation

struct StaggeredGroup<Content: View>: View {
    let count: Int
    let baseDelay: Double
    let spring: Animation
    @ViewBuilder let content: (Int) -> Content
    
    @State private var appeared = false
    
    init(
        count: Int,
        baseDelay: Double = 0.06,
        spring: Animation = .spring(response: 0.35, dampingFraction: 0.7),
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self.count = count
        self.baseDelay = baseDelay
        self.spring = spring
        self.content = content
    }
    
    var body: some View {
        ForEach(0..<count, id: \.self) { index in
            content(index)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
                .animation(spring.delay(Double(index) * baseDelay), value: appeared)
        }
        .onAppear { appeared = true }
    }
}

// MARK: - Score Celebration Choreography

struct ScoreCelebration: View {
    let points: Int
    let position: CGPoint
    
    @State private var phase: CelebrationPhase = .initial
    
    enum CelebrationPhase {
        case initial, pop, float, fade
    }
    
    var body: some View {
        Text("+\(points)")
            .font(.system(.title2, design: .rounded, weight: .bold))
            .foregroundStyle(.orange.gradient)
            .scaleEffect(scaleForPhase)
            .offset(y: offsetForPhase)
            .opacity(opacityForPhase)
            .position(position)
            .onAppear { runSequence() }
    }
    
    private var scaleForPhase: Double {
        switch phase {
        case .initial: 0.3
        case .pop: 1.3
        case .float: 1.0
        case .fade: 0.8
        }
    }
    
    private var offsetForPhase: Double {
        switch phase {
        case .initial, .pop: 0
        case .float: -30
        case .fade: -60
        }
    }
    
    private var opacityForPhase: Double {
        phase == .fade ? 0 : 1
    }
    
    private func runSequence() {
        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) { phase = .pop }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.15)) { phase = .float }
        withAnimation(.easeOut(duration: 0.4).delay(0.5)) { phase = .fade }
    }
}

// MARK: - Game Over Curtain

struct GameOverCurtain: ViewModifier {
    let isGameOver: Bool
    @State private var step = 0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isGameOver {
                    ZStack {
                        Color.black
                            .opacity(step >= 1 ? 0.6 : 0)
                            .animation(.easeIn(duration: 0.5), value: step)
                        
                        VStack(spacing: 16) {
                            Text("Game Over")
                                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                                .foregroundStyle(.white)
                                .scaleEffect(step >= 2 ? 1 : 0.5)
                                .opacity(step >= 2 ? 1 : 0)
                            
                            Button("Play Again") {}
                                .buttonStyle(.borderedProminent)
                                .tint(.orange)
                                .scaleEffect(step >= 3 ? 1 : 0)
                                .opacity(step >= 3 ? 1 : 0)
                        }
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: step)
                    }
                    .ignoresSafeArea()
                    .onAppear {
                        step = 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { step = 2 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { step = 3 }
                    }
                }
            }
    }
}

extension View {
    func gameOverCurtain(isGameOver: Bool) -> some View {
        modifier(GameOverCurtain(isGameOver: isGameOver))
    }
}
