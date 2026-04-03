//
//  Modifier.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI

// MARK: 刷新修饰器/Refresh Modifier
extension Refresh {
    /// 刷新修饰器/Refresh modifier
    /// 用于管理下拉刷新和上拉加载的状态/Manages pull-to-refresh and load more states
    struct Modifier {
        /// 是否启用/Whether enabled
        let isEnabled: Bool
        
        /// 视图ID/View ID
        @State private var id: Int = 0
        /// 头部更新状态/Header update state
        @State private var headerUpdate: HeaderUpdateKey.Value
        /// 头部内边距/Header padding
        @State private var headerPadding: CGFloat = 0
        /// 上一次进度/Previous progress
        @State private var headerPreviousProgress: CGFloat = 0
        
        /// 底部更新状态/Footer update state
        @State private var footerUpdate: FooterUpdateKey.Value
        /// 上一次刷新时间/Previous refresh time
        @State private var footerPreviousRefreshAt: Date?
        
        /// 初始化/Initialize
        /// - Parameter enable: 是否启用/Whether enabled
        init(enable: Bool) {
            isEnabled = enable
            _headerUpdate = State(initialValue: .init(enable: enable))
            _footerUpdate = State(initialValue: .init(enable: enable))
        }
        
        @Environment(\.defaultMinListRowHeight) var rowHeight
    }
}

// MARK: ViewModifier 实现/ViewModifier Implementation
extension Refresh.Modifier: ViewModifier {
    
    /// 修饰内容/Modify content
    /// - Parameter content: 原始视图/Original view
    /// - Returns: 应用了刷新功能的视图/View with refresh functionality
    func body(content: Content) -> some View {
        return GeometryReader { proxy in
            content
                .environment(\.refreshHeaderUpdate, self.headerUpdate)
                .environment(\.refreshFooterUpdate, self.footerUpdate)
                .padding(.top, self.headerPadding)
                .clipped(proxy.safeAreaInsets == .zero)
                .backgroundPreferenceValue(Refresh.HeaderAnchorKey.self) { v -> Color in
                    DispatchQueue.main.async { self.update(proxy: proxy, value: v) }
                    return Color.clear
                }
                .backgroundPreferenceValue(Refresh.FooterAnchorKey.self) { v -> Color in
                    DispatchQueue.main.async { self.update(proxy: proxy, value: v) }
                    return Color.clear
                }
                .id(self.id)
        }
    }
    
    /// 更新头部状态/Update header state
    /// - Parameters:
    ///   - proxy: 几何代理/Geometry proxy
    ///   - value: 头部锚点值/Header anchor value
    func update(proxy: GeometryProxy, value: Refresh.HeaderAnchorKey.Value) {
        guard let item = value.first else { return }
        guard !footerUpdate.refresh else { return }
        
        let bounds = proxy[item.bounds]
        var update = headerUpdate
        
        update.progress = max(0, (bounds.maxY) / bounds.height)
        
        if update.refresh != item.refreshing {
            update.refresh = item.refreshing
            
            if !item.refreshing {
                id += 1
                DispatchQueue.main.async {
                    self.headerUpdate.progress = 0
                }
            }
        } else {
            update.refresh = update.refresh || (headerPreviousProgress > 1 && update.progress < headerPreviousProgress && update.progress >= 1)
        }
        
        headerUpdate = update
        headerPadding = headerUpdate.refresh ? 0 : -max(rowHeight, bounds.height)
        headerPreviousProgress = update.progress
    }
    
    /// 更新底部状态/Update footer state
    /// - Parameters:
    ///   - proxy: 几何代理/Geometry proxy
    ///   - value: 底部锚点值/Footer anchor value
    func update(proxy: GeometryProxy, value: Refresh.FooterAnchorKey.Value) {
        guard let item = value.first else { return }
        guard headerUpdate.progress == 0 else { return }
        
        let bounds = proxy[item.bounds]
        var update = footerUpdate
        
        if bounds.minY <= rowHeight || bounds.minY <= bounds.height {
            update.refresh = false
        } else if update.refresh && !item.refreshing {
            update.refresh = false
        } else {
            update.refresh = proxy.size.height - bounds.minY + item.preloadOffset > 0
        }
        
        if update.refresh, !footerUpdate.refresh {
            if let date = footerPreviousRefreshAt, Date().timeIntervalSince(date) < 0.1 {
                update.refresh = false
            }
            footerPreviousRefreshAt = Date()
        }
        
        footerUpdate = update
    }
}
