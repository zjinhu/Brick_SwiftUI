//
//  View+Conditionals.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  视图条件扩展 - 提供条件性的视图显示/隐藏 / View conditionals extension - provides conditional view display/hide
//

import SwiftUI

// MARK: - View Conditionals / 视图条件

/// 视图条件扩展 / View conditionals extension
public extension View {
    /// 条件启用视图 (disabled 的反向版本) / Enable the view if a certain condition is met (inverted version of disabled)
    /// 旨在提高可读性 / Intended to increase readability
    /// - Parameter condition: 是否启用 / Whether to enable
    func enabled(_ condition: Bool) -> some View {
        disabled(!condition)
    }
    
    /// 条件隐藏视图 / Hide the view if the provided condition is `true`
    /// - Parameter condition: 是否隐藏 / Whether to hide
    @ViewBuilder
    func hidden(if condition: Bool) -> some View {
        if condition {
            self.hidden()
        } else {
            self
        }
    }
    
    /// 条件显示视图 / Show the view if the provided condition is `true`
    /// - Parameter condition: 是否显示 / Whether to show
    func visible(if condition: Bool) -> some View {
        hidden(if: !condition)
    }
}

// MARK: - Searchable Condition / 可搜索条件

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    /// 条件可搜索 / Make the view searchable if the condition is `true`
    /// - Parameters:
    ///   - condition: 是否启用搜索 / Whether to enable search
    ///   - text: 搜索文本绑定 / Search text binding
    ///   - placement: 搜索字段位置 / Search field placement
    ///   - prompt: 搜索提示文本 / Search prompt text
    @ViewBuilder
    func searchable(if condition: Bool,
                    text: Binding<String>,
                    placement: SearchFieldPlacement = .automatic,
                    prompt: String) -> some View {
        if condition {
            self.searchable(
                text: text,
                placement: placement,
                prompt: prompt)
        } else {
            self
        }
    }
}
