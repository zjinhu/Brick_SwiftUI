//
//  Alignment+.swift
//  Brick_SwiftUI
//
//  对齐方式调整修饰器
//  Alignment guide adjustment modifier
//  调整视图对齐方式，基于锚点和偏移量
//  Adjust view alignment based on anchor and offset
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

/// Brick 扩展：对齐方式调整
/// Brick extension: Alignment adjustment
@MainActor
public extension Brick where Wrapped: View {
    /// 基于锚点调整对齐
    /// Adjust alignment based on anchor
    /// - Parameter anchor: 锚点 / Anchor point
    /// - Returns: 修改后的 View / Modified View
    func alignmentGuideAdjustment(anchor: UnitPoint) -> some View {
        wrapped.modifier(AlignmentGuideAdjustmentModifier(anchor: anchor, offset: .zero))
    }
   
    /// 基于偏移量调整对齐 (x, y)
    /// Adjust alignment based on offset (x, y)
    /// - Parameters:
    ///   - x: X轴偏移 / X axis offset
    ///   - y: Y轴偏移 / Y axis offset
    /// - Returns: 修改后的 View / Modified View
    func alignmentGuideAdjustment(x: CGFloat, y: CGFloat) -> some View {
        wrapped.modifier(AlignmentGuideAdjustmentModifier(anchor: .zero, offset: CGPoint(x: x, y: y)))
    }
   
    /// 基于锚点和偏移量调整对齐
    /// Adjust alignment based on anchor and offset
    /// - Parameters:
    ///   - anchor: 锚点 / Anchor point
    ///   - x: X轴偏移 / X axis offset
    ///   - y: Y轴偏移 / Y axis offset
    /// - Returns: 修改后的 View / Modified View
    func alignmentGuideAdjustment(anchor: UnitPoint, x: CGFloat, y: CGFloat) -> some View {
        wrapped.modifier(AlignmentGuideAdjustmentModifier(anchor: anchor, offset: CGPoint(x: x, y: y)))
    }
}


/// 对齐方式调整修饰器
/// Alignment guide adjustment modifier
public struct AlignmentGuideAdjustmentModifier: ViewModifier {

    public var anchor: UnitPoint
    public var offset: CGPoint

    /// 初始化对齐方式调整修饰器
    /// Initialize alignment adjustment modifier
    /// - Parameters:
    ///   - anchor: 锚点 / Anchor point
    ///   - offset: 偏移量 / Offset
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
