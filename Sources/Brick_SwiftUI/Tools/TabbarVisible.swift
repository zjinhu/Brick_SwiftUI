//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/29.
//

import SwiftUI
import UIKit

extension View {

    public func showTabBar() -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return self.toolbar(.visible, for: .tabBar)
        }else{
            return self.modifier(ShowTabBar())
        }
    }
    
    public func hiddenTabBar() -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return self.toolbar(.hidden, for: .tabBar)
        }else{
            return self.modifier(HiddenTabBar())
        }
    }
    
}

struct ShowTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding(.zero)
            .onAppear {
                DispatchQueue.main.async {
                    TabBarModifier.showTabBar()
                }
            }
    }
}

struct HiddenTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding(.zero)
            .onAppear {
                DispatchQueue.main.async {
                    TabBarModifier.hideTabBar()
                }
            }
    }
}

struct TabBarModifier {
    static func showTabBar() {
        UIWindow.keyWindow?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.setHidden(false)
            }
        })
    }
    
    static func hideTabBar() {
        UIWindow.keyWindow?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.setHidden(true)
            }
        })
    }
}

extension UITabBar {
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

