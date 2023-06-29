//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/29.
//

import SwiftUI
import UIKit
struct TabBarModifier {
    static func showTabBar() {
        UIWindow.keyWindow?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = false
            }
        })
    }
    
    static func hideTabBar() {
        UIWindow.keyWindow?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = true
            }
        })
    }
}

struct ShowTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            DispatchQueue.main.async {
                TabBarModifier.showTabBar()
            }
        }
    }
}

struct HiddenTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            DispatchQueue.main.async {
                TabBarModifier.hideTabBar()
            }
        }
    }
}

@available(iOS, deprecated: 16)
extension View {
    public func showTabBar() -> some View {
        return self.modifier(ShowTabBar())
    }

    public func hiddenTabBar() -> some View {
        return self.modifier(HiddenTabBar())
    }
}
