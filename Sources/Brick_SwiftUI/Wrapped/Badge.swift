//
//  Badge+.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
public extension Brick where Wrapped: View {

    @inlinable
    func badge<Label: View>(alignment: Alignment = .topTrailing,
                            anchor: UnitPoint = UnitPoint(x: 0.25, y: 0.25),
                            scale: CGFloat = 1.2,
                            @ViewBuilder label: () -> Label) -> some View {
        wrapped.modifier(
            BadgeModifier(
                alignment: alignment,
                anchor: anchor,
                scale: scale,
                label: label
            )
        )
    }
}

public struct BadgeModifier<Label: View>: ViewModifier {
    
    public var alignment: Alignment
    public var anchor: UnitPoint
    public var scale: CGFloat
    public var label: Label
    
    public init(alignment: Alignment,
                anchor: UnitPoint = UnitPoint(x: 0.25, y: 0.25),
                scale: CGFloat = 1.2,
                @ViewBuilder label: () -> Label) {
        self.alignment = alignment
        self.anchor = anchor
        self.scale = scale
        self.label = label()
    }
    
    var badge: some View {
        label.ss.alignmentGuideAdjustment(anchor: anchor)
    }
    
    public func body(content: Content) -> some View {
        content
            .ss.invertedMask(alignment: alignment) {
                badge.scaleEffect(scale)
            }
            .overlay(badge, alignment: alignment)
    }
}

