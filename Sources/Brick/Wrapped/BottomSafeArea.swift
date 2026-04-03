//
//  BottomSafeArea.swift
//  Brick_SwiftUI
//
//  底部安全区域插入
//  Bottom safe area inset
//  自定义底部安全区域插入，用于 iOS 15- 兼容
//  Custom bottom safe area inset for iOS 15- compatibility
//
//  Created by iOS on 2023/6/7.
//

import SwiftUI
/*
 使用示例 / Usage:
 ScrollView {
 }
 .ss.bottomSafeAreaInset(overlayContent)
 */
@MainActor
extension Brick where Wrapped: View {
    /// 添加底部安全区域插入
    /// Add bottom safe area inset
    /// - Parameter content: 底部叠加内容构建器 / Bottom overlay content builder
    /// - Returns: 修改后的 View / Modified View
    @ViewBuilder
    public func bottomSafeAreaInset<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            wrapped.safeAreaInset(edge: .bottom, spacing: 0, content: { content() })
        } else {
            wrapped.modifier(BottomInsetViewModifier(overlayContent: content()))
        }


    }
    
    /// 添加底部安全区域插入 (使用已有视图)
    /// Add bottom safe area inset (using existing view)
    /// - Parameter overlayContent: 底部叠加内容 / Bottom overlay content
    /// - Returns: 修改后的 View / Modified View
    @ViewBuilder
    public func bottomSafeAreaInset<OverlayContent: View>(_ overlayContent: OverlayContent) -> some View {
                    
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            wrapped.safeAreaInset(edge: .bottom, spacing: 0, content: { overlayContent })
        } else {
            wrapped.modifier(BottomInsetViewModifier(overlayContent: overlayContent))
        }


    }
}

/// 底部安全区域插入修饰器 (iOS 15-)
/// Bottom safe area inset modifier (iOS 15-)
struct BottomInsetViewModifier<OverlayContent: View>: ViewModifier {
    @Environment(\.bottomSafeAreaInset) var ancestorBottomSafeAreaInset: CGFloat
    var overlayContent: OverlayContent
    @State var overlayContentHeight: CGFloat = 0
    
    func body(content: Self.Content) -> some View {
        content
            .environment(\.bottomSafeAreaInset, overlayContentHeight + ancestorBottomSafeAreaInset)
            .overlay(
                overlayContent
                    .readHeight {
                        overlayContentHeight = $0
                    }
                    .padding(.bottom, ancestorBottomSafeAreaInset)
                ,
                alignment: .bottom
            )
    }
}

/// 底部安全区域插入环境键
/// Bottom safe area inset environment key
@MainActor
struct BottomSafeAreaInsetKey: @preconcurrency EnvironmentKey {
    static var defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    /// 底部安全区域插入值
    /// Bottom safe area inset value
    var bottomSafeAreaInset: CGFloat {
        get { self[BottomSafeAreaInsetKey.self] }
        set { self[BottomSafeAreaInsetKey.self] = newValue }
    }
}

/// 额外底部安全区域插入视图
/// Extra bottom safe area inset view
struct ExtraBottomSafeAreaInset: View {
    @Environment(\.bottomSafeAreaInset) var bottomSafeAreaInset: CGFloat
    
    var body: some View {
        Spacer(minLength: bottomSafeAreaInset)
    }
}
