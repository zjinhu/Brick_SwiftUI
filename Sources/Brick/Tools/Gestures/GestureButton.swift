//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

#if os(iOS) || os(macOS) || os(watchOS)
import SwiftUI

/**
 手势按钮/Gesture button
 这个按钮支持以最大化性能的方式触发不同的手势。
 This button supports triggering different gestures in a way
 that maximizes performance.
 
 注意：此按钮不能在ScrollView中使用，因为它会阻塞滚动视图手势。
 如需在ScrollView中实现多手势支持，请使用ScrollViewGestureButton。
 This button can't be used in a `ScrollView` since it blocks
 the scroll view gesture. To implement multi-gesture support
 in a `ScrollView`, use a ``ScrollViewGestureButton``.
 */
public struct GestureButton<Label: View>: View {

    /// 初始化手势按钮/Initialize gesture button
    ///
    /// - Parameters:
    ///   - isPressed: 按压状态绑定，用于跟踪按压状态/Pressed state binding to track pressed state
    ///   - pressAction: 按压时触发的操作/Action to trigger when button is pressed
    ///   - releaseInsideAction: 在按钮内部释放时触发的操作/Action to trigger when button is released inside
    ///   - releaseOutsideAction: 在按钮外部释放时触发的操作/Action to trigger when button is released outside
    ///   - longPressDelay: 按压被视为长按所需的时间，默认为GestureButtonDefaults.longPressDelay/The time for press to count as long press
    ///   - longPressAction: 长按时触发的操作/Action to trigger on long press
    ///   - doubleTapTimeout: 两次点击被视为双击的最大时间间隔，默认为GestureButtonDefaults.doubleTapTimeout/Max time between taps for double tap
    ///   - doubleTapAction: 双击时触发的操作/Action to trigger on double tap
    ///   - repeatDelay: 按压被视为重复触发所需的时间，默认为GestureButtonDefaults.repeatDelay/Time for press to count as repeat trigger
    ///   - repeatTimer: 用于重复操作的计时器，默认为RepeatGestureTimer.shared/Repeat timer for repeat action
    ///   - repeatAction: 按压时重复触发的操作/Action to repeat while button is pressed
    ///   - dragStartAction: 拖动手势开始时触发的操作/Action to trigger when drag gesture starts
    ///   - dragAction: 拖动手势变化时触发的操作/Action to trigger when drag gesture changes
    ///   - dragEndAction: 拖动手势结束时触发的操作/Action to trigger when drag gesture ends
    ///   - endAction: 按钮手势结束时触发的操作/Action to trigger when button gesture ends
    ///   - label: 按钮标签视图/Button label view
    public init(
        isPressed: Binding<Bool>? = nil,
        pressAction: Action? = nil,
        releaseInsideAction: Action? = nil,
        releaseOutsideAction: Action? = nil,
        longPressDelay: TimeInterval = GestureButtonDefaults.longPressDelay,
        longPressAction: Action? = nil,
        doubleTapTimeout: TimeInterval = GestureButtonDefaults.doubleTapTimeout,
        doubleTapAction: Action? = nil,
        repeatDelay: TimeInterval = GestureButtonDefaults.repeatDelay,
        repeatTimer: RepeatGestureTimer = .shared,
        repeatAction: Action? = nil,
        dragStartAction: DragAction? = nil,
        dragAction: DragAction? = nil,
        dragEndAction: DragAction? = nil,
        endAction: Action? = nil,
        label: @escaping LabelBuilder
    ) {
        self.isPressedBinding = isPressed ?? .constant(false)
        self.pressAction = pressAction
        self.releaseInsideAction = releaseInsideAction
        self.releaseOutsideAction = releaseOutsideAction
        self.longPressDelay = longPressDelay
        self.longPressAction = longPressAction
        self.doubleTapTimeout = doubleTapTimeout
        self.doubleTapAction = doubleTapAction
        self.repeatDelay = repeatDelay
        self.repeatTimer = repeatTimer
        self.repeatAction = repeatAction
        self.dragStartAction = dragStartAction
        self.dragAction = dragAction
        self.dragEndAction = dragEndAction
        self.endAction = endAction
        self.label = label
    }

