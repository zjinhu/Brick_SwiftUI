//
//  FooterKey.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI

// MARK: FooterKey - 刷新底部环境键/Footer Environment Keys
extension EnvironmentValues {
    /// 刷新底部更新状态/Refresh footer update state
    var refreshFooterUpdate: Refresh.FooterUpdateKey.Value {
        get { self[Refresh.FooterUpdateKey.self] }
        set { self[Refresh.FooterUpdateKey.self] = newValue }
    }
}

extension Refresh {
    /// 刷新底部锚点键/Footer anchor key
    /// 用于存储底部视图的边界信息/Stores footer view bounds information
    struct FooterAnchorKey {
        /// 默认值/Default value
        @MainActor static var defaultValue: Value = []
    }
    
    /// 刷新底部更新键/Footer update key
    /// 用于触发加载更多状态更新/Triggers load more state updates
    struct FooterUpdateKey {
        /// 默认值/Default value
        @MainActor static let defaultValue: Value = .init(enable: false)
    }
}

/// Footer锚点偏好键/Footer anchor preference key
/// 存储底部视图的位置、预加载偏移和刷新状态/Stores footer view position, preload offset and refresh state
extension Refresh.FooterAnchorKey: @preconcurrency PreferenceKey {
    
    /// 值类型/Value type
    typealias Value = [Item]
    
    /// 锚点项/Anchor item
    struct Item {
        /// 视图边界锚点/View bounds anchor
        let bounds: Anchor<CGRect>
        /// 预加载偏移量/Preload offset
        let preloadOffset: CGFloat
        /// 是否正在刷新/Whether refreshing
        let refreshing: Bool
    }
    
    /// 合并值/Merge values
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

/// Footer更新环境键/Footer update environment key
extension Refresh.FooterUpdateKey: @preconcurrency EnvironmentKey {
    /// 值结构/Value struct
    struct Value: Equatable {
        /// 是否启用/Whether enabled
        let enable: Bool
        /// 是否正在刷新/Whether refreshing
        var refresh: Bool = false
    }
}
