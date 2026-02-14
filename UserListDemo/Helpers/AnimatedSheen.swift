//
//  AnimatedSheen.swift
//  The Salty Tarot
//
//  Created by Mac on 14/02/26.
//

import Foundation
import SwiftUI

// Reusable BlurView for Glass Effect
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// Subtle press feedback for glass button
struct GlassPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.985 : 1.0)
            .opacity(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.28, dampingFraction: 0.88), value: configuration.isPressed)
    }
}

struct AnimatedSheen: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let sheenWidth = max(0.28 * width, 120) // 28% of button width, min 120pt for visibility

            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.0),
                    Color.white.opacity(0.22),
                    Color.white.opacity(0.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .rotationEffect(.degrees(18))
            .frame(width: sheenWidth)
            .offset(x: animate ? width + sheenWidth : -sheenWidth)
            .blendMode(.screen)
            .onAppear {
                withAnimation(.easeInOut(duration: 2.6).delay(0.6).repeatForever(autoreverses: false)) {
                    animate = true
                }
            }
        }
        .allowsHitTesting(false)
    }
}
