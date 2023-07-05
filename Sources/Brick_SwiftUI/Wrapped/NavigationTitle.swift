//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/7/5.
//

import SwiftUI

public extension Brick where Wrapped: View {
    func navigationTitle(_ title: String,
                         displayMode: NavigationBarItem.TitleDisplayMode = .automatic) -> some View{
        wrapped.modifier(
            NaviBarVersionModifier(title: title,
                                   displayMode: displayMode)
        )
    }
}

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
