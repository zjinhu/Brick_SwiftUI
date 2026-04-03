//
//  ProgressHeightStyle.swift
//  高度自定义的进度条样式/Custom height progress view style
//
//  Created by iOS on 2023/6/25.
//

import SwiftUI

/// ProgressViewStyle 扩展，提供高度自定义的条形进度样式/ProgressViewStyle extension providing custom height bar progress style
extension ProgressViewStyle where Self == BarProgressViewStyle {
    /// 创建带高度参数的进度条样式/Create progress view style with height parameter
    /// - Parameters:
    ///   - height: 进度条高度/Progress bar height
    ///   - foregroundColor: 前景颜色/Foreground color
    ///   - backgroundColor: 背景颜色/Background color
    /// - Returns: 条形进度样式/Bar progress view style
    public static func heightBar(height: CGFloat = 6,
                                 foregroundColor: Color = .accentColor,
                                 backgroundColor: Color = .gray.opacity(0.3)) -> BarProgressViewStyle {
        BarProgressViewStyle(barHeight: height,
                             foregroundColor: foregroundColor,
                             backgroundColor: backgroundColor)
    }
}

/// 自定义高度的条形进度条样式/Custom height bar progress view style
public struct BarProgressViewStyle: ProgressViewStyle {
    
    /// 前景颜色/Foreground color
    private let foregroundColor: Color
    /// 背景颜色/Background color
    private let backgroundColor: Color
    /// 进度条高度/Bar height
    
    private let barHeight: CGFloat
    
    /// 初始化/Initialize
    /// - Parameters:
    ///   - barHeight: 进度条高度/Bar height
    ///   - foregroundColor: 前景颜色/Foreground color
    ///   - backgroundColor: 背景颜色/Background color
    public init( barHeight: CGFloat,
                 foregroundColor: Color,
                 backgroundColor: Color) {
        self.barHeight = barHeight
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0
        return GeometryReader { proxy in
            
            ZStack(alignment: .leading) {
                Capsule()
                    .foregroundColor(backgroundColor)
                Capsule()
                    .foregroundColor(foregroundColor)
                    .frame(width: proxy.size.width * CGFloat(progress), alignment: .leading)
                    .animation(.easeInOut, value: 0.7)
            }
        }
        .frame(height: barHeight, alignment: .leading)
    }
}
