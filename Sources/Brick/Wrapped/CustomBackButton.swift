//
//  CustomBackButton.swift
//  Brick_SwiftUI
//
//  自定义导航返回按钮
//  Custom navigation back button
//
//  Created by iOS on 2023/6/26.
//

import SwiftUI
#if os(iOS)

/// 自定义返回按钮修饰器
/// Custom back button modifier
@available(macOS, unavailable)
@available(tvOS, unavailable)
struct CustomBackButton<Image: View>: ViewModifier {
    @Environment(\.dismiss) var dismiss
    let view: Image
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        view
                    }
                }
            }
    }
}

/// Brick 扩展：自定义导航返回按钮
/// Brick extension: Custom navigation back button
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension Brick where Wrapped: View {
    /// 添加自定义导航返回按钮
    /// Add custom navigation back button
    /// - Parameter content: 自定义返回按钮内容 / Custom back button content
    /// - Returns: 修改后的 View / Modified View
    @MainActor public func navigationCustomBackButton<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        wrapped.modifier(CustomBackButton(view: content()))
    }
}

#endif
