//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/7/11.
//  下划线文本环境键定义/Underline text environment key definitions

import SwiftUI

/// View扩展 - 下划线文本修饰器/View extension - Underline text modifiers
extension View {

    /// 设置标题/Sets title
    /// - Parameter title: 标题文本/Title text
    /// - Returns: 配置后的视图/Configured view
    public func underLineTitle(_ title: String) -> some View {
        environment(\.underLineTitle, title)
    }
    
    /// 设置标题颜色/Sets title color
    /// - Parameter color: 标题颜色/Title color
    /// - Returns: 配置后的视图/Configured view
    public func underLineTitleColor(_ color: Color) -> some View {
        environment(\.underLineTitleColor, color)
    }

    /// 设置标题字体/Sets title font
    /// - Parameter font: 标题字体/Title font
    /// - Returns: 配置后的视图/Configured view
    public func underLineTitleFont(_ font: Font) -> some View {
        environment(\.underLineTitleFont, font)
    }
    
    /// 设置文本/Sets text
    /// - Parameter text: 文本内容/Text content
    /// - Returns: 配置后的视图/Configured view
    public func underLineText(_ text: String) -> some View {
        environment(\.underLineText, text)
    }
    
    /// 设置文本字体/Sets text font
    /// - Parameter font: 文本字体/Text font
    /// - Returns: 配置后的视图/Configured view
    public func underLineTextFont(_ font: Font) -> some View {
        environment(\.underLineTextFont, font)
    }
    
    /// 设置文本颜色/Sets text color
    /// - Parameter color: 文本颜色/Text color
    /// - Returns: 配置后的视图/Configured view
    public func underLineTextColor(_ color: Color) -> some View {
        environment(\.underLineTextColor, color)
    }
    
    /// 设置文本高度/Sets text height
    /// - Parameter height: 文本高度/Text height
    /// - Returns: 配置后的视图/Configured view
    public func underLineTextHeight(_ height: CGFloat) -> some View {
        environment(\.underLineTextHeight, height)
    }
    
    /// 设置文本截断模式/Sets text truncation mode
    /// - Parameter mode: 截断模式/Truncation mode
    /// - Returns: 配置后的视图/Configured view
    public func underLineTextTruncationMode(_ mode: Text.TruncationMode) -> some View {
        environment(\.underLineTextTruncationMode, mode)
    }
    
    /// 设置下划线颜色/Sets underline color
    /// - Parameter color: 下划线颜色/Underline color
    /// - Returns: 配置后的视图/Configured view
    public func underLineColor(_ color: Color) -> some View {
        environment(\.underLineColor, color)
    }
    
    /// 设置下划线高度/Sets underline height
    /// - Parameter height: 下划线高度/Underline height
    /// - Returns: 配置后的视图/Configured view
    public func underLineHeight(_ height: CGFloat) -> some View {
        environment(\.underLineHeight, height)
    }

    /// 设置左侧视图/Sets leading view
    /// - Parameter content: 左侧视图构建闭包/Leading view build closure
    /// - Returns: 配置后的视图/Configured view
    public func underLineLeadingView<V: View>(_ content: @escaping () -> V) -> some View {
        environment(\.underLineLeadingView, { AnyView(content()) })
    }
    
    /// 设置右侧视图/Sets trailing view
    /// - Parameter content: 右侧视图构建闭包/Trailing view build closure
    /// - Returns: 配置后的视图/Configured view
    public func underLineTrailingView<V: View>(_ content: @escaping () -> V) -> some View {
        environment(\.underLineTrailingView, { AnyView(content()) })
    }
}

/// 环境值扩展/Environment values extension
@MainActor
extension EnvironmentValues {
    /// 文本截断模式/Text truncation mode
    var underLineTextTruncationMode: Text.TruncationMode {
        get { self[UnderLineTextTruncateModeEnvironmentKey.self] }
        set { self[UnderLineTextTruncateModeEnvironmentKey.self] = newValue }
    }
  
    /// 标题/Title
    var underLineTitle: String? {
        get { self[UnderLineTextTitleEnvironmentKey.self] }
        set { self[UnderLineTextTitleEnvironmentKey.self] = newValue }
    }
  
