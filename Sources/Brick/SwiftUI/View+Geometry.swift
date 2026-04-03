//
//  SwiftUIView.swift
//
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI

public extension View {
    
    /// 将视图的安全区域绑定到Binding。/ Bind the view's safe area to a binding.
    ///
    /// 不要过度使用此修饰符。由于大小绑定是在视图渲染时计算的，/ Do not overuse this modifier. Since the size binding
    /// 初始值会不正确，可能导致闪烁。/ is calculated as the view is being rendered, it will
    /// / start with an incorrect value, which causes glitches.
    ///
    /// - Parameter binding: 要绑定的EdgeInsets。/ The binding to bind the safe area insets to.
    /// - Returns: 应用了绑定的视图。/ A view with the safe area binding applied.
    func bindSafeAreaInsets(to binding: Binding<EdgeInsets>) -> some View {
        background(safeAreaBindingView(for: binding))
    }
    
    /// 将视图的大小绑定到Binding。/ Bind the view's size to a binding.
    ///
    /// 不要过度使用此修饰符。由于大小绑定是在视图渲染时计算的，/ Do not overuse this modifier. Since the size binding
    /// 初始值会不正确，可能导致闪烁。/ is calculated as the view is being rendered, it will
    /// / start with an incorrect value, which causes glitches.
    ///
    /// - Parameter binding: 要绑定的CGSize。/ The binding to bind the size to.
    /// - Returns: 应用了绑定的视图。/ A view with the size binding applied.
    func bindSize(to binding: Binding<CGSize>) -> some View {
        background(sizeBindingView(for: binding))
    }
}

private extension View {
    
    /// 异步执行状态变更操作。/ Executes a state change action asynchronously.
    func changeStateAsync(_ action: @Sendable @escaping () -> Void) {
        DispatchQueue.main.async(execute: action)
    }
    
    /// 创建安全区域绑定视图。/ Creates a safe area binding view.
    func safeAreaBindingView(for binding: Binding<EdgeInsets>) -> some View {
        GeometryReader { geo in
            self.safeAreaBindingView(for: binding, geo: geo)
        }
    }
    
    /// 处理安全区域绑定的内部实现。/ Internal implementation for handling safe area binding.
    func safeAreaBindingView(for binding: Binding<EdgeInsets>, geo: GeometryProxy) -> some View {
        let safeAreaInsets = geo.safeAreaInsets
        changeStateAsync {
            if binding.wrappedValue == safeAreaInsets { return }
            binding.wrappedValue = safeAreaInsets
        }
        return Color.clear
    }
    
    /// 创建大小绑定视图。/ Creates a size binding view.
    func sizeBindingView(for binding: Binding<CGSize>) -> some View {
        GeometryReader { geo in
            self.sizeBindingView(for: binding, geo: geo)
        }
    }
    
    /// 处理大小绑定的内部实现。/ Internal implementation for handling size binding.
    func sizeBindingView(for binding: Binding<CGSize>, geo: GeometryProxy) -> some View {
        let size = geo.size
        changeStateAsync {
            if binding.wrappedValue == size { return }
            binding.wrappedValue = size
        }
        return Color.clear
    }
}