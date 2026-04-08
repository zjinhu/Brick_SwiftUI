//
//  ScrollViewGestureButton.swift
//
//  Created by iOS on 2023/6/28.
//
//

#if os(iOS) || os(macOS) || os(watchOS)
import SwiftUI

/**
 滚动视图手势按钮/Scroll view gesture button
 这个按钮支持在ScrollView中以不同手势触发操作。
 This button supports triggering different gestures in a way
 that works within a `ScrollView`.
 
 不会阻塞滚动视图手势。代码经过大量测试，不会影响滚动。
 This button does not block scroll view gesture. The code is
 the result of much trial & error and has been tested to not
 affect scrolling.
 
 如果不需要在滚动视图中使用，请使用GestureButton替代。
 If you don't need to use a scroll view, you should consider
 using a ``GestureButton`` instead.
 
 注意：此视图使用ButtonStyle使手势生效，因此不能再应用其他样式。
 但可以使用传递给label builder的isPressed值来配置按下状态的按钮样式。
 Note that the view uses an underlying `ButtonStyle` to make
 gestures work. It can thus not apply another style, but you
 can use the `isPressed` value that is passed to the `label`
 builder, to configure the button view for the pressed state.
 */
public struct ScrollViewGestureButton<Label: View>: View {

    /// 初始化滚动视图手势按钮/Initialize scroll view gesture button
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
        repeatTimer: RepeatGestureTimer = .shared,
        repeatAction: Action? = nil,
        dragStartAction: DragAction? = nil,
        dragAction: DragAction? = nil,
        dragEndAction: DragAction? = nil,
        endAction: Action? = nil,
        label: @escaping LabelBuilder
    ) {
        self.isPressedBinding = isPressed ?? .constant(false)
        self._config = State(wrappedValue: GestureConfiguration(
            state: GestureState(),
            pressAction: pressAction ?? {},
            releaseInsideAction: releaseInsideAction ?? {},
            releaseOutsideAction: releaseOutsideAction ?? {},
            longPressDelay: longPressDelay,
            longPressAction: longPressAction ?? {},
            doubleTapTimeout: doubleTapTimeout,
            doubleTapAction: doubleTapAction ?? {},
            repeatTimer: repeatTimer,
            repeatAction: repeatAction,
            dragStartAction: dragStartAction,
            dragAction: dragAction,
            dragEndAction: dragEndAction,
            endAction: endAction ?? {},
            label: label
        ))
    }

    /// 无参数操作类型/Type for no-parameter action
    public typealias Action = () -> Void
    /// 拖动手势值操作类型/Type for drag gesture value action
    public typealias DragAction = (DragGesture.Value) -> Void
    /// 标签构建器类型/Type for label builder
    public typealias LabelBuilder = (_ isPressed: Bool) -> Label

    var isPressedBinding: Binding<Bool>

    @State
    var config: GestureConfiguration

    @State
    private var isPressed = false

    @State
    private var isPressedByGesture = false

    public var body: some View {
        Button(action: config.releaseInsideAction) {
            config.label(isPressed)
                .withDragGestureActions(
                    for: self.config,
                    isPressed: $isPressed,
                    isPressedByGesture: $isPressedByGesture
                )
        }
        .buttonStyle(
            Style(
                isPressed: $isPressed,
                isPressedByGesture: $isPressedByGesture,
                config: config)
        )
        .ss.onChange(of: isPressed) { newValue in
            isPressedBinding.wrappedValue = newValue
        }
        .ss.onChange(of: isPressedByGesture) { newValue in
            isPressed = newValue
        }
    }
}

extension ScrollViewGestureButton {

    class GestureState: ObservableObject {
        @Published var doubleTapDate = Date()
    }
    
    @MainActor
    struct GestureConfiguration {
        let state: GestureState
        let pressAction: Action
        let releaseInsideAction: Action
        let releaseOutsideAction: Action
        let longPressDelay: TimeInterval
        let longPressAction: Action
        let doubleTapTimeout: TimeInterval
        let doubleTapAction: Action
        let repeatTimer: RepeatGestureTimer
        let repeatAction: Action?
        let dragStartAction: DragAction?
        let dragAction: DragAction?
        let dragEndAction: DragAction?
        let endAction: Action
        let label: LabelBuilder

        func tryStartRepeatTimer() {
            if repeatTimer.isActive { return }
            guard let action = repeatAction else { return }
            repeatTimer.start(action: action)
        }

        func tryStopRepeatTimer() {
            guard repeatTimer.isActive else { return }
            repeatTimer.stop()
        }

