//
//  View+Mask.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  视图蒙版扩展 - 提供蒙版、反向蒙版等功能 / View mask extension - provides mask, reverse mask and other functions
//

import SwiftUI

// MARK: - View Mask Extension / 视图蒙版扩展

/// 视图蒙版扩展 / View mask extension
extension View {
    /// 使用给定视图的 alpha 通道遮罩此视图 / Masks this view using the alpha channel of the given view
    /// - Parameter view: 蒙版视图 / Mask view
    @_disfavoredOverload
    @inlinable
    public func mask<T: View>(@ViewBuilder _ view: () -> T) -> some View {
        self.mask(view())
    }

    /// 使用此视图的 alpha 通道遮罩给定视图 / Masks the given view using the alpha channel of this view
    /// - Parameter view: 要被遮罩的视图 / View to be masked
    @inlinable
    public func masking<T: View>(_ view: T) -> some View {
        hidden().background(view.mask(self))
    }
    
    /// 使用此视图的 alpha 通道遮罩给定视图 (闭包版本) / Masks the given view using the alpha channel of this view (closure version)
    /// - Parameter view: 蒙版构建闭包 / Mask building closure
    @inlinable
    public func masking<T: View>(@ViewBuilder _ view: () -> T) -> some View {
        masking(view())
    }
    
    /// 反向蒙版 - 允许创建遮罩效果 / Reverse mask - allows creating inverse mask effects
    /// - SeeAlso: https://www.fivestars.blog/articles/reverse-masks-how-to/
    /// - Parameters:
    ///   - alignment: 对齐方式 / Alignment
    ///   - mask: 蒙版构建闭包 / Mask building closure
    @inlinable
    public func reverseMask<Mask: View>(alignment: Alignment = .center, @ViewBuilder _ mask: () -> Mask) -> some View {
        self.mask(
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        )
    }
}
