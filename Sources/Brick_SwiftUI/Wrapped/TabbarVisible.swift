//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/29.
//

import SwiftUI
#if os(iOS)
import UIKit

public extension Brick where Wrapped: View {
    func tabBar(_ visibility: Brick<Any>.Visibility) -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return wrapped.modifier(VisibleTabBar(visibility))
        }else{
            return wrapped.modifier(ShowTabBar(visibility))
        }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct VisibleTabBar: ViewModifier {
    @State private var show: Brick<Any>.Visibility = .automatic
    private var showTemp: Brick<Any>.Visibility
    init(_ show: Brick<Any>.Visibility) {
        self.showTemp = show
    }
    
    func body(content: Content) -> some View {
        return content
            .padding(.zero)
            .toolbar(show == .hidden ? .hidden : .visible, for: .tabBar)
            .onAppear{
                withAnimation {
                    show = showTemp
                }
            }
    }
}

struct ShowTabBar: ViewModifier {
    @State private var show: Brick<Any>.Visibility
    
    init(_ show: Brick<Any>.Visibility) {
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
