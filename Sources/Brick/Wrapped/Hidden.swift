//
//  Hidden.swift
//  Brick_SwiftUI
//
//  条件视图隐藏
//  Conditional view hiding
//  条件视图隐藏，支持过渡动画
//  Conditional view hiding with transition
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

/// Brick 扩展：条件隐藏
/// Brick extension: Conditional hide
public extension Brick where Wrapped: View {
    /// 条件隐藏视图
    /// Conditionally hide view
    /// - Parameters:
    ///   - isHidden: 是否隐藏 / Whether to hide
    ///   - transition: 过渡动画 / Transition
    /// - Returns: 修改后的 View / Modified View
    @MainActor @inlinable
    func hidden(_ isHidden: Bool,
                transition: AnyTransition = .identity) -> some View {
        wrapped.modifier(HiddenModifier(isHidden: isHidden,
                                        transition: transition))
    }
}

/// 条件隐藏修饰器
/// Conditional hide modifier
@frozen
public struct HiddenModifier: ViewModifier {
    
    public var isHidden: Bool

    public var transition: AnyTransition
    
    /// 初始化条件隐藏修饰器
    /// Initialize conditional hide modifier
    /// - Parameters:
    ///   - isHidden: 是否隐藏 / Whether to hide
    ///   - transition: 过渡动画 / Transition (default: opacity)
    @inlinable
    public init(isHidden: Bool,
                transition: AnyTransition = .opacity) {
        self.isHidden = isHidden
        self.transition = transition
    }

    public func body(content: Content) -> some View {
        if isHidden {
            content
                .hidden()
        } else {
            content
                .transition(transition)
        }
    }
}
