//
//  CircularProgressStyle.swift
//  圆形进度条样式/Circular progress view style
//
//  Created by iOS on 2024/9/2.
//

import SwiftUI

/// 圆形进度条样式/Circular progress view style
public struct CircularProgressStyle: ProgressViewStyle {
    /// 描边颜色/Stroke color
    public var strokeColor: Color = .blue
    /// 描边宽度/Stroke width
    public var strokeWidth: CGFloat = 10.0
    
    /// 初始化/Initialize
    /// - Parameters:
    ///   - strokeColor: 描边颜色/Stroke color
    ///   - strokeWidth: 描边宽度/Stroke width
    public init(strokeColor: Color, strokeWidth: CGFloat) {
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .stroke(strokeColor.opacity(0.3), lineWidth: strokeWidth)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: configuration.fractionCompleted)
        }
    }
}
