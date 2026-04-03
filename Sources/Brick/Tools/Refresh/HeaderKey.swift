//
//  HeaderKey.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI

// MARK: HeaderKey - 刷新头部环境键/Header Environment Keys
extension EnvironmentValues {
    /// 刷新头部更新状态/Refresh header update state
    var refreshHeaderUpdate: Refresh.HeaderUpdateKey.Value {
        get { self[Refresh.HeaderUpdateKey.self] }
        set { self[Refresh.HeaderUpdateKey.self] = newValue }
    }
}

extension Refresh {
    /// 刷新头部锚点键/Header anchor key
    /// 用于存储头部视图的边界信息/Stores header view bounds information
    struct HeaderAnchorKey {
        /// 默认值/Default value
        @MainActor static var defaultValue: Value = []
    }
    
    /// 刷新头部更新键/Header update key
    /// 用于触发刷新状态更新/Triggers refresh state updates
    struct HeaderUpdateKey {
        /// 默认值/Default value
        @MainActor static var defaultValue: Value = .init(enable: false)
    }
}

/// Header锚点偏好键/Header anchor preference key
/// 存储头部视图的位置和刷新状态/Stores header view position and refresh state
extension Refresh.HeaderAnchorKey: @preconcurrency PreferenceKey {
    
    /// 值类型/Value type
    typealias Value = [Item]
    
    /// 锚点项/Anchor item
    struct Item {
        /// 视图边界锚点/View bounds anchor
        let bounds: Anchor<CGRect>
        /// 是否正在刷新/Whether refreshing
        let refreshing: Bool
    }
    
    /// 合并值/Merge values
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

/// Header更新环境键/Header update environment key
extension Refresh.HeaderUpdateKey: @preconcurrency EnvironmentKey {
    /// 值结构/Value struct
    struct Value {
        /// 是否启用/Whether enabled
        let enable: Bool
        /// 刷新进度/Refresh progress
        var progress: CGFloat = 0
        /// 是否正在刷新/Whether refreshing
        var refresh: Bool = false
    }
}
