//
//  NavigationBarColor.swift
//  Brick_SwiftUI
//
//  导航栏颜色设置
//  Navigation bar color setting
//  设置导航栏背景色
//  Set navigation bar background color
//
//  Created by 狄烨 on 2023/8/30.
//

import SwiftUI
#if os(iOS)
import UIKit

/// 导航栏修饰器
/// Navigation bar modifier
struct NavigationBarModifier: ViewModifier {
    
    var backgroundColor: UIColor?

    init(backgroundColor: UIColor? = nil) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

/// Brick 扩展：导航栏颜色
/// Brick extension: Navigation bar color
public extension Brick where Wrapped: View {
    /// 设置导航栏背景色
    /// Set navigation bar background color
    /// - Parameter backgroundColor: 背景色 / Background color
    /// - Returns: 修改后的 View / Modified View
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @MainActor func navigationBarColor(backgroundColor: Color) -> some View {
        if #available(iOS 16.0, *) {
            return wrapped.toolbarBackground(backgroundColor, for: .navigationBar)
        } else {
            return wrapped.modifier(NavigationBarModifier(backgroundColor: backgroundColor.toUIColor()))
        }
    }
}
#endif
