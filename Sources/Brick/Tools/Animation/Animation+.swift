//
//  Animation+.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

/// View 扩展添加动画完成回调/View extension for animation completion callback
extension View {
    /// 动画完成时触发回调/Trigger callback when animation completes
    /// - Parameters:
    ///   - animatedValue: 动画值 (需支持 VectorArithmetic)/Animated value (must support VectorArithmetic)
    ///   - completion: 动画完成时的回调/Callback when animation completes
    /// - Returns: 应用了动画完成修饰器的视图/View with animation completed modifier
    public func onAnimationCompleted(
        for animatedValue: some Sendable & VectorArithmetic,
        completion: @escaping @Sendable () -> Void
    ) -> some View {
        modifier(
            OnAnimationCompletedViewModifier(
                animatedValue: animatedValue,
                completion: completion
            )
        )
    }
}

/// 动画完成修饰器/Animation completed view modifier
private struct OnAnimationCompletedViewModifier<Value: Sendable & VectorArithmetic>: Animatable, ViewModifier {
    /// 完成回调类型/Completion callback type
    typealias Completion = @MainActor @Sendable () -> Void
    
    /// 可动画数据/Animatable data
    var animatableData: Value {
        didSet {
            guard animatableData == animatedValue else { return }
            Task { [completion] in
                await MainActor.run {
                    completion()
                }
            }
        }
    }

    /// 动画值/Animated value
    private let animatedValue: Value
    /// 完成回调/Completion callback
    private let completion: Completion

    /// 初始化/Initialize
    /// - Parameters:
    ///   - animatedValue: 动画值/Animated value
    ///   - completion: 完成回调/Completion callback
    init(animatedValue: Value, completion: @escaping Completion) {
        self.animatedValue = animatedValue
        self.animatableData = animatedValue
        self.completion = completion
    }

    func body(content: Content) -> some View {
        content
    }
}
