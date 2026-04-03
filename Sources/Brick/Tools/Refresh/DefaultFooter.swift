//
//  DefaultFooter.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI

// MARK: 默认刷新底部/Default Refresh Footer
extension Refresh {
    /// 默认刷新底部视图/Default refresh footer view
    /// 提供基本的加载更多指示器/Provides basic load more indicator
    public struct DefaultFooter: View {
        
        /// 加载操作回调/Load action callback
        let action: () -> Void
        
        /// 是否正在加载/Whether loading
        @Binding var refreshing: Bool
        
        /// 没有更多数据时的提示文本/No more data prompt text
        var noMoreText: String
        
        /// 是否没有更多数据/Whether no more data
        private var noMore: Bool = false
        /// 预加载偏移量/Preload offset
        private var preloadOffset: CGFloat = 0
        
        /// 初始化/Initialize
        /// - Parameters:
        ///   - refreshing: 加载状态绑定/Loading state binding
        ///   - noMoreText: 没有更多数据的提示文本/No more data text
        ///   - action: 加载操作回调/Load action callback
        public init(refreshing: Binding<Bool>,
                    noMoreText: String,
                    action: @escaping () -> Void) {
            self.action = action
            self.noMoreText = noMoreText
            self._refreshing = refreshing
        }
        
        @Environment(\.refreshFooterUpdate) var update
    }
}

// MARK: 配置方法/Configuration Methods
extension Refresh.DefaultFooter {
    /// 设置没有更多数据/Set no more data
    /// - Parameter noMore: 是否没有更多数据/Whether no more data
    /// - Returns: 配置后的视图/Configured view
    public func noMore(_ noMore: Bool) -> Self {
        var view = self
        view.noMore = noMore
        return view
    }
    
    /// 设置预加载偏移量/Set preload offset
    /// - Parameter offset: 预加载偏移量/Preload offset
    /// - Returns: 配置后的视图/Configured view
    public func preload(offset: CGFloat) -> Self {
        var view = self
        view.preloadOffset = offset
        return view
    }
}

// MARK: View 实现/View Implementation
extension Refresh.DefaultFooter{
    
    public var body: some View {
        // 当滚动到底部且有更多数据时触发加载操作/Trigger load action when scrolled to bottom and has more data
        if !noMore, update.refresh, !refreshing {
            DispatchQueue.main.async {
                self.refreshing = true
                self.action()
            }
        }
        
        return Group {
            if update.enable {
                VStack(alignment: .center, spacing: 0) {
                    if refreshing || noMore {
                        if noMore {
                            Text(noMoreText)
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ProgressView()
                                .padding()
                        }
                    } else {
                        EmptyView()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                EmptyView()
            }
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .anchorPreference(key: Refresh.FooterAnchorKey.self, value: .bounds) {
            if self.noMore || self.refreshing {
                return []
            } else {
                return [.init(bounds: $0, preloadOffset: self.preloadOffset, refreshing: self.refreshing)]
            }
        }
    }
}
