//
//  Text++.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  Text 扩展 - 提供 Text 的样式和渐变功能 / Text extension - provides Text styling and gradient functionality
//

import SwiftUI

// MARK: - Text Extension / Text 扩展

/// Text 扩展 / Text extension
extension Text {
    /// 应用线性前景渐变 / Applies a linear foreground gradient to the text
    /// - Parameters:
    ///   - gradient: 渐变 / Gradient
    ///   - startPoint: 起点 / Start point
    ///   - endPoint: 终点 / End point
    /// - Returns: 带渐变的 Text / Text with gradient
    public func foregroundLinearGradient(
        _ gradient: Gradient,
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing
    ) -> some View {
        overlay(
            LinearGradient(
                gradient: gradient,
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
        .mask(self)
    }
    
    /// 自动调整字体大小 (最小缩放因子) / Auto adjust font size (minimum scale factor)
    /// - Parameter minimumScaleFactor: 最小缩放因子 / Minimum scale factor
    /// - Returns: 自动调整大小的 Text / Text with auto font size
    public func autoFontSize(minimumScaleFactor: CGFloat = 0.01) -> some View {
        lineLimit(1)
        .minimumScaleFactor(minimumScaleFactor)
    }
    
}
