//
//  Badge+.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
@MainActor
public extension Brick where Wrapped: View {
    
    @inlinable
    func badge<Label: View>(alignment: Alignment = .topTrailing,
                            anchor: UnitPoint = UnitPoint(x: 0.25, y: 0.25),
                            scale: CGPoint,
                            inset: CGFloat = 0,
                            @ViewBuilder label: () -> Label) -> some View {
        wrapped.modifier(
            BadgeModifier(
                alignment: alignment,
                anchor: anchor,
                scale: scale,
                inset: inset,
                label: label
            )
        )
    }
    
    @inlinable
    func badge<Label: View>(alignment: Alignment = .topTrailing,
                            anchor: UnitPoint = UnitPoint(x: 0.25, y: 0.25),
                            scale: CGFloat = 1,
                            inset: CGFloat = 0,
                            @ViewBuilder label: () -> Label) -> some View {
        badge(
            alignment: alignment,
            anchor: anchor,
            scale: CGPoint(x: scale, y: scale),
            inset: inset,
            label: label
        )
    }
}

public struct BadgeModifier<Label: View>: ViewModifier {
    
    public var alignment: Alignment
    public var anchor: UnitPoint
    public var scale: CGPoint
    public var inset: CGFloat
    public var label: Label
    
    public init(
        alignment: Alignment,
        anchor: UnitPoint = UnitPoint(x: 0.25, y: 0.25),
        scale: CGPoint,
        inset: CGFloat = 0,
        @ViewBuilder label: () -> Label
    ) {
        self.alignment = alignment
        self.anchor = anchor
        self.label = label()
        self.scale = scale
        self.inset = inset
    }
    
    public init(
        alignment: Alignment,
        anchor: UnitPoint = UnitPoint(x: 0.25, y: 0.25),
        scale: CGFloat,
        inset: CGFloat = 0,
        @ViewBuilder label: () -> Label
    ) {
        self.init(
            alignment: alignment,
            anchor: anchor,
            scale: CGPoint(x: scale, y: scale),
            inset: inset,
            label: label
        )
    }
    
    
    var badge: some View {
        label.ss.alignmentGuideAdjustment(anchor: anchor)
    }
    
    public func body(content: Content) -> some View {
        content
            .ss.invertedMask(alignment: alignment) {
                badge.modifier(
                    BadgeMaskEffect(scale: scale, inset: inset)
                )
            }
            .overlay(badge, alignment: alignment)
    }
}

private struct BadgeMaskEffect: GeometryEffect {
    var scale: CGPoint
    var inset: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let dx = scale.x * (size.width + inset) / size.width
        let dy = scale.y * (size.height + inset) / size.height
        let x = size.width * (dx - 1) / 2
        let y = size.height * (dy - 1) / 2
        return ProjectionTransform(
            CGAffineTransform(translationX: -x, y: -y)
                .scaledBy(x: dx, y: dy)
        )
    }
}
