//
//  Shape++.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  Shape 扩展 - 提供 Shape 的填充和描边功能 / Shape extension - provides Shape fill and stroke functionality
//

import SwiftUI

// MARK: - Shape Extension / Shape 扩展

/// Shape 扩展 / Shape extension
extension Shape {
    /// 填充带描边 / Fill with stroke
    /// - Parameters:
    ///   - fillContent: 填充样式 / Fill content
    ///   - strokeStyle: 描边样式 / Stroke style
    /// - Returns: 组合视图 / Combined view
    public func fill<S: ShapeStyle>(
        _ fillContent: S,
        stroke strokeStyle: StrokeStyle
    ) -> some View {
        ZStack {
            fill(fillContent)
            stroke(style: strokeStyle)
        }
    }
    
    /// 填充并描边边框 / Fill and stroke border
    /// - Parameters:
    ///   - fillContent: 填充样式 / Fill content
    ///   - borderColor: 边框颜色 / Border color
    ///   - borderWidth: 边框宽度 / Border width
    ///   - antialiased: 是否抗锯齿 / Whether antialiased
    /// - Returns: 组合视图 / Combined view (仅 InsettableShape 可用)
    public func fillAndStrokeBorder<S: ShapeStyle>(
        _ fillContent: S,
        borderColor: Color,
        borderWidth: CGFloat,
        antialiased: Bool = true
    ) -> some View where Self: InsettableShape {
        ZStack {
            inset(by: borderWidth / 2).fill(fillContent)
            
            self.strokeBorder(
                borderColor,
                lineWidth: borderWidth,
                antialiased: antialiased
            )
        }
        .compositingGroup()
    }
}
