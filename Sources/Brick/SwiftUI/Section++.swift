//
//  Section++.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  Section 扩展 - 提供 Section 的属性访问和便捷初始化 / Section extension - provides Section property access and convenient initialization
//

import SwiftUI

// MARK: - Section Property Extension / Section 属性扩展

/// Section 扩展 / Section extension
extension Section {
    /// 获取 header 部分 / Get header part
    public var header: Parent {
        unsafeBitCast(self, to: (Parent, Content, Footer).self).0
    }
    
    /// 获取 content 部分 / Get content part
    public var content: Content {
        unsafeBitCast(self, to: (Parent, Content, Footer).self).1
    }
    
    /// 获取 footer 部分 / Get footer part
    public var footer: Footer {
        unsafeBitCast(self, to: (Parent, Content, Footer).self).2
    }
}

// MARK: - Section Convenience Init / Section 便捷初始化

/// Section 便捷初始化扩展 / Section convenience init extension
extension Section where Parent == Text, Content: View, Footer == EmptyView {
    /// 从字符串创建 Section (无 Footer) / Create Section from string (no Footer)
    /// - Parameters:
    ///   - header: 头部标题 / Header title
    ///   - content: 内容构建闭包 / Content builder
    @_disfavoredOverload
    public init<S: StringProtocol>(_ header: S, @ViewBuilder content: () -> Content) {
        self.init(header: Text(header), content: content)
    }
    
    /// 从本地化字符串键创建 Section (无 Footer) / Create Section from localized string key (no Footer)
    /// - Parameters:
    ///   - header: 头部标题 / Header title
    ///   - content: 内容构建闭包 / Content builder
    @_disfavoredOverload
    public init(_ header: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.init(header: Text(header), content: content)
    }
    
    /// 从字符串创建 Section (带参数) / Create Section from string (with parameter)
    /// - Parameters:
    ///   - header: 头部标题 / Header title
    ///   - content: 内容构建闭包 / Content builder
    @_disfavoredOverload
    public init<S: StringProtocol>(header: S, @ViewBuilder content: () -> Content) {
        self.init(header: Text(header), content: content)
    }
}

/// Section 带 Footer 初始化扩展 / Section with Footer init extension
extension Section where Parent == Text, Content: View, Footer == Text {
    /// 创建带 Header 和 Footer 的 Section / Create Section with Header and Footer
    /// - Parameters:
    ///   - header: 头部标题 / Header title
    ///   - footer: 底部标题 / Footer title
    ///   - content: 内容构建闭包 / Content builder
    public init<S: StringProtocol>(
        header: S,
        footer: S,
        @ViewBuilder content: () -> Content
    ) {
        self.init(header: Text(header), footer: Text(footer), content: content)
    }
}