    /// 无参数操作类型/Type for no-parameter action
    public typealias Action = () -> Void
    /// 拖动手势值操作类型/Type for drag gesture value action
    public typealias DragAction = (DragGesture.Value) -> Void
    /// 标签构建器类型/Type for label builder
    public typealias LabelBuilder = (_ isPressed: Bool) -> Label

    var isPressedBinding: Binding<Bool>

    /// 按压时触发的操作/Action to trigger when pressed
    let pressAction: Action?
    /// 在按钮内部释放时触发的操作/Action to trigger when released inside
    let releaseInsideAction: Action?
    /// 在按钮外部释放时触发的操作/Action to trigger when released outside
    let releaseOutsideAction: Action?
    /// 按压被视为长按所需的时间/Time for press to count as long press
    let longPressDelay: TimeInterval
    /// 长按时触发的操作/Action to trigger on long press
    let longPressAction: Action?
    /// 两次点击被视为双击的最大时间间隔/Max time between taps for double tap
    let doubleTapTimeout: TimeInterval
    /// 双击时触发的操作/Action to trigger on double tap
    let doubleTapAction: Action?
    /// 按压被视为重复触发所需的时间/Time for press to count as repeat trigger
    let repeatDelay: TimeInterval
    /// 用于重复操作的计时器/Repeat timer for repeat action
    let repeatTimer: RepeatGestureTimer
    /// 按压时重复触发的操作/Action to repeat while button is pressed
    let repeatAction: Action?
    /// 拖动手势开始时触发的操作/Action to trigger when drag gesture starts
    let dragStartAction: DragAction?
    /// 拖动手势变化时触发的操作/Action to trigger when drag gesture changes
    let dragAction: DragAction?
    /// 拖动手势结束时触发的操作/Action to trigger when drag gesture ends
    let dragEndAction: DragAction?
    /// 按钮手势结束时触发的操作/Action to trigger when button gesture ends
    let endAction: Action?
    /// 按钮标签构建器/Button label builder
    let label: LabelBuilder

    @State
    private var isPressed = false

    @State
    private var longPressDate = Date()

    @State
    private var releaseDate = Date()

    @State
    private var repeatDate = Date()

    public var body: some View {
        label(isPressed)
            .overlay(gestureView)
            .ss.onChange(of: isPressed) { isPressedBinding.wrappedValue = $0 }
            .accessibilityAddTraits(.isButton)
    }
}

private struct UnsafeSendableAction: @unchecked Sendable {

    let action: () -> Void

    func callAsFunction() {
        action()
    }
}

private extension GestureButton {

    var gestureView: some View {
        GeometryReader { geo in
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            tryHandlePress(value)
                            dragAction?(value)
                        }
                        .onEnded { value in
                            tryHandleRelease(value, in: geo)
                        }
                )
        }
    }
}

private extension GestureButton {

    func tryHandlePress(_ value: DragGesture.Value) {
        if isPressed { return }
        isPressed = true
        pressAction?()
        dragStartAction?(value)
        tryTriggerLongPressAfterDelay()
        tryTriggerRepeatAfterDelay()
    }

    func tryHandleRelease(_ value: DragGesture.Value, in geo: GeometryProxy) {
        if !isPressed { return }
        isPressed = false
        longPressDate = Date()
        repeatDate = Date()
        repeatTimer.stop()
        releaseDate = tryTriggerDoubleTap() ? .distantPast : Date()
        dragEndAction?(value)
        if geo.contains(value.location) {
            releaseInsideAction?()
        } else {
            releaseOutsideAction?()
        }
        endAction?()
    }

    func tryTriggerLongPressAfterDelay() {
        guard let action = longPressAction else { return }
        let date = Date()
        longPressDate = date
        let delay = longPressDelay
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard self.longPressDate == date else { return }
            action()
        }
    }

    func tryTriggerRepeatAfterDelay() {
        guard let action = repeatAction else { return }
        let sendableAction = UnsafeSendableAction(action: action)
        let date = Date()
        repeatDate = date
        let delay = repeatDelay
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard self.repeatDate == date else { return }
            repeatTimer.start(action: sendableAction.callAsFunction)
        }
    }

    func tryTriggerDoubleTap() -> Bool {
        let interval = Date().timeIntervalSince(releaseDate)
        let isDoubleTap = interval < doubleTapTimeout
        if isDoubleTap { doubleTapAction?() }
        return isDoubleTap
    }
}

