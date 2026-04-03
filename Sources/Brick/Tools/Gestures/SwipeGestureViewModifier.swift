//
//  SwipeGestureViewModifier.swift
//
//  Created by iOS on 2023/6/28.
//
//

#if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
import SwiftUI

/**
 手势视图修饰器/Swipe gesture view modifier
 可为视图应用滑动手势，在特定方向滑动时触发操作。
 This view modifier can apply swipe gestures to a view, that
 trigger actions when being swiped in certain directions.
 
 可通过.onSwipeGesture视图修饰器使用。
 You can apply this with the `.onSwipeGesture` view modifier.
 */
public struct SwipeGestureViewModifier: ViewModifier {

    /// 初始化滑动手势视图修饰器/Initialize swipe gesture view modifier
    ///
    /// - Parameters:
    ///   - maximumTime: 手势可激活的最大时间，超过则取消，默认值为1/Max time gesture can be active before cancelling
    ///   - minimumDistance: 手势触发所需的最小拖动距离（点），默认值为10/Minimum distance in points to trigger
    ///   - maximumDistance: 手势可拖动的最大距离（点），超过则取消，默认值为100000/Maximum distance in points before cancelling
    ///   - gestureTimer: 手势计时器/Gesture timer
    ///   - up: 上滑时触发的操作/Action to trigger when swiped up
    ///   - left: 左滑时触发的操作/Action to trigger when swiped left
    ///   - right: 右滑时触发的操作/Action to trigger when swiped right
    ///   - down: 下滑时触发的操作/Action to trigger when swiped down
    public init(
        maximumTime: TimeInterval = 1,
        minimumDistance: CGFloat = 10,
        maximumDistance: CGFloat = 100_000,
        gestureTimer: GestureTimer = GestureTimer(),
        up: Action? = nil,
        left: Action? = nil,
        right: Action? = nil,
        down: Action? = nil
    ) {
        self.maximumTime = maximumTime
        self.minimumDistance = minimumDistance
        self.maximumDistance = maximumDistance
        self.gestureTimer = gestureTimer
        self.up = up
        self.left = left
        self.right = right
        self.down = down
    }

    /// 手势可激活的最大时间/Max time gesture can be active
    public var maximumTime: TimeInterval
    /// 触发所需的最小拖动距离/Minimum distance to trigger
    public var minimumDistance: CGFloat
    /// 最大拖动距离/Maximum distance allowed
    public var maximumDistance: CGFloat
    /// 手势计时器/Gesture timer
    public var gestureTimer: GestureTimer
    /// 上滑时触发的操作/Action for up swipe
    public var up: Action?
    /// 左滑时触发的操作/Action for left swipe
    public var left: Action?
    /// 右滑时触发的操作/Action for right swipe
    public var right: Action?
    /// 下滑时触发的操作/Action for down swipe
    public var down: Action?

    /// 无参数操作类型/Type for no-parameter action
    public typealias Action = () -> Void

    public func body(content: Content) -> some View {
        content.gesture(
            DragGesture(minimumDistance: minimumDistance)
                .onChanged { _ in gestureTimer.start() }
                .onEnded { gesture in
                    guard gestureTimer.elapsedTime < maximumTime else { return }
                    let translation = gesture.translation
                    let absHeight = abs(translation.height)
                    let absWidth = abs(translation.width)
                    let isVertical = absHeight > absWidth
                    let points = isVertical ? absHeight : absWidth
                    if points > maximumDistance { return }
                    if isVertical {
                        if translation.height < 0 {
                            up?()
                        } else {
                            down?()
                        }
                    } else {
                        if translation.width < 0 {
                            left?()
                        } else {
                            right?()
                        }
                    }
                }
        )
    }
}

public extension View {
    
    /// 添加滑动手势/Add swipe gestures
    /// 当视图在指定方向滑动时触发相应的操作。/Trigger actions when view is swiped in specified directions.
    ///
    /// - Parameters:
    ///   - maximumTime: 手势可激活的最大时间，超过则取消，默认值为1/Max time gesture can be active before cancelling
    ///   - minimumDistance: 手势触发所需的最小拖动距离（点），默认值为10/Minimum distance in points to trigger
    ///   - maximumDistance: 手势可拖动的最大距离（点），超过则取消，默认值为100000/Maximum distance in points before cancelling
    ///   - gestureTimer: 手势计时器/Gesture timer
    ///   - up: 上滑时触发的操作/Action to trigger when swiped up
    ///   - left: 左滑时触发的操作/Action to trigger when swiped left
    ///   - right: 右滑时触发的操作/Action to trigger when swiped right
    ///   - down: 下滑时触发的操作/Action to trigger when swiped down
    func onSwipeGesture(
        maximumTime: TimeInterval = 1,
        minimumDistance: CGFloat = 10,
        maximumDistance: CGFloat = 100_000,
        gestureTimer: GestureTimer = GestureTimer(),
        up: SwipeGestureViewModifier.Action? = nil,
        left: SwipeGestureViewModifier.Action? = nil,
        right: SwipeGestureViewModifier.Action? = nil,
        down: SwipeGestureViewModifier.Action? = nil
    ) -> some View {
        self.modifier(
            SwipeGestureViewModifier(
                maximumTime: maximumTime,
                minimumDistance: minimumDistance,
                maximumDistance: maximumDistance,
                gestureTimer: gestureTimer,
                up: up,
                left: left,
                right: right,
                down: down
            )
        )
    }
}
#endif
