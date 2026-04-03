//
//  NavigationLink++.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  NavigationLink 扩展 - 提供 NavigationLink 的便捷初始化方法 / NavigationLink extension - provides convenient NavigationLink initialization methods
//

import SwiftUI

// MARK: - NavigationLink Extension / NavigationLink 扩展

/// NavigationLink 扩展 / NavigationLink extension
extension NavigationLink {
    /// 初始化 NavigationLink / Initialize NavigationLink
    /// - Parameters:
    ///   - destination: 目标视图构建闭包 / Destination view builder
    ///   - label: 标签视图构建闭包 / Label view builder
    @_disfavoredOverload
    public init(
        @ViewBuilder destination: () -> Destination,
        @ViewBuilder label: () -> Label
    ) {
        self.init(destination: destination(), label: label)
    }
}

/// NavigationLink 带 Text Label 扩展 / NavigationLink with Text Label extension
extension NavigationLink where Label == Text {
    /// 从本地化字符串键创建 / Creates instance that presents destination with Text label from localized string key
    /// - Parameters:
    ///   - title: 本地化字符串键 / Localized string key
    ///   - destination: 目标视图构建闭包 / Destination view builder
    public init(_ title: LocalizedStringKey, @ViewBuilder destination: () -> Destination) {
        self.init(title, destination: destination())
    }
    
    /// 从字符串创建 / Creates instance that presents destination with Text label from title string
    /// - Parameters:
    ///   - title: 标题字符串 / Title string
    ///   - destination: 目标视图构建闭包 / Destination view builder
    public init<S: StringProtocol>(_ title: S, @ViewBuilder destination: () -> Destination) {
        self.init(title, destination: destination())
    }
    
    /// 带激活状态创建 / Create with active state
    /// - Parameters:
    ///   - title: 标题 / Title
    ///   - isActive: 激活状态绑定 / Active state binding
    ///   - destination: 目标视图构建闭包 / Destination view builder
    @_disfavoredOverload
    public init(
        _ title: String,
        isActive: Binding<Bool>,
        @ViewBuilder destination: () -> Destination
    ) {
        self.init(title, destination: destination(), isActive: isActive)
    }
}
