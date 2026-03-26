// NextFruitPreview.swift — Shows the next fruit to drop with a gentle bob animation
// Provides visual anticipation and helps players plan their next move

import SwiftUI

/// Compact preview showing the next fruit that will drop.
/// Displays in the top corner with a gentle floating animation.
struct NextFruitPreview: View {
    let fruitIndex: Int
    let fruitColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink,
        .mint, .cyan, .indigo, .brown
    ]

    @State private var bobOffset: CGFloat = 0

    private var fruitColor: Color {
        fruitColors[fruitIndex % fruitColors.count]
    }

    private var fruitSize: CGFloat {
        // Smaller fruits for lower indices
        CGFloat(18 + min(fruitIndex, 6) * 4)
    }

    var body: some View {
        VStack(spacing: 6) {
            Text("NEXT")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
                .tracking(2)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            fruitColor.opacity(0.9),
                            fruitColor
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: fruitSize
                    )
                )
                .frame(width: fruitSize, height: fruitSize)
                .shadow(color: fruitColor.opacity(0.4), radius: 6, y: 2)
                .offset(y: bobOffset)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
        )
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
            ) {
                bobOffset = -4
            }
        }
        .onChange(of: fruitIndex) { _, _ in
            // Quick scale bump on fruit change
            bobOffset = 0
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                bobOffset = -6
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(
                    .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
                ) {
                    bobOffset = -4
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Next fruit: size \(fruitIndex + 1)")
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HStack {
            Spacer()
            VStack {
                NextFruitPreview(fruitIndex: 2)
                Spacer()
            }
            .padding(.top, 60)
            .padding(.trailing, 16)
        }
    }
}
