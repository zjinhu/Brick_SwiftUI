//
//  Menu++.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  Menu 扩展 - 提供 Menu 的便捷初始化方法 / Menu extension - provides convenient Menu initialization methods
//

import SwiftUI

// MARK: - Menu Init with SF Symbol / Menu SF Symbol 初始化

/// Menu 扩展 / Menu extension
@available(tvOS 17.0, *)
@available(watchOS, unavailable)
extension Menu {
    /// 从 SF Symbol 创建 Menu / Create Menu from SF Symbol
    /// - Parameters:
    ///   - systemImage: SF Symbol 名称 / SF Symbol name
    ///   - content: 菜单内容构建闭包 / Menu content builder
    public init(
        systemImage: SFSymbolName,
        @ViewBuilder content: () -> Content
    ) where Label == Image {
        let content = content()
        
        self.init(content: { content }) {
            Image(symbol: systemImage)
        }
    }
}

// MARK: - View Menu Extension / View Menu 扩展

/// View Menu 扩展 / View menu extension
@available(tvOS 17.0, *)
@available(watchOS, unavailable)
extension View {
    /// 按下时显示 Menu / Presents a Menu when this view is pressed
    /// - Parameter content: 菜单内容构建闭包 / Menu content builder
    /// - Returns: 带菜单的视图 / View with menu
    public func menuOnPress<MenuContent: View>(
        @ViewBuilder content: () -> MenuContent
    ) -> some View {
        Menu(content: content) {
            self
        }
        .menuStyle(BorderlessButtonMenuStyle())
        .buttonStyle(PlainButtonStyle())
    }
}