        func tryTriggerDoubleTap() {
            let interval = Date().timeIntervalSince(state.doubleTapDate)
            let trigger = interval < doubleTapTimeout
            state.doubleTapDate = trigger ? .distantPast : Date()
            guard trigger else { return }
            doubleTapAction()
        }
    }

    struct Style: ButtonStyle {
        var isPressed: Binding<Bool>
        var isPressedByGesture: Binding<Bool>
        var config: GestureConfiguration

        @State
        var longPressDate = Date()

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .ss.onChange(of: configuration.isPressed) { isPressed in
                    longPressDate = Date()
                    if isPressed {
                        handleIsPressed()
                    } else {
                        handleIsEnded()
                    }
                }
        }
    }
}

private extension ScrollViewGestureButton.Style {

    func handleIsPressed() {
        isPressed.wrappedValue = true
        config.pressAction()
        tryTriggerLongPressAfterDelay(triggered: longPressDate)
    }

    func handleIsEnded() {
        if isPressedByGesture.wrappedValue { return }
        isPressed.wrappedValue = false
        config.endAction()
    }

    func tryTriggerLongPressAfterDelay(triggered date: Date) {
        DispatchQueue.main.asyncAfter(deadline: .now() + config.longPressDelay) {
            guard date == longPressDate else { return }
            config.longPressAction()
        }
    }
}

private extension View {

    typealias Action = () -> Void
    typealias DragAction = (DragGesture.Value) -> Void

    @ViewBuilder
    func withDragGestureActions<Label: View>(
        for config: ScrollViewGestureButton<Label>.GestureConfiguration,
        isPressed: Binding<Bool>,
        isPressedByGesture: Binding<Bool>
    ) -> some View {
        self.overlay(
            GeometryReader { geo in
                gesture(
                    TapGesture(count: 1).onEnded { _ in
                        let pressed = isPressed.wrappedValue
                        if !pressed { config.pressAction() }
                        toggleIsPressedForQuickTap(isPressed)
                        config.releaseInsideAction()
                        config.tryTriggerDoubleTap()
                        config.tryStopRepeatTimer()
                        if !pressed { config.endAction() }
                    }
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if !isPressedByGesture.wrappedValue {
                                config.dragStartAction?(value)
                            }
                            isPressedByGesture.wrappedValue = true
                            config.dragAction?(value)
                            if config.longPressDelay > 0.6 && !config.repeatTimer.isActive {
                                config.longPressAction()
                            }
                            config.tryStartRepeatTimer()
                        }
                        .onEnded { value in
                            config.dragEndAction?(value)
                            isPressedByGesture.wrappedValue = false
                            config.tryStopRepeatTimer()
                            if geo.contains(value.location) {
                                config.releaseInsideAction()
                            } else {
                                config.releaseOutsideAction()
                            }
                            config.endAction()
                        }
                )
            }
        )
    }

    func toggleIsPressedForQuickTap(_ isPressed: Binding<Bool>) {
        isPressed.wrappedValue = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isPressed.wrappedValue = false
        }
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
        private var items = (1...100).map { PreviewItem(id: $0) }

        var body: some View {
            VStack(spacing: 20) {

                PreviewHeader(state: state)
                    .padding(.horizontal)

                PreviewScrollGroup(title: "Buttons") {
                    ScrollViewGestureButton(
                        isPressed: $state.isPressed,
                        pressAction: { state.pressCount += 1 },
                        releaseInsideAction: { state.releaseInsideCount += 1 },
                        releaseOutsideAction: { state.releaseOutsideCount += 1 },
                        longPressDelay: 0.8,
                        longPressAction: { state.longPressCount += 1 },
                        doubleTapAction: { state.doubleTapCount += 1 },
                        repeatAction: { state.repeatTapCount += 1 },
                        dragStartAction: { state.dragStartValue = $0.location },
                        dragAction: { state.dragChangeValue = $0.location },
                        dragEndAction: { state.dragEndValue = $0.location },
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
                .frame(width: 100)
                .opacity(isPressed ? 0.5 : 1)
                .scaleEffect(isPressed ? 0.9 : 1)
                .animation(.default, value: isPressed)
                .padding()
                .background(Color.random())
                .cornerRadius(16)
        }
    }

    struct PreviewScrollGroup<Content: View>: View {

        let title: String
        let button: () -> Content

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .padding(.horizontal)
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(0...100, id: \.self) { _ in
                            button()
                        }
                    }.padding(.horizontal)
                }
            }
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
        var dragStartValue = CGPoint.zero

        @Published
        var dragChangeValue = CGPoint.zero

        @Published
        var dragEndValue = CGPoint.zero
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
                    label("Drag start", state.dragStartValue)
                    label("Drag change", state.dragChangeValue)
                    label("Drag end", state.dragEndValue)
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
