//
//  Spacer+.swift
//  SwiftBrick
//
//  Created by iOS on 2023/5/23.
//  Spacer 扩展 - 提供便捷的 Spacer 尺寸设置方法 / Spacer extension - provides convenient Spacer size setting methods
//

import SwiftUI

// MARK: - Spacer Extension / Spacer 扩展

/// Spacer 扩展 / Spacer extension
public extension Spacer {
    /// 静态方法：创建指定宽度的 Spacer / Static method: create Spacer with specified width
    /// - Parameter value: 宽度值 / Width value
    /// - Returns: Spacer 或带宽度的 Spacer / Spacer or Spacer with width
    @ViewBuilder static func width(_ value: CGFloat?) -> some View {
        switch value {
            case .some(let value): Spacer().frame(width: max(value, 0))
            case nil: Spacer()
        }
    }
    
    /// 静态方法：创建指定高度的 Spacer / Static method: create Spacer with specified height
    /// - Parameter value: 高度值 / Height value
    /// - Returns: Spacer 或带高度的 Spacer / Spacer or Spacer with height
    @ViewBuilder static func height(_ value: CGFloat?) -> some View {
        switch value {
            case .some(let value): Spacer().frame(height: max(value, 0))
            case nil: Spacer()
        }
    }
}
