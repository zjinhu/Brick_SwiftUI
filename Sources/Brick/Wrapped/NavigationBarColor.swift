//
//  SwiftUIView.swift
//  
//
//  Created by 狄烨 on 2023/8/30.
//

import SwiftUI
#if os(iOS)
import UIKit

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

public extension Brick where Wrapped: View {
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
