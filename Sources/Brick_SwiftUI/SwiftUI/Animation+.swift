//
//  Animation+.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI

//struct IntroductionView: View {
//
//    @State private var introTextOpacity = 0.0
//
//    var body: some View {
//        VStack {
//            Text("Welcome to SwiftLee")
//                .opacity(introTextOpacity)
//                .onAnimationCompleted(for: introTextOpacity) {
//                    print("Intro text animated in!")
//                }
//        }.onAppear(perform: {
//            withAnimation(.easeIn(duration: 1.0)) {
//                introTextOpacity = 1.0
//            }
//        })
//    }
//}

extension View {
    
    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - completion: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    public func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }
}

public struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {
    
    /// While animating, SwiftUI changes the old input value to the new target value using this property. This value is set to the old value until the animation completes.
    public var animatableData: Value {
        didSet {
            notifyCompletionIfFinished()
        }
    }
    
    /// The target value for which we're observing. This value is directly set once the animation starts. During animation, `animatableData` will hold the oldValue and is only updated to the target value once the animation completes.
    private var targetValue: Value
    
    /// The completion callback which is called once the animation completes.
    private var completion: () -> Void
    
    public init(observedValue: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = observedValue
        targetValue = observedValue
    }
    
    /// Verifies whether the current animation is finished and calls the completion callback if true.
    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else { return }
        
        /// Dispatching is needed to take the next runloop for the completion callback.
        /// This prevents errors like "Modifying state during view update, this will cause undefined behavior."
        DispatchQueue.main.async {
            self.completion()
        }
    }
    
    public func body(content: Content) -> some View {
        /// We're not really modifying the view so we can directly return the original input value.
        return content
    }
}
