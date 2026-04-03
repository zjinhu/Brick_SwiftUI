//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  控制 TabBar 显示/隐藏的可见性枚举
//  Controls TabBar visibility - controls showing/hiding with animation
//
//  Created by iOS on 2023/6/29.
//

import SwiftUI

/// TabBar 可见性选项枚举
/// TabBar visibility options enum
public enum TabbarVisible: CaseIterable {
  
    case visible    // 显示 TabBar / Show TabBar
    case hidden    // 隐藏 TabBar / Hide TabBar
  
    /// 切换可见性状态
    /// Toggle visibility state
    public mutating func toggle() {
        switch self {
        case .visible:
            self = .hidden
        case .hidden:
            self = .visible
        }
    }
}

#if os(iOS) || targetEnvironment(macCatalyst)
import UIKit

/// Brick 扩展：为 View 添加 TabBar 可见性控制
/// Brick extension: Control TabBar visibility for View
public extension Brick where Wrapped: View {
    /// 控制 TabBar 的显示或隐藏
    /// Control TabBar visibility (visible/hidden)
    /// - Parameter visibility: TabbarVisible 可见性枚举 / visibility enum
    /// - Returns: 修改后的 View / Modified View
    @MainActor func tabBar(_ visibility: TabbarVisible) -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return wrapped.modifier(VisibleTabBar(visibility))
        }else{
            return wrapped.modifier(ShowTabBar(visibility))
        }
    }
}

/// iOS 16+ 使用 toolbar API 实现 TabBar 隐藏
/// iOS 16+ uses toolbar API for TabBar visibility
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct VisibleTabBar: ViewModifier {
    @State private var show: TabbarVisible?
    private var showTemp: TabbarVisible
    init(_ show: TabbarVisible) {
        self.showTemp = show
    }
    
    func body(content: Content) -> some View {
        return content
            .padding(.zero)
            .tabBarHidden(show == .hidden ? .hidden : .visible)
            .onAppear{
                show = showTemp
            }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
/// TabBar 隐藏扩展方法 (iOS 16+)
/// TabBar hidden extension method (iOS 16+)
extension View {
    @ViewBuilder
    public func tabBarHidden(_ visibility: Visibility) -> some View {
        if #available(iOS 18.0, *) {
            self.toolbarVisibility(visibility, for: .tabBar)
        }else{
            self.toolbar(visibility, for: .tabBar)
        }
    }

}

/// 旧版 iOS 使用 UIKit 方法实现 TabBar 隐藏
/// Legacy iOS uses UIKit method to hide TabBar
struct ShowTabBar: ViewModifier {
    @State private var show: TabbarVisible
    
    init(_ show: TabbarVisible) {
        self.show = show
    }
    
    func body(content: Content) -> some View {
        return content
            .padding(.zero)
            .onAppear {
                DispatchQueue.main.async {
                    if show == .hidden{
                        TabBarModifier.hideTabBar()
                    }else{
                        TabBarModifier.showTabBar()
                    }
                }
            }
    }
}

/// TabBar 修饰器，使用 UIKit 控制 TabBar 显示/隐藏
/// TabBar modifier using UIKit to control TabBar visibility
struct TabBarModifier {
    /// 显示 TabBar / Show TabBar
    @MainActor static func showTabBar() {
        UIWindow.keyWindow?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.setHidden(false)
            }
        })
    }
    
    /// 隐藏 TabBar / Hide TabBar
    @MainActor static func hideTabBar() {
        UIWindow.keyWindow?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.setHidden(true)
            }
        })
    }
}

/// UITabBar 扩展：设置隐藏状态及动画
/// UITabBar extension: Set hidden state with animation
extension UITabBar {
    /// 设置 TabBar 隐藏状态
    /// Set TabBar hidden state
    /// - Parameters:
    ///   - hidden: 是否隐藏 / Whether to hide
    ///   - animated: 是否动画 / Whether to animate
    ///   - duration: 动画时长 / Animation duration
    func setHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        let tabBarHeight: CGFloat = self.frame.size.height
        let tabBarPositionY: CGFloat = UIScreen.main.bounds.height - (hidden ? 0 : tabBarHeight)
        
        guard animated else {
            self.frame.origin.y = tabBarPositionY
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.frame.origin.y = tabBarPositionY
        }
    }
}

#endif
