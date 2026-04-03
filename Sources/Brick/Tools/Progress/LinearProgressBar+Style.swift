//
//  LinearProgressBar+Style.swift
//
//  Created by iOS on 2023/6/28.
//
//

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
import SwiftUI
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension LinearProgressBar {

    /// 用于样式化 ``LinearProgressBar`` 的类型/This type can style a ``LinearProgressBar``.
    struct Style {

        /// 初始化样式/Initialize style
        /// - Parameters:
        ///   - animation: 动画效果/Animation
        ///   - height: 进度条高度/Progress bar height
        ///   - backgroundMaterial: 背景材质/Background material
        ///   - backgroundMaterialOpacity: 背景材质不透明度/Background material opacity
        ///   - backgroundColor: 背景颜色/Background color
        ///   - barColor: 进度条颜色/Bar color
        ///   - barPadding: 进度条内边距/Bar padding
        ///   - barShadow: 进度条阴影/Bar shadow
        public init(
            animation: Animation = .bouncy,
            height: Double = 10,
            backgroundMaterial: Material = .ultraThin,
            backgroundMaterialOpacity: Double = 1,
            backgroundColor: Color = .clear,
            barColor: Color = .accentColor,
            barPadding: Double = 0,
            barShadow: ViewShadowStyle = .progressBar
        ) {
            self.animation = animation
            self.height = height
            self.backgroundColor = backgroundColor
            self.backgroundMaterial = backgroundMaterial
            self.backgroundMaterialOpacity = backgroundMaterialOpacity
            self.barColor = barColor
            self.barPadding = barPadding
            self.barShadow = barShadow
        }

        /// 视图修饰器类型/View modifier type
        public typealias ViewModifier = (AnyView) -> AnyView

        /// 动画效果/Animation
        public var animation: Animation
        /// 高度/Height
        public var height: Double
        /// 背景材质/Background material
        public var backgroundMaterial: Material
        /// 背景材质不透明度/Background material opacity
        public var backgroundMaterialOpacity: Double
        /// 背景颜色/Background color
        public var backgroundColor: Color
        /// 进度条颜色/Bar color
        public var barColor: Color
        /// 进度条内边距/Bar padding
        public var barPadding: Double
        /// 进度条阴影/Bar shadow
        public var barShadow: ViewShadowStyle
    }
}
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@MainActor
public extension LinearProgressBar.Style {

    /// 标准线性进度条样式/The standard linear progress bar style.
    ///
    /// 可设置此样式影响全局默认值/You can set this style to affect the global default.
    static var standard = Self()

    /// 添加内边距的样式/A style that adds padding to the bar.
    static var padding = Self(barPadding: 2)

    /// 高个子且有内边距的样式/A style that makes the bar tall and adds padding.
    static var tallPadding = Self(height: 16, barPadding: 3)
}

public extension ViewShadowStyle {

    /// 可用于 ``LinearProgressBar`` 的样式/This style can be used with ``LinearProgressBar``.
    static let progressBar = Self(
        color: .black.opacity(0.4),
        radius: 2,
        x: 1
    )
}
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {

    /// 为视图应用 ``LinearProgressBar/Style``/Apply a ``LinearProgressBar/Style`` to the view.
    func linearProgressBarStyle(
        _ style: LinearProgressBar.Style
    ) -> some View {
        self.environment(\.linearProgressBarStyle, style)
    }
}
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private extension LinearProgressBar.Style {

    struct Key: @preconcurrency EnvironmentKey {

        @MainActor public static var defaultValue: LinearProgressBar.Style = .standard
    }
}
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension EnvironmentValues {

    var linearProgressBarStyle: LinearProgressBar.Style {
        get { self [LinearProgressBar.Style.Key.self] }
        set { self [LinearProgressBar.Style.Key.self] = newValue }
    }
}
#endif
