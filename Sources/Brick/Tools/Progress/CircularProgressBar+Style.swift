//
//  CircularProgressBar+Style.swift
//
//  Created by iOS on 2023/6/28.
//
//

import SwiftUI

public extension CircularProgressBar {

    /// 用于样式化 ``CircularProgressBar`` 的类型/This type can style a ``CircularProgressBar``.
    struct Style {

        /// 初始化圆形进度条样式/Initialize circular progress bar style
        /// - Parameters:
        ///   - animation: 动画效果/Animation
        ///   - backgroundColor: 背景颜色/Background color
        ///   - decimals: 进度文本小数位数/Decimals for progress text
        ///   - progressColor: 进度条颜色/Progress color
        ///   - progressWidth: 进度条宽度/Progress width
        ///   - progressModifier: 进度条修饰器/Progress modifier
        ///   - showTitle: 是否显示标题/Whether to show title
        ///   - startAngle: 起始角度/Start angle
        ///   - strokeColor: 描边颜色/Stroke color
        ///   - strokeWidth: 描边宽度/Stroke width
        ///   - titleColor: 标题颜色/Title color
        ///   - titleFont: 标题字体/Title font
        ///   - titleModifier: 标题修饰器/Title modifier
        public init(
            animation: Animation = .bouncy,
            backgroundColor: Color = Color.black.opacity(0.9),
            decimals: Int = 0,
            progressColor: Color = .white,
            progressWidth: CGFloat = 8,
            progressModifier: @escaping ViewModifier = { $0 },
            showTitle: Bool = true,
            startAngle: Double = 0,
            strokeColor: Color = .black,
            strokeWidth: CGFloat = 2,
            titleColor: Color = .white,
            titleFont: Font = Font.body.bold(),
            titleModifier: @escaping ViewModifier = { $0 }
        ) {
            self.animation = animation
            self.backgroundColor = backgroundColor
            self.decimals = decimals
            self.progressColor = progressColor
            self.progressWidth = progressWidth
            self.progressModifier = progressModifier
            self.showTitle = showTitle
            self.startAngle = startAngle
            self.strokeColor = strokeColor
            self.strokeWidth = strokeWidth
            self.titleColor = titleColor
            self.titleFont = titleFont
            self.titleModifier = titleModifier
        }

        /// 视图修饰器类型/View modifier type
        public typealias ViewModifier = (AnyView) -> AnyView

        /// 动画效果/Animation
        public var animation: Animation
        /// 背景颜色/Background color
        public var backgroundColor: Color
        /// 小数位数/Decimals
        public var decimals: Int
        /// 进度颜色/Progress color
        public var progressColor: Color
        /// 进度宽度/Progress width
        public var progressWidth: CGFloat
        /// 进度修饰器/Progress modifier
        public var progressModifier: ViewModifier
        /// 是否显示标题/Whether to show title
        public var showTitle: Bool
        /// 起始角度/Start angle
        public var startAngle: Double
        /// 描边颜色/Stroke color
        public var strokeColor: Color
        /// 描边宽度/Stroke width
        public var strokeWidth: CGFloat
        /// 标题颜色/Title color
        public var titleColor: Color
        /// 标题字体/Title font
        public var titleFont: Font
        /// 标题修饰器/Title modifier
        public var titleModifier: ViewModifier
    }
}
@MainActor
public extension CircularProgressBar.Style {

    /// 标准圆形进度条样式/The standard circular progress bar style.
    ///
    /// 可设置此样式影响全局默认值/You can set this style to affect the global default.
    static var standard = Self()
}

public extension View {

    /// 为视图应用 ``CircularProgressBar/Style``/Apply a ``CircularProgressBar/Style`` to the view.
    func circularProgressBarStyle(
        _ style: CircularProgressBar.Style
    ) -> some View {
        self.environment(\.circularProgressBarStyle, style)
    }
}
@MainActor
private extension CircularProgressBar.Style {

    struct Key: @preconcurrency EnvironmentKey {

        @MainActor public static var defaultValue: CircularProgressBar.Style = .standard
    }
}

public extension EnvironmentValues {

    var circularProgressBarStyle: CircularProgressBar.Style {
        get { self [CircularProgressBar.Style.Key.self] }
        set { self [CircularProgressBar.Style.Key.self] = newValue }
    }
}
