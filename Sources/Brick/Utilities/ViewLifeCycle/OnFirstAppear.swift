//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/7/11.
//

import SwiftUI

// MARK: - 首次出现修饰器 / First Appear Modifier
struct OnFirstAppear: ViewModifier {
    let action: (() -> Void)?
    
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content.onAppear {
            if !hasAppeared {
                hasAppeared = true
                action?()
            }
        }
    }
}

// MARK: - View 扩展 / View Extension
public extension View {
    /// 视图首次出现时执行操作 / Perform action when view first appears
    /// - Parameter action: 要执行的操作 / Action to perform
    /// - Returns: 修改后的视图 / Modified view
    func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        modifier(OnFirstAppear(action: action))
    }
}
