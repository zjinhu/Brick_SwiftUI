import SwiftUI
 
@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
extension Brick where Wrapped == Any {

    /// 滚动指示器的可见性 / The visibility of scroll indicators of a UI element.
    ///
    /// 将此类型的值传递给 ``View.ss.scrollIndicators(_:axes:)`` 方法
    /// 以指定视图层次结构的滚动指示器首选可见性。
    /// Pass a value of this type to the ``View.ss.scrollIndicators(_:axes:)`` method
    /// to specify the preferred scroll indicator visibility of a view hierarchy.
    public struct ScrollIndicatorVisibility: Hashable, CustomStringConvertible {
        internal enum IndicatorVisibility: Hashable {
            case automatic
            case visible
            case hidden
        }

        let visibility: Visibility
        
        var scrollViewVisible: Bool {
            visibility != .hidden
        }

        public var description: String {
            String(describing: visibility)
        }

        /// 根据接受可见性配置的组件策略决定 / Scroll indicator visibility depends on the
        /// policies of the component accepting the visibility configuration.
        public static var automatic: ScrollIndicatorVisibility {
            .init(visibility: .automatic)
        }

        /// 显示滚动指示器 / Show the scroll indicators.
        ///
        /// 实际可见性取决于平台约定，如iOS的自动隐藏行为或macOS的用户偏好行为。
        /// The actual visibility of the indicators depends on platform
        /// conventions like auto-hiding behaviors in iOS or user preference
        /// behaviors in macOS.
        public static var visible: ScrollIndicatorVisibility {
            .init(visibility: .visible)
        }

        /// 隐藏滚动指示器 / Hide the scroll indicators.
        ///
        /// 默认情况下，macOS在连接鼠标时显示指示器。使用 ``never`` 表示更强烈的偏好，可以覆盖此行为。
        /// By default, scroll views in macOS show indicators when a
        /// mouse is connected. Use ``never`` to indicate
        /// a stronger preference that can override this behavior.
        public static var hidden: ScrollIndicatorVisibility {
            .init(visibility: .hidden)
        }
    }

}
