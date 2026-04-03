//
//  ObservableScrollView.swift
//  MetagAI
//
//  Created by iOS on 2024/8/28.
//

import SwiftUI

/// 可跟踪滚动位置的滚动视图 / A scroll view that tracks scroll position
public struct ScrollTrackingView<Content: View>: View {
    /// 当前滚动偏移量 / Current scroll offset
    @Binding var currentScroll: CGFloat
  
    /// 内容视图构建器 / Content view builder
    let contentViews: () -> Content
    
    /// 初始化滚动跟踪视图 / Initialize scroll tracking view
    /// - Parameters:
    ///   - currentScroll: 滚动偏移量绑定 / Scroll offset binding
    ///   - contentViews: 内容视图构建器 / Content view builder
    public init(currentScroll: Binding<CGFloat>,
         _ contentViews: @escaping () -> Content) {
        self._currentScroll = currentScroll
        self.contentViews = contentViews
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { geometry in
                Color.clear.preference(key: ScrollPreferenceKey.self, value: geometry.frame(in: .named("ScrollTrackingView")).minY)
            }
            contentViews()
        }
        .coordinateSpace(name: "ScrollTrackingView")
        .onScroll { offset in
            updateCurrentScroll(offset)
        }
    }
    
    private func updateCurrentScroll(_ offset: CGFloat) {
        currentScroll = offset
    }
}

/// 滚动偏好键，用于存储滚动偏移量 / Scroll preference key for storing scroll offset
public struct ScrollPreferenceKey: PreferenceKey {
    public static let defaultValue = CGFloat.zero

    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

/// 视图扩展，添加滚动偏移监听 / View extension for scroll offset observation
public extension View {
    /// 监听滚动偏移变化 / Listen for scroll offset changes
    /// - Parameter offset: 偏移量回调 / Offset callback
    func onScroll(offset: @escaping (CGFloat) -> Void) -> some View {
        onPreferenceChange(ScrollPreferenceKey.self) { offsetValue in
            offset(offsetValue)
        }
    }
}
