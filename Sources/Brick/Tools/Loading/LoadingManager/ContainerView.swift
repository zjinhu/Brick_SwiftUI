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
    let manager: LoadingManager
    init(isActive: Binding<Bool>,
         manager: LoadingManager,
         @ViewBuilder content: @escaping ContentBuilder ) {
        _isActive = isActive
        self.content = content
        self.manager = manager
    }
    
    var body: some View {
        ZStack{
#if os(iOS) || os(macOS) || os(tvOS) || targetEnvironment(macCatalyst)
            if let maskColor = manager.maskColor{
                maskColor
                    .ignoresSafeArea()
            }else{
                GlassmorphismBlurView()
                    .ignoresSafeArea()
            }
#else
            if let maskColor = manager.maskColor{
                maskColor
                    .ignoresSafeArea()
            }else{
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
            }
#endif
            
            content(isActive)
                .frame(minWidth: 80, minHeight: 80)
                .background(Color.defaultBackground.opacity(0.7))
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5)
                .animation(.spring(), value: isActive)
                
        }
        .edgesIgnoringSafeArea(.all)
        .opacity(!isActive ? 0 : 1)
    }
 
}
