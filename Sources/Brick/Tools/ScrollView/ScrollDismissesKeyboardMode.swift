import SwiftUI
 
@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
extension Brick where Wrapped == Any {

    /// 可滚动内容与软件键盘交互的方式 / The ways that scrollable content can interact with the software keyboard.
    ///
    /// 在调用 ``View.ss.scrollDismissesKeyboard(_:)`` 修饰符时使用此类型指定滚动视图的关闭行为。
    /// Use this type in a call to the ``View.ss.scrollDismissesKeyboard(_:)``
    /// modifier to specify the dismissal behavior of scrollable views.
    public struct ScrollDismissesKeyboardMode: Hashable, CustomStringConvertible {
        internal enum DismissMode: Hashable {
            case automatic
            case immediately
            case interactively
            case never
        }

        let dismissMode: DismissMode

        #if os(iOS) || targetEnvironment(macCatalyst)
        var scrollViewDismissMode: UIScrollView.KeyboardDismissMode {
            switch dismissMode {
            case .automatic: return .none
            case .immediately: return .onDrag
            case .interactively: return .interactive
            case .never: return .none
            }
        }
        #endif

        public var description: String {
            String(describing: dismissMode)
        }

        /// 根据周围上下文自动确定模式 / Determine the mode automatically based on the surrounding context.
        ///
        /// 默认情况下，``TextEditor`` 是交互式的，而 ``List`` 可滚动内容始终在滚动时关闭键盘。
        /// By default, a ``TextEditor`` is interactive while a ``List``
        /// of scrollable content always dismiss the keyboard on a scroll
        public static var automatic: Self { .init(dismissMode: .automatic) }

        /// 滚动开始时立即关闭键盘 / Dismiss the keyboard as soon as scrolling starts.
        public static var immediately: Self { .init(dismissMode: .immediately) }

        /// 允许用户在滚动操作中交互式关闭键盘 / Enable people to interactively dismiss the keyboard as part of the
        /// scroll operation.
        ///
        /// 如果手势进入键盘的显示区域，软件键盘的位置会跟踪驱动滚动操作的手势。
        /// 用户可以通过滚动将键盘移出显示来关闭键盘，或反向滚动方向以取消关闭。
        /// The software keyboard's position tracks the gesture that drives the
        /// scroll operation if the gesture crosses into the keyboard's area of the
        /// display. People can dismiss the keyboard by scrolling it off the
        /// display, or reverse the direction of the scroll to cancel the dismissal.
        public static var interactively: Self { .init(dismissMode: .interactively) }

        /// 绝不自动因滚动而关闭键盘 / Never dismiss the keyboard automatically as a result of scrolling.
        public static var never: Self { .init(dismissMode: .never) }

    }
    
}
