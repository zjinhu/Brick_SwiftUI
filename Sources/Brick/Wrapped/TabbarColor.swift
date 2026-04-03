//
//  TabbarColor.swift
//  Brick_SwiftUI
//
//  TabBar 颜色设置
//  TabBar color setting
//  使用 UIKit appearance API 设置 TabBar 背景色
//  Use UIKit appearance API to set TabBar background color
//
//  Created by iOS on 2024/8/28.
//

import SwiftUI

#if os(iOS)
import UIKit

/// TabBar 修饰器
/// TabBar modifier
struct TabbarModifier: ViewModifier {
    
    var backgroundColor: UIColor?

    init(backgroundColor: UIColor? = nil) {
        self.backgroundColor = backgroundColor
        let standardAppearance = UITabBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        standardAppearance.backgroundColor = backgroundColor
        UITabBar.appearance().standardAppearance = standardAppearance
        
        if #available(iOS 15.0, *) {
            let scrollEdgeAppearance = UITabBarAppearance()
            scrollEdgeAppearance.configureWithTransparentBackground()
            scrollEdgeAppearance.backgroundColor = backgroundColor
            UITabBar.appearance().scrollEdgeAppearance = scrollEdgeAppearance
        }
    }
    
    func body(content: Content) -> some View {
        content
    }
}

/// Brick 扩展：TabBar 颜色
/// Brick extension: TabBar color
public extension Brick where Wrapped: View {
    /// 设置 TabBar 背景色
    /// Set TabBar background color
    /// - Parameter backgroundColor: 背景色 / Background color
    /// - Returns: 修改后的 View / Modified View
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @MainActor func tabbarColor(_ backgroundColor: Color) -> some View {
        wrapped.modifier(TabbarModifier(backgroundColor: backgroundColor.toUIColor()))
    }
 
    /// 设置 TabBar 背景色 (别名)
    /// Set TabBar background color (alias)
    /// - Parameter color: 颜色 / Color
    /// - Returns: 修改后的 View / Modified View
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @MainActor func tabbarBackground(_ color: Color) -> some View {
        let standardAppearance = UITabBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        standardAppearance.backgroundColor = UIColor(color)
        UITabBar.appearance().standardAppearance = standardAppearance
        
        if #available(iOS 15.0, *) {
            let scrollEdgeAppearance = UITabBarAppearance()
            scrollEdgeAppearance.configureWithTransparentBackground()
            scrollEdgeAppearance.backgroundColor = UIColor(color)
            UITabBar.appearance().scrollEdgeAppearance = scrollEdgeAppearance
        }

        return wrapped
    }
}
#endif
