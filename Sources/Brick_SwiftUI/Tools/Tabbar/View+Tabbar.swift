//
//  View+Tabbar.swift
//  Example
//
//  Created by iOS on 2023/6/21.
//

import SwiftUI

extension View {
    public func tabBarItem<Selection: Tabable>(tab: Selection) -> some View {
        self.modifier(TabBarItemViewModifier(tab: tab))
    }
    
    public func tabBarForeground<V: View>(_ content: @escaping () -> V) -> some View {
        environment(\.tabBarForegroundView, { AnyView(content()) })
    }
    
    public func tabBarShape(_ shape: any Shape) -> some View {
        environment(\.tabBarShape, shape)
    }
    
    public func tabBarShadow(
        color: Color = Color.black.opacity(0.33),
        radius: CGFloat,
        x: CGFloat = 0,
        y: CGFloat = 0
    ) -> some View {
        environment(\.tabBarShadow, .init(color: color, radius: radius, x: x, y: y))
    }
    
    public func tabBarColor(_ color: Color) -> some View {
        environment(\.tabBarColor, color)
    }
    
    public func tabBarInPadding(_ padding: CGFloat) -> some View {
        environment(\.tabBarInPadding, padding)
    }
    
    public func tabBarHorizontalPadding(_ padding: CGFloat) -> some View {
        environment(\.tabBarHorizontalPadding, padding)
    }
    
    public func tabBarBottomPadding(_ padding: CGFloat) -> some View {
        environment(\.tabBarBottomPadding, padding)
    }
    
    public func tabBarHeight(_ height: CGFloat) -> some View {
        environment(\.tabBarHeight, height)
    }
    
    func foreground<V: View>(_ content: @escaping () -> V) -> some View {
        return self
            .overlay {
                GeometryReader { geo in
                    content()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                }
            }
    }
    
    @ViewBuilder
    public func visibility(_ visibility: TabbarVisible) -> some View {
        switch visibility {
        case .visible:
            self.transition(.move(edge: .bottom).combined(with: .opacity))
        case .hidden:
            hidden().transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}
