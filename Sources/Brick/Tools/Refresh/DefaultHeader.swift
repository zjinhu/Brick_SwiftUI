//
//  DefaultHeader.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI

// MARK: 默认刷新头部/Default Refresh Header
extension Refresh {
    /// 默认刷新头部视图/Default refresh header view
    /// 提供基本的下拉刷新指示器/Provides basic pull-to-refresh indicator
    public struct DefaultHeader: View{
        
        /// 刷新操作回调/Refresh action callback
        let action: () -> Void

        /// 是否正在刷新/Whether refreshing
        @Binding var refreshing: Bool
        
        /// 刷新提示文本/Refresh prompt text
        var refreshText: String

        /// 初始化/Initialize
        /// - Parameters:
        ///   - refreshing: 刷新状态绑定/Refreshing state binding
        ///   - refreshText: 提示文本/Prompt text
        ///   - action: 刷新操作回调/Refresh action callback
        public init(refreshing: Binding<Bool>,
                    refreshText: String,
                    action: @escaping () -> Void) {
            self.action = action
            self.refreshText = refreshText
            self._refreshing = refreshing
        }
        
        @Environment(\.refreshHeaderUpdate) var update
    }
}

// MARK: View 实现/View Implementation
extension Refresh.DefaultHeader{
    
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
                    
                    Group {
                        if refreshing {
                            ProgressView()
                        } else {
                            Text(refreshText)
                        }
                    }
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
    /// 根据刷新状态返回适当的透明度/Returns appropriate opacity based on refresh state
    var opacity: Double {
        (!refreshing && update.refresh) || (update.progress == 0) ? 0 : 1
    }
}

