//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/29.
//

import SwiftUI
#if os(iOS)
import UIKit

extension View {
    public func showTabBar(_ show: Bool) -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return self.modifier(VisibleTabBar(showBar: show))
        }else{
            return self.modifier(ShowTabBar(showBar: show))
        }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct VisibleTabBar: ViewModifier {
    @State private var showBar: Bool = false
    private var showBarTemp: Bool
    init(showBar: Bool) {
        self.showBarTemp = showBar
    }
    
    func body(content: Content) -> some View {
        return content
            .padding(.zero)
            .toolbar(showBar ? .visible : .hidden, for: .tabBar)
            .onAppear{
                withAnimation {
                    showBar = showBarTemp
                }
            }
    }
}

struct ShowTabBar: ViewModifier {
    @State private var showBar: Bool
    
    init(showBar: Bool) {
        self.showBar = showBar
    }
    
    func body(content: Content) -> some View {
        return content
            .padding(.zero)
            .onAppear {
                DispatchQueue.main.async {
                    if showBar{
                        TabBarModifier.showTabBar()
                    }else{
                        TabBarModifier.hideTabBar()
                    }
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

#endif
