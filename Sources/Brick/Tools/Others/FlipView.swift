//
//  SwiftUIView.swift
//
//
//  Created by iOS on 2023/6/28.
//


import SwiftUI

/// 翻转方向/Flip direction
/// 定义翻转动画的方向。/Defines the direction of flip animation.
public enum FlipDirection {
    
    /// 向左翻转/Flip left
    case left
    /// 向右翻转/Flip right
    case right
    /// 向上翻转/Flip up
    case up
    /// 向下翻转/Flip down
    case down
}

/// 翻转视图/Flip view
/// 具有正面和背面视图的组件，可通过点击或滑动翻转显示另一面。/Component with front and back views that can be flipped by tap or swipe.
public struct FlipView<FrontView: View, BackView: View>: View {
    
    /// 初始化翻转视图/Initialize flip view
    /// - Parameters:
    ///   - front: 正面视图/Front view
    ///   - back: 背面视图/Back view
    ///   - isFlipped: 翻转状态绑定/Flip state binding
    ///   - flipDuration: 翻转动画时长，默认0.3/Flip animation duration, default 0.3
    ///   - tapDirection: 点击翻转方向，默认.right/Tap flip direction, default .right
    ///   - swipeDirections: 支持的滑动翻转方向数组/Supported swipe flip directions array
    public init(
        front: FrontView,
        back: BackView,
        isFlipped: Binding<Bool>,
        flipDuration: Double = 0.3,
        tapDirection: FlipDirection = .right,
        swipeDirections: [FlipDirection] = [.left, .right]
    ) {
        self.front = front
        self.back = back
        self._isFlipped = isFlipped
        self.flipDuration = flipDuration
        self.tapDirection = tapDirection
        self.swipeDirections = swipeDirections
    }
    
    /// 翻转状态绑定/Flip state binding
    @Binding private var isFlipped: Bool
    
    /// 正面视图/Front view
    private let front: FrontView
    /// 背面视图/Back view
    private let back: BackView
    /// 翻转动画时长/Flip animation duration
    private let flipDuration: Double
    /// 支持的滑动翻转方向/Supported swipe flip directions
    private let swipeDirections: [FlipDirection]
    /// 点击翻转方向/Tap flip direction
    private let tapDirection: FlipDirection
    
    @State
    private var cardRotation = 0.0

    @State
    private var contentRotation = 0.0

    @State
    private var lastDirection = FlipDirection.right
    
    public var body: some View {
        content
            .withTapGesture { flip(tapDirection) }
            .withSwipeGesture(action: swipe)
            .rotationEffect(.degrees(contentRotation), direction: tapDirection)
            .rotationEffect(.degrees(cardRotation), direction: tapDirection)
            .accessibility(addTraits: .isButton)
    }
}

private extension View {
    
    typealias FlipAction = (FlipDirection) -> Void
    
    func withTapGesture(action: @escaping () -> Void) -> some View {
        #if os(tvOS)
        Button(action: action) { self }
            .buttonStyle(.plain)
        #else
        self.onTapGesture(perform: action)
        #endif
    }
    
    func withSwipeGesture(action: @escaping FlipAction) -> some View {
        #if os(tvOS)
        self
        #else
        self.onSwipeGesture(
            up: { action(.up) },
            left: { action(.left) },
            right: { action(.right) },
            down: { action(.down) })
        #endif
    }
}

private extension FlipView {
    
    var content: some View {
        ZStack {
            if isFlipped {
                back
            } else {
                front
            }
        }
    }

    var cardAnimation: Animation {
        .linear(duration: flipDuration)
    }
    
    var contentAnimation: Animation {
        .linear(duration: 0.001).delay(flipDuration/2)
    }
    
    func flip(_ direction: FlipDirection) {
        let degrees = flipDegrees(for: direction)
        withAnimation(cardAnimation) {
            cardRotation += degrees
        }
        withAnimation(contentAnimation) {
            contentRotation += degrees
            isFlipped.toggle()
        }
    }
    
    func flipDegrees(for direction: FlipDirection) -> Double {
        switch direction {
        case .right, .up: return 180
        case .left, .down: return -180
        }
    }
    
    func swipe(_ direction: FlipDirection) {
        guard swipeDirections.contains(direction) else { return }
        flip(direction)
    }
}

private extension View {
    
    @ViewBuilder
    func rotationEffect(_ angles: Angle, direction: FlipDirection) -> some View {
        switch direction {
        case .left, .right: self.rotation3DEffect(angles, axis: (x: 0, y: 1, z: 0))
        case .up, .down: self.rotation3DEffect(angles, axis: (x: 1, y: 0, z: 0))
        }
    }
}


#Preview {
    
    struct Preview: View {
        
        @State
        private var isFlipped = false
        
        var body: some View {
            flipView
                .cornerRadius(10)
                .shadow(radius: 0, x: 0, y: 2)
                .padding()
        }

        var flipView: some View {
            FlipView(
                front: Color.green,
                back: Color.red,
                isFlipped: $isFlipped,
                flipDuration: 0.5,
                tapDirection: .right,
                swipeDirections: [.left, .right, .up, .down]
            )
        }
    }
    
    return Preview()
}
