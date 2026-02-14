//
//  ShakeModifier.swift
//  UserListDemo
//

import SwiftUI

/// Shakes the view when `trigger` increments. Use for validation feedback.
struct ShakeModifier: ViewModifier {
    var trigger: Int
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .onChange(of: trigger) { _, _ in
                let positions: [CGFloat] = [0, 6, -6, 6, -6, 6, 0]
                for (i, pos) in positions.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05 * Double(i)) {
                        withAnimation(.linear(duration: 0.05)) {
                            offset = pos
                        }
                    }
                }
            }
    }
}

extension View {
    func shake(trigger: Int) -> some View {
        modifier(ShakeModifier(trigger: trigger))
    }
}