private extension GeometryProxy {

    func contains(_ dragEndLocation: CGPoint) -> Bool {
        let x = dragEndLocation.x
        let y = dragEndLocation.y
        guard x > 0, y > 0 else { return false }
        guard x < size.width, y < size.height else { return false }
        return true
    }
}

#Preview {

    struct Preview: View {

        @StateObject
        var state = PreviewState()

        @State
        private var items = (1...3).map { PreviewItem(id: $0) }

        var body: some View {
            VStack(spacing: 20) {

                PreviewHeader(state: state)
                    .padding(.horizontal)

                PreviewButtonGroup(title: "Buttons:") {
                    GestureButton(
                        isPressed: $state.isPressed,
                        pressAction: { state.pressCount += 1 },
                        releaseInsideAction: { state.releaseInsideCount += 1 },
                        releaseOutsideAction: { state.releaseOutsideCount += 1 },
                        longPressDelay: 0.8,
                        longPressAction: { state.longPressCount += 1 },
                        doubleTapAction: { state.doubleTapCount += 1 },
                        repeatAction: { state.repeatTapCount += 1 },
                        dragStartAction: { state.dragStartedValue = $0.location },
                        dragAction: { state.dragChangedValue = $0.location },
                        dragEndAction: { state.dragEndedValue = $0.location },
                        endAction: { state.endCount += 1 },
                        label: { PreviewButton(color: .blue, isPressed: $0) }
                    )
                }
            }
        }
    }

    struct PreviewItem: Identifiable {

        var id: Int
    }

    struct PreviewButton: View {

        let color: Color
        let isPressed: Bool

        var body: some View {
            color
                .cornerRadius(10)
                .opacity(isPressed ? 0.5 : 1)
                .scaleEffect(isPressed ? 0.9 : 1)
                .animation(.default, value: isPressed)
                .padding()
                .background(Color.random())
                .cornerRadius(16)
        }
    }

    struct PreviewButtonGroup<Content: View>: View {

        let title: String
        let button: () -> Content

        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                HStack {
                    ForEach(0...3, id: \.self) { _ in
                        button()
                    }
                }.frame(maxWidth: .infinity)
            }.padding(.horizontal)
        }
    }

    class PreviewState: ObservableObject {

        @Published
        var isPressed = false

        @Published
        var pressCount = 0

        @Published
        var releaseInsideCount = 0

        @Published
        var releaseOutsideCount = 0

        @Published
        var endCount = 0

        @Published
        var longPressCount = 0

        @Published
        var doubleTapCount = 0

        @Published
        var repeatTapCount = 0

        @Published
        var dragStartedValue = CGPoint.zero

        @Published
        var dragChangedValue = CGPoint.zero

        @Published
        var dragEndedValue = CGPoint.zero
    }

    struct PreviewHeader: View {

        @ObservedObject
        var state: PreviewState

        var body: some View {
            VStack(alignment: .leading) {
                Group {
                    label("Pressed", state.isPressed ? "YES" : "NO")
                    label("Presses", state.pressCount)
                    label("Releases", state.releaseInsideCount + state.releaseOutsideCount)
                    label("     Inside", state.releaseInsideCount)
                    label("     Outside", state.releaseOutsideCount)
                    label("Ended", state.endCount)
                    label("Long presses", state.longPressCount)
                    label("Double taps", state.doubleTapCount)
                    label("Repeats", state.repeatTapCount)
                }
                Group {
                    label("Drag started", state.dragStartedValue)
                    label("Drag changed", state.dragChangedValue)
                    label("Drag ended", state.dragEndedValue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).stroke(.blue, lineWidth: 3))
        }

        func label(_ title: String, _ int: Int) -> some View {
            label(title, "\(int)")
        }

        func label(_ title: String, _ point: CGPoint) -> some View {
            label(title, "\(point.x.rounded()), \(point.y.rounded())")
        }

        func label(_ title: String, _ value: String) -> some View {
            HStack {
                Text("\(title):")
                Text(value).bold()
            }.lineLimit(1)
        }
    }

    return Preview()
}
#endif
