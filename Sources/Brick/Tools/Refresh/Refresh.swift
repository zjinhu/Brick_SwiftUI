//
//  Refresh.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//  下拉刷新和上拉加载组件/Pull-to-refresh and load more component
///https://github.com/wxxsw/Refresh
import SwiftUI

/// 刷新命名空间/Refresh namespace
public enum Refresh {}

/// 刷新头部类型别名/Refresh header type alias
public typealias RefreshHeader = Refresh.Header

/// 刷新底部类型别名/Refresh footer type alias
public typealias RefreshFooter = Refresh.Footer

/// 默认刷新头部类型别名/Default refresh header type alias
public typealias DefaultRefreshHeader = Refresh.DefaultHeader

/// 默认刷新底部类型别名/Default refresh footer type alias
public typealias DefaultRefreshFooter = Refresh.DefaultFooter

/// View扩展/View extension
extension View {
    /// 启用刷新功能/Enable refresh functionality
    /// - Parameter enable: 是否启用/Whether enabled
    /// - Returns: 应用了刷新修饰器的视图/View with refresh modifier applied
    public func enableRefresh(_ enable: Bool = true) -> some View {
        modifier(Refresh.Modifier(enable: enable))
    }
}
