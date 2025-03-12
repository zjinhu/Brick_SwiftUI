//
//  LoadingView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

struct ContainerView<Content: View>: View {
    typealias ContentBuilder = (_ isActive: Bool) -> Content
    private let content: ContentBuilder
    //绑定显示状态
    @Binding private var isActive: Bool
 
    init(isActive: Binding<Bool>, @ViewBuilder content: @escaping ContentBuilder ) {
        _isActive = isActive
        self.content = content
    }
    
    var body: some View {
        ZStack{
#if os(iOS) || os(macOS) || os(tvOS) || targetEnvironment(macCatalyst)
            GlassmorphismBlurView()
                .ignoresSafeArea()
#else
            Color.black.opacity(0.5)
#endif
            
            content(isActive)
                .frame(minWidth: 80, minHeight: 80)
                .background(Color.defaultBackground.opacity(0.7))
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5)
                .animation(.spring())
                
        }
        .edgesIgnoringSafeArea(.all)
        .opacity(!isActive ? 0 : 1)
    }
 
}
