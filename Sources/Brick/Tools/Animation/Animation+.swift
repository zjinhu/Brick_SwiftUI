//
//  Animation+.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

extension View {
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

private struct OnAnimationCompletedViewModifier<Value: Sendable & VectorArithmetic>: Animatable, ViewModifier {
    typealias Completion = @MainActor @Sendable () -> Void
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

    private let animatedValue: Value
    private let completion: Completion

    init(animatedValue: Value, completion: @escaping Completion) {
        self.animatedValue = animatedValue
        self.animatableData = animatedValue
        self.completion = completion
    }

    func body(content: Content) -> some View {
        content
    }
}
