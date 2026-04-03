//
//  NavigationTitle.swift
//  Brick_SwiftUI
//
//  导航标题
//  Navigation title
//  导航标题与显示模式控制
//  Navigation title with display mode control
//
//  Created by iOS on 2023/7/5.
//

import SwiftUI

/// Brick 扩展：导航标题
/// Brick extension: Navigation title
public extension Brick where Wrapped: View {
    /// 设置导航标题
    /// Set navigation title
    /// - Parameters:
    ///   - title: 标题文本 / Title text
    ///   - displayMode: 显示模式 / Display mode
    /// - Returns: 修改后的 View / Modified View
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    func navigationTitle(_ title: String,
                         displayMode: NavigationBarItem.TitleDisplayMode = .automatic) -> some View{
        wrapped.modifier(
            NaviBarVersionModifier(title: title,
                                   displayMode: displayMode)
        )
    }
}

/// 导航栏版本修饰器
/// Navigation bar version modifier
@available(macOS, unavailable)
@available(tvOS, unavailable)
struct NaviBarVersionModifier : ViewModifier {
    var title : String
    var displayMode: NavigationBarItem.TitleDisplayMode
    
    @State var display: String = ""
    
    @ViewBuilder
    func body(content: Content) -> some View {
        
        content
            .navigationTitle(display)
            .navigationBarTitleDisplayMode( displayMode)
            .onAppear{
                display = title
            }
            .onDisappear{
                display = ""
            }
        
    }
}
