//
//  Label++.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  Label 扩展 - 提供 Label 的便捷初始化方法 / Label extension - provides convenient Label initialization methods
//

import SwiftUI

// MARK: - Label Title Extension / Label 标题扩展

/// Label 标题扩展 / Label title extension
extension Label where Title == Text {
    /// 从本地化字符串键创建 Label / Creates a label with a system icon image and a title generated from a localized string
    /// - Parameters:
    ///   - titleKey: 本地化字符串键 / Localized string key
    ///   - icon: 图标构建器 / Icon builder
        public init(_ titleKey: LocalizedStringKey, @ViewBuilder icon: () -> Icon) {
        self.init(title: { Text(titleKey) }, icon: icon)
    }
    
    /// 从字符串创建 Label / Creates a label with a system icon image and a title generated from a string
    /// - Parameters:
    ///   - title: 标题文本 / Title string
    ///   - icon: 图标构建器 / Icon builder
        public init<S: StringProtocol>(_ title: S,  @ViewBuilder icon: () -> Icon) {
        self.init(title: { Text(title) }, icon: icon)
    }
}

// MARK: - Label SF Symbol Extension / Label SF Symbol 扩展

/// Label SF Symbol 扩展 / Label SF Symbol extension
extension Label where Title == Text, Icon == Image {
    /// 从本地化字符串键创建带 SF Symbol 的 Label / Creates a label with a system icon image and a title generated from a localized string
    /// - Parameters:
    ///   - titleKey: 本地化字符串键 / Localized string key
    ///   - symbol: SF Symbol 名称 / SF Symbol name
        public init(_ titleKey: LocalizedStringKey, systemImage symbol: SFSymbolName) {
        self.init(titleKey, systemImage: symbol.symbolName)
    }
    
    /// 从字符串创建带 SF Symbol 的 Label / Creates a label with a system icon image and a title generated from a string
    /// - Parameters:
    ///   - title: 标题文本 / Title string
    ///   - symbol: SF Symbol 名称 / SF Symbol name
        public init<S: StringProtocol>(_ title: S, systemImage symbol: SFSymbolName) {
        self.init(title, systemImage: symbol.symbolName)
    }
}

// MARK: - View Label Extension / View Label 扩展

/// View 转换为 Label 扩展 / View to Label extension
public extension View {
    
    /// 将视图转换为 Label / Convert the view to a label
    /// - Parameters:
    ///   - text: Label 文本 / The label text
    ///   - bundle: Bundle 包 / Bundle
    /// - Returns: Label 视图 / Label view
    func label(
        _ text: LocalizedStringKey,
        bundle: Bundle? = nil
    ) -> some View {
        Label {
            Text(text, bundle: bundle)
        } icon: {
            self
        }
    }
}

// 1. 定义自定义样式
public struct RightIconLabelStyle: LabelStyle {
    var spacing: CGFloat = 2
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: spacing) {
            configuration.title // 先放文字
            configuration.icon  // 后放图标
        }
    }
}

// 2. 扩展 LabelStyle，支持优雅的“点语法”调用
extension LabelStyle where Self == RightIconLabelStyle {
    public static var rightIcon: RightIconLabelStyle { .init() }
    public static func rightIcon(spacing: CGFloat) -> RightIconLabelStyle { .init(spacing: spacing) }
}
