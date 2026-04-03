import SwiftUI
 
@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
extension EnvironmentValues {

    /// 应用于任何垂直可滚动内容的滚动指示器可见性 / The visiblity to apply to scroll indicators of any
    /// vertically scrollable content.
    public var verticalScrollIndicatorVisibility: Brick<Any>.ScrollIndicatorVisibility {
        get { self[VerticalIndicatorKey.self] }
        set { self[VerticalIndicatorKey.self] = newValue }
    }

    /// 应用于任何水平可滚动内容的滚动指示器可见性 / The visibility to apply to scroll indicators of any
    /// horizontally scrollable content.
    public var horizontalScrollIndicatorVisibility: Brick<Any>.ScrollIndicatorVisibility {
        get { self[HorizontalIndicatorKey.self] }
        set { self[HorizontalIndicatorKey.self] = newValue }
    }

    /// 可滚动内容与软件键盘交互的方式 / The way that scrollable content interacts with the software keyboard.
    ///
    /// 默认值为 ``Brick.ScrollDismissesKeyboardMode.automatic``。使用 ``View.ss.scrollDismissesKeyboard(_:)`` 修饰符配置此属性。
    /// The default value is ``Brick.ScrollDismissesKeyboardMode.automatic``. Use the
    /// ``View.ss.scrollDismissesKeyboard(_:)`` modifier to configure this
    /// property.
    public var scrollDismissesKeyboardMode: Brick<Any>.ScrollDismissesKeyboardMode {
        get { self[KeyboardDismissKey.self] }
        set { self[KeyboardDismissKey.self] = newValue }
    }

    /// 一个布尔值，指示与此环境关联的任何滚动视图是否允许滚动发生 / A Boolean value that indicates whether any scroll views associated
    /// with this environment allow scrolling to occur.
    ///
    /// 默认值为 `true`。使用 ``View.ss.scrollDisabled(_:)`` 修饰符配置此属性。
    /// The default value is `true`. Use the ``View.ss.scrollDisabled(_:)``
    /// modifier to configure this property.
    public var isScrollEnabled: Bool {
        get { self[ScrollEnabledKey.self] }
        set { self[ScrollEnabledKey.self] = newValue }
    }
    
}

private struct VerticalIndicatorKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Brick<Any>.ScrollIndicatorVisibility = .automatic
}

private struct HorizontalIndicatorKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Brick<Any>.ScrollIndicatorVisibility = .automatic
}

private struct KeyboardDismissKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Brick<Any>.ScrollDismissesKeyboardMode = .automatic
}

private struct ScrollEnabledKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Bool = true
}
