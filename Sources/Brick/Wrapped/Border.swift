//
//  Border.swift
//  Brick_SwiftUI
//
//  边框修饰器
//  Border modifier
//  支持圆角矩形、胶囊形状边框
//  Support rounded rectangle, capsule border
//
//  Created by 狄烨 on 2023/10/11.
//

import SwiftUI

/// Brick 扩展：添加边框
/// Brick extension: Add border
@MainActor 
public extension Brick where Wrapped: View {
    /// 添加圆角矩形边框
    /// Add rounded rectangle border
    /// - Parameters:
    ///   - borderColor: 边框颜色 / Border color
    ///   - cornerRadius: 圆角半径 / Corner radius
    ///   - lineWidth: 边框宽度 / Line width
    /// - Returns: 修改后的 View / Modified View
    @inlinable
    func border(_ borderColor: Color,
                cornerRadius: CGFloat,
                lineWidth: CGFloat) -> some View {
        wrapped.overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(borderColor, lineWidth: lineWidth)
        }
    }
    
    /// 添加胶囊形状边框
    /// Add capsule border
    /// - Parameters:
    ///   - borderColor: 边框颜色 / Border color
    ///   - lineWidth: 边框宽度 / Line width
    /// - Returns: 修改后的 View / Modified View
    @inlinable
    func borderCapsule(_ borderColor: Color,
                       lineWidth: CGFloat) -> some View {
        wrapped.overlay {
            Capsule()
                .stroke(borderColor, lineWidth: lineWidth)
        }
    }
    
    /// 添加自定义形状边框
    /// Add custom shape border
    /// - Parameters:
    ///   - content: 形状样式 / Shape style
    ///   - width: 边框宽度 / Border width
    ///   - cornerRadius: 圆角半径 / Corner radius
    /// - Returns: 修改后的 View / Modified View
    @inlinable
    func border<Content: ShapeStyle>(_ content: Content,
                                     width: CGFloat = 1,
                                     cornerRadius: CGFloat = 0) -> some View {
        wrapped.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(content, lineWidth: width)
        )
    }
}
