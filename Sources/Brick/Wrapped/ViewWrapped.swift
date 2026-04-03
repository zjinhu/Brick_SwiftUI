//
//  ViewWrapped.swift
//  Brick_SwiftUI
//
//  视图包装器扩展
//  View wrapper extensions
//  阴影和边框扩展
//  Shadow and border extensions
//
//  Created by iOS on 2023/6/29.
//

import SwiftUI

/// Brick 扩展：阴影
/// Brick extension: Shadow
extension Brick where Wrapped: View {
    /// 添加阴影
    /// Add shadow
    /// - Parameters:
    ///   - color: 颜色 / Color
    ///   - x: X 偏移 / X offset
    ///   - y: Y 偏移 / Y offset
    ///   - blur: 模糊半径 / Blur radius
    /// - Returns: 修改后的 View / Modified View
    public func shadow(
        color: Color = .black,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat
    ) -> some View {
        wrapped.shadow(color: color, radius: blur / 2, x: x, y: y)
    }
}

/// Brick 扩展：形状边框
/// Brick extension: Shape border
extension Brick where Wrapped: View {
    /// 添加形状边框
    /// Add shape border
    /// - Parameters:
    ///   - content: 形状构建器 / Shape builder
    ///   - color: 边框颜色 / Border color
    ///   - width: 边框宽度 / Border width
    ///   - cornerRadius: 圆角半径 / Corner radius
    /// - Returns: 修改后的 View / Modified View
    public func border<Content: Shape>(
        @ViewBuilder _ content: () -> Content,
        color: Color = .gray,
        width: CGFloat = 1,
        cornerRadius: CGFloat = 0
    ) -> some View {
        wrapped.overlay(
            content()
             .stroke(color, lineWidth: width)
        )
    }
}
