//
//  Header.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI

// MARK: 自定义刷新头部/Custom Refresh Header
extension Refresh {
    /// 自定义刷新头部视图/Custom refresh header view
    /// 允许自定义下拉刷新指示器内容/Allows custom pull-to-refresh indicator content
    public struct Header<Label> where Label: View {
        
        /// 刷新操作回调/Refresh action callback
        let action: () -> Void
        /// 标签构建器/Label builder
        let label: (CGFloat) -> Label
        
        /// 是否正在刷新/Whether refreshing
        @Binding var refreshing: Bool

        /// 初始化/Initialize
        /// - Parameters:
        ///   - refreshing: 刷新状态绑定/Refreshing state binding
        ///   - action: 刷新操作回调/Refresh action callback
        ///   - label: 标签视图构建器/Label view builder
        public init(refreshing: Binding<Bool>, action: @escaping () -> Void, @ViewBuilder label: @escaping (CGFloat) -> Label) {
            self.action = action
            self.label = label
            self._refreshing = refreshing
        }
        
        @Environment(\.refreshHeaderUpdate) var update
    }
}

// MARK: View 实现/View Implementation
extension Refresh.Header: View {
    
    public var body: some View {
        // 当达到刷新阈值时触发刷新操作/Trigger refresh action when threshold is reached
        if update.refresh, !refreshing, update.progress > 1.01 {
            DispatchQueue.main.async {
                self.refreshing = true
                self.action()
            }
        }
        
        return Group {
            if update.enable {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    label(update.progress)
                        .opacity(opacity)
                }
                .frame(maxWidth: .infinity)
            } else {
                EmptyView()
            }
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .anchorPreference(key: Refresh.HeaderAnchorKey.self, value: .bounds) {
            [.init(bounds: $0, refreshing: self.refreshing)]
        }
    }
    
    /// 计算透明度/Calculate opacity
    /// 根据刷新状态和进度返回适当的透明度/Returns appropriate opacity based on refresh state and progress
    var opacity: Double {
        (!refreshing && update.refresh) || (update.progress == 0) ? 0 : 1
    }
}
