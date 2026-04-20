//
//  LoadingView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

/// Loading容器视图/Loading container view
/// - Content: 内容视图类型/Content view type
struct ContainerView<Content: View>: View {
    /// 内容构建器类型/Content builder type
    typealias ContentBuilder = (_ isActive: Bool) -> Content
    /// 内容构建器/Content builder
    private let content: ContentBuilder
    /// 绑定显示状态/Bound display state
    @Binding private var isActive: Bool
    /// Loading管理器/Loading manager
    let manager: LoadingManager
    
    /// 初始化容器视图/Initialize container view
    /// - Parameters:
    ///   - isActive: 显示状态绑定/Display state binding
    ///   - manager: Loading管理器/Loading manager
    ///   - content: 内容视图构建器/Content view builder
    init(isActive: Binding<Bool>,
         manager: LoadingManager,
         @ViewBuilder content: @escaping ContentBuilder ) {
        _isActive = isActive
        self.content = content
        self.manager = manager
    }
    
    var body: some View {
        ZStack{
#if os(iOS) || os(tvOS)
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
