//
//  SafeArea.swift
//  Brick_SwiftUI
//
//  安全区域填充
//  Safe area padding
//  基于安全区域的应用填充
//  Apply padding based on safe area insets
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

/// Brick 扩展：安全区域填充
/// Brick extension: Safe area padding
public extension Brick where Wrapped: View {
    /// 使用 EdgeInsets 进行安全区域填充
    /// Safe area padding with EdgeInsets
    /// - Parameter edgeInsets: 边缘插入 / Edge insets
    /// - Returns: 修改后的 View / Modified View
    @MainActor @inlinable
    func safeAreaPadding(_ edgeInsets: EdgeInsets) -> some View {
        wrapped.modifier(SafeAreaPaddingModifier(edgeInsets))
    }

    /// 使用统一长度进行安全区域填充
    /// Safe area padding with uniform length
    /// - Parameter length: 填充长度 / Padding length
    /// - Returns: 修改后的 View / Modified View
    @MainActor @inlinable
    func safeAreaPadding(_ length: CGFloat = 16) -> some View {
        wrapped.modifier(SafeAreaPaddingModifier(length))
    }

    /// 使用指定边进行安全区域填充
    /// Safe area padding for specified edges
    /// - Parameters:
    ///   - edges: 边缘集合 / Edge set
    ///   - length: 填充长度 / Padding length
    /// - Returns: 修改后的 View / Modified View
    @MainActor @inlinable
    func safeAreaPadding(_ edges: Edge.Set, _ length: CGFloat = 16) -> some View {
        wrapped.modifier(SafeAreaPaddingModifier(edges, length))
    }
}

/// 安全区域填充修饰器
/// Safe area padding modifier
@frozen
public struct SafeAreaPaddingModifier: ViewModifier {
    public var edgeInsets: EdgeInsets

    /// 使用 EdgeInsets 初始化
    /// Initialize with EdgeInsets
    @inlinable
    public init(_ edgeInsets: EdgeInsets) {
        self.edgeInsets = edgeInsets
    }

    /// 使用统一长度初始化
    /// Initialize with uniform length
    @inlinable
    public init(_ length: CGFloat = 16) {
        self.init(EdgeInsets(top: length, leading: length, bottom: length, trailing: length))
    }

    /// 使用指定边初始化
    /// Initialize with specified edges
    @inlinable
    public init(_ edges: Edge.Set, _ length: CGFloat = 16) {
        let edgeInsets = EdgeInsets(
            top: edges.contains(.top) ? length : 0,
            leading: edges.contains(.leading) ? length : 0,
            bottom: edges.contains(.bottom) ? length : 0,
            trailing: edges.contains(.trailing) ? length : 0
        )
        self.init(edgeInsets)
    }

    public func body(content: Content) -> some View {
        content
            ._safeAreaInsets(edgeInsets)
    }
}