    /// 文本/Text
    var underLineText: String {
        get { self[UnderLineTextEnvironmentKey.self] }
        set { self[UnderLineTextEnvironmentKey.self] = newValue }
    }
  
    /// 下划线颜色/Underline color
    var underLineColor: Color? {
        get { self[UnderLineTextLineColorEnvironmentKey.self] }
        set { self[UnderLineTextLineColorEnvironmentKey.self] = newValue }
    }
  
    /// 下划线高度/Underline height
    var underLineHeight: CGFloat {
        get { self[UnderLineHeightEnvironmentKey.self] }
        set { self[UnderLineHeightEnvironmentKey.self] = newValue }
    }
  
    /// 标题字体/Title font
    var underLineTitleFont: Font {
        get { self[UnderLineTitleFontEnvironmentKey.self] }
        set { self[UnderLineTitleFontEnvironmentKey.self] = newValue }
    }
  
    /// 文本字体/Text font
    var underLineTextFont: Font {
        get { self[UnderLineTextFontEnvironmentKey.self] }
        set { self[UnderLineTextFontEnvironmentKey.self] = newValue }
    }
  
    /// 标题颜色/Title color
    var underLineTitleColor: Color? {
        get { self[UnderLineTitleColorEnvironmentKey.self] }
        set { self[UnderLineTitleColorEnvironmentKey.self] = newValue }
    }
  
    /// 文本高度/Text height
    var underLineTextHeight: CGFloat {
        get { self[UnderLineTextHeightEnvironmentKey.self] }
        set { self[UnderLineTextHeightEnvironmentKey.self] = newValue }
    }
  
    /// 文本颜色/Text color
    var underLineTextColor: Color? {
        get { self[UnderLineTextColorEnvironmentKey.self] }
        set { self[UnderLineTextColorEnvironmentKey.self] = newValue }
    }
  
    /// 右侧视图/Trailing view
    var underLineTrailingView: (() -> AnyView)? {
        get { self[UnderLineTrailingViewEnvironmentKey.self] }
        set { self[UnderLineTrailingViewEnvironmentKey.self] = newValue }
    }
    
    /// 左侧视图/Leading view
    var underLineLeadingView: (() -> AnyView)? {
        get { self[UnderLineLeadingViewEnvironmentKey.self] }
        set { self[UnderLineLeadingViewEnvironmentKey.self] = newValue }
    }
}

/// 环境键定义/Environment key definitions
@MainActor
struct UnderLineTextTruncateModeEnvironmentKey: @preconcurrency EnvironmentKey {
    static var defaultValue: Text.TruncationMode = .tail
}
@MainActor
struct UnderLineTextTitleEnvironmentKey: @preconcurrency EnvironmentKey {
    static var defaultValue: String?
}
@MainActor
struct UnderLineTextEnvironmentKey: @preconcurrency EnvironmentKey {
    static var defaultValue: String = ""
}
@MainActor
struct UnderLineTextLineColorEnvironmentKey: @preconcurrency EnvironmentKey {
    static var defaultValue: Color? = nil
}
@MainActor
struct UnderLineHeightEnvironmentKey: @preconcurrency EnvironmentKey {
    static var defaultValue: CGFloat = 1
}
@MainActor
struct UnderLineTitleFontEnvironmentKey: @preconcurrency EnvironmentKey {
    static var defaultValue: Font = .system(size: 15, weight: .bold)
}
@MainActor
struct UnderLineTextFontEnvironmentKey: @preconcurrency EnvironmentKey {
    static var defaultValue: Font = .system(size: 15)
}
@MainActor
struct UnderLineTitleColorEnvironmentKey: @preconcurrency EnvironmentKey {
    static var defaultValue: Color? = nil
}
@MainActor
struct UnderLineTrailingViewEnvironmentKey: @preconcurrency EnvironmentKey {
    static var defaultValue: (() -> AnyView)? { nil }
}
@MainActor
struct UnderLineTextHeightEnvironmentKey: @preconcurrency EnvironmentKey {
    static var defaultValue: CGFloat = 45
}
@MainActor
struct UnderLineTextColorEnvironmentKey: @preconcurrency EnvironmentKey {
    static var defaultValue: Color? = nil
}


struct UnderLineLeadingViewEnvironmentKey: EnvironmentKey {
    static var defaultValue: (() -> AnyView)? { nil }
}
