//
//  Alignment+.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

public extension Brick where Wrapped: View {
 
    func alignmentGuideAdjustment(anchor: UnitPoint) -> some View {
        wrapped.modifier(AlignmentGuideAdjustmentModifier(anchor: anchor, offset: .zero))
    }
 
    func alignmentGuideAdjustment(x: CGFloat, y: CGFloat) -> some View {
        wrapped.modifier(AlignmentGuideAdjustmentModifier(anchor: .zero, offset: CGPoint(x: x, y: y)))
    }
 
    func alignmentGuideAdjustment(anchor: UnitPoint, x: CGFloat, y: CGFloat) -> some View {
        wrapped.modifier(AlignmentGuideAdjustmentModifier(anchor: anchor, offset: CGPoint(x: x, y: y)))
    }
}


public struct AlignmentGuideAdjustmentModifier: ViewModifier {

    public var anchor: UnitPoint
    public var offset: CGPoint

    public init(anchor: UnitPoint, offset: CGPoint) {
        self.anchor = anchor
        self.offset = offset
    }

    public func body(content: Content) -> some View {
        content
            .alignmentGuide(.top) { $0[.top] + ($0.height * anchor.y) + offset.y }
            .alignmentGuide(.bottom) { $0[.bottom] - ($0.height * anchor.y) - offset.y }
            .alignmentGuide(.trailing) { $0[.trailing] - ($0.width * anchor.x) - offset.x }
            .alignmentGuide(.leading) { $0[.leading] + ($0.width * anchor.x) + offset.x }
    }
}
