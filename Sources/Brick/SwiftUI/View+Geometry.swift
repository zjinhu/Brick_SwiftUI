//
//  SwiftUIView.swift
//
//
//  Created by iOS on 2023/6/28.
//


import SwiftUI

public extension View {
    
    /// Bind the view's safe area to a binding.
    ///
    /// Do not overuse this modifier. Since the size binding
    /// is calculated as the view is being rendered, it will
    /// start with an incorrect value, which causes glitches.
    func bindSafeAreaInsets(to binding: Binding<EdgeInsets>) -> some View {
        background(safeAreaBindingView(for: binding))
    }
    
    /// Bind the view's size to a binding.
    ///
    ///
    /// Do not overuse this modifier. Since the size binding
    /// is calculated as the view is being rendered, it will
    /// start with an incorrect value, which causes glitches. 
    func bindSize(to binding: Binding<CGSize>) -> some View {
        background(sizeBindingView(for: binding))
    }
}

private extension View {
    
    func changeStateAsync(_ action: @Sendable @escaping () -> Void) {
        DispatchQueue.main.async(execute: action)
    }
    
    func safeAreaBindingView(for binding: Binding<EdgeInsets>) -> some View {
        GeometryReader { geo in
            self.safeAreaBindingView(for: binding, geo: geo)
        }
    }
    
    func safeAreaBindingView(for binding: Binding<EdgeInsets>, geo: GeometryProxy) -> some View {
        let safeAreaInsets = geo.safeAreaInsets
        changeStateAsync {
            if binding.wrappedValue == safeAreaInsets { return }
            binding.wrappedValue = safeAreaInsets
        }
        return Color.clear
    }
    
    func sizeBindingView(for binding: Binding<CGSize>) -> some View {
        GeometryReader { geo in
            self.sizeBindingView(for: binding, geo: geo)
        }
    }
    
    func sizeBindingView(for binding: Binding<CGSize>, geo: GeometryProxy) -> some View {
        let size = geo.size
        changeStateAsync {
            if binding.wrappedValue == size { return }
            binding.wrappedValue = size
        }
        return Color.clear
    }
}
