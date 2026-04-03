//
//  Badge+.swift
//  Brick_SwiftUI
//
//  徽章叠加系统
//  Badge overlay system
//  支持对齐、锚点、缩放配置
//  Supports alignment, anchor, scale configuration
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

/// Brick 扩展：添加徽章
/// Brick extension: Add badge
@MainActor
public extension Brick where Wrapped: View {
    /// 添加徽章 (使用 CGPoint 缩放)
    /// Add badge (using CGPoint scale)
    /// - Parameters:
    ///   - alignment: 对齐方式 / Alignment
    ///   - anchor: 锚点 / Anchor point
    ///   - scale: 缩放比例 / Scale
    ///   - inset: 间距 / Inset
    ///   - label: 徽章内容构建器 / Badge content builder
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
    
    /// 添加徽章 (使用 CGFloat 缩放)
    /// Add badge (using CGFloat scale)
    /// - Parameters:
    ///   - alignment: 对齐方式 / Alignment
    ///   - anchor: 锚点 / Anchor point
    ///   - scale: 缩放比例 / Scale
    ///   - inset: 间距 / Inset
    ///   - label: 徽章内容构建器 / Badge content builder
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

/// 徽章修饰器
/// Badge modifier
public struct BadgeModifier<Label: View>: ViewModifier {
    
    public var alignment: Alignment
    public var anchor: UnitPoint
    public var scale: CGPoint
    public var inset: CGFloat
    public var label: Label
    
    /// 初始化徽章修饰器 (CGPoint 缩放)
    /// Initialize badge modifier (CGPoint scale)
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
    
    /// 初始化徽章修饰器 (CGFloat 缩放)
    /// Initialize badge modifier (CGFloat scale)
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

/// 徽章遮罩几何效果
/// Badge mask geometry effect
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
