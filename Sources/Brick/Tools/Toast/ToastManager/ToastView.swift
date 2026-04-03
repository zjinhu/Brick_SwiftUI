//
//  ToastView.swift
//  Toast
//
//  Created by iOS on 2023/5/4.
//  Toast视图组件/Toast view component
//  Toast显示的动画视图/Animate view for Toast display

import SwiftUI
#if !os(visionOS)
/// Toast视图/Toast view
/// - Content: 内容视图类型/Content view type
struct ToastView<Content: View>: View {
    @StateObject private var keyboardObserver = KeyboardManager()
    
    /// 初始化Toast视图/Initialize Toast view
    /// - Parameters:
    ///   - isActive: 激活状态绑定/Active state binding
    ///   - padding: 内边距/Padding
    ///   - defaultOffset: 默认偏移量/Default offset
    ///   - content: 内容视图构建闭包/Content view build closure
    init(isActive: Binding<Bool>,
         padding: CGFloat = 10,
         defaultOffset: CGFloat = 0,
         @ViewBuilder content: @escaping ContentBuilder) {
        _isActive = isActive
        self.padding = padding
        self.defaultOffset = defaultOffset
        self.content = content
    }
    
    /// 内容构建器类型别名/Content builder type alias
    typealias ContentBuilder = (_ isActive: Bool) -> Content
    private let content: ContentBuilder
    private let defaultOffset: CGFloat
    private let padding: CGFloat
    @Binding private var isActive: Bool
    
    var body: some View {
        content(isActive)
            .animation(.spring(), value: isActive)
            .offset(y: !isActive ? offset : -offset)
            .padding(.horizontal, padding)
            .padding(.top, padding)
            .padding(.bottom, padding)
    }
}

/// ToastView扩展/ToastView extension
extension ToastView {
    
    /// 计算偏移量/Calculate offset
    var offset: CGFloat {
        if isActive { return 0 }
        return defaultOffset
    }
    
    /// 隐藏Toast/Hide Toast
    func dismiss() {
        isActive = false
    }
}
#endif
