//
//  TabbarColor.swift
//
//
//  Created by iOS on 2024/8/28.
//

import SwiftUI

#if os(iOS)
import UIKit

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

public extension Brick where Wrapped: View {
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    func tabbarColor(_ backgroundColor: Color) -> some View {
//        if #available(iOS 16.0, *) {
//            return wrapped.toolbarBackground(backgroundColor, for: .tabBar)
//        } else {
        wrapped.modifier(TabbarModifier(backgroundColor: backgroundColor.toUIColor()))
//        }
    }
 
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    func tabbarBackground(_ color: Color) -> some View {
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
