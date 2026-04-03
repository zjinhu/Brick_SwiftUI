//
//  View+Background.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  视图背景扩展 - 提供便捷的背景设置方法 / View background extension - provides convenient background setting methods
//

import SwiftUI

// MARK: - View.background / 视图背景

/// 视图背景扩展 / View background extension
extension View {
    /// 设置背景视图 / Set background view
    /// - Parameters:
    ///   - alignment: 对齐方式 / Alignment
    ///   - background: 背景视图构建闭包 / Background view building closure
    @_disfavoredOverload
    @inlinable
    public func background<Background: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ background: () -> Background
    ) -> some View {
        self.background(background(), alignment: alignment)
    }

    /// 设置背景颜色 / Set background color
    /// - Parameter color: 背景颜色 / Background color
    @_disfavoredOverload
    @inlinable
    public func background(_ color: Color) -> some View {
        background(
            PassthroughView{
                color
            }
            .eraseToAnyView()
        )
    }
    
    /// 填充背景颜色 (忽略安全区域) / Fill background color (ignoring safe area)
    /// - Parameter color: 背景颜色 / Background color
    @inlinable
    public func backgroundFill(_ color: Color) -> some View {
        background(color.edgesIgnoringSafeArea(.all))
    }
    
    /// 填充背景视图 (忽略安全区域) / Fill background view (ignoring safe area)
    /// - Parameters:
    ///   - fill: 填充视图 / Fill view
    ///   - alignment: 对齐方式 / Alignment
    @inlinable
    public func backgroundFill<BackgroundFill: View>(
        _ fill: BackgroundFill,
        alignment: Alignment = .center
    ) -> some View {
        background(fill.edgesIgnoringSafeArea(.all), alignment: alignment)
    }
    
    /// 填充背景视图 (忽略安全区域，闭包版本) / Fill background view (ignoring safe area, closure version)
    /// - Parameters:
    ///   - alignment: 对齐方式 / Alignment
    ///   - fill: 填充视图构建闭包 / Fill view building closure
    @inlinable
    public func backgroundFill<BackgroundFill: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ fill: () -> BackgroundFill
    ) -> some View {
        backgroundFill(fill())
    }
#if os(iOS)
    /// 清除全屏背景色，使背景透明 / Clear fullScreenCover background to make it transparent
    /// 当使用 fullScreenCover 时使用 / Use when using fullScreenCover
    public func fullScreenCoverBackgroundClear() -> some View {
        background(
            FullScreenCoverBackgroundClear()
        )
    }
#endif
}

// MARK: - PassthroughView / 穿透视图

/// 穿透视图 - 透明传递视图 / Passthrough view - transparent pass-through view
public struct PassthroughView<Content: View>: View {
    @usableFromInline
    let content: Content
    
    @inlinable
    public init(content: Content) {
        self.content = content
    }
    
    @inlinable
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    @inlinable
    public var body: some View {
        content
    }
}

// MARK: - FullScreenCover Background Clear / 全屏背景清除

#if os(iOS)
/// 全屏背景清除 / Full screen cover background clear
struct FullScreenCoverBackgroundClear: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
#endif
