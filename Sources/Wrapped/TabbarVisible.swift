//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/29.
//

import SwiftUI

public enum TabbarVisible: CaseIterable {
 
    case visible
    case hidden
 
    public mutating func toggle() {
        switch self {
        case .visible:
            self = .hidden
        case .hidden:
            self = .visible
        }
    }
}

#if os(iOS) && !os(xrOS)
import UIKit

public extension Brick where Wrapped: View {
    func tabBar(_ visibility: TabbarVisible) -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return wrapped.modifier(VisibleTabBar(visibility))
        }else{
            return wrapped.modifier(ShowTabBar(visibility))
        }
    }
}

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
            .toolbar(show == .hidden ? .hidden : .visible, for: .tabBar)
            .onAppear{
                withAnimation(.easeInOut){
                    show = showTemp
                }
            }
    }
}

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
