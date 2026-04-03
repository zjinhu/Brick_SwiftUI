//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/27.
//  TTextField环境键定义/TTextField environment key definitions

import SwiftUI

/// 文本颜色环境键/Text color environment key
struct TTextFieldColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .black
}

/// 标题颜色环境键/Title color environment key
struct TTextFieldTitleColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .black
}

/// 占位符颜色环境键/Placeholder color environment key
struct TTextFieldPlaceHolderColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .gray.opacity(0.8)
}

/// 禁用状态颜色环境键/Disabled state color environment key
struct TTextFieldDisableColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .gray.opacity(0.5)
}

/// 背景颜色环境键/Background color environment key
struct TTextFieldBackgroundColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .white
}

/// 错误文本颜色环境键/Error text color environment key
struct TTextFieldErrorTextColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .red
}

/// 边框颜色环境键/Border color environment key
struct TTextFieldBorderColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .gray
}

/// 聚焦边框颜色环境键/Focused border color environment key
struct TTextFieldFocusedBorderColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .gray
}

/// 启用聚焦边框环境键/Enable focused border environment key
struct TTextFieldFocusedBorderEnableEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Bool = false
}

/// 边框类型枚举/Border type enum
public enum BorderType {
    /// 方形边框/Square border
    case square
    /// 线条边框/Line border
    case line
}

/// 边框类型环境键/Border type environment key
struct TTextFieldBorderTypeEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: BorderType = .square
}
 
/// 禁用自动纠正环境键/Disable auto correction environment key
struct TTextFieldDisableAutoCorrectionEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Bool = false
}

/// 标题字体环境键/Title font environment key
struct TTextFieldTitleFontEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Font = .system(size: 15, weight: .bold)
}

/// 错误字体环境键/Error font environment key
struct TTextFieldErrorFontEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Font = .system(size: 15)
}

/// 占位符字体环境键/Placeholder font environment key
struct TTextFieldPlaceHolderFontEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Font = .system(size: 15)
}

/// 边框宽度环境键/Border width environment key
struct TTextFieldBorderWidthEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: CGFloat = 1
}

/// 圆角环境键/Corner radius environment key
struct TTextFieldCornerRadiusEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: CGFloat = 5
}

/// 高度环境键/Height environment key
struct TTextFieldHeightEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: CGFloat = 45
}

/// 标题环境键/Title environment key
struct TTextFieldTitleEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: String?
}

/// 占位符文本环境键/Placeholder text environment key
struct TTextFieldPlaceHolderTextEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: String = ""
}

/// 截断模式环境键/Truncation mode environment key
struct TTextFieldTruncateModeEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Text.TruncationMode = .tail
}

/// 限制数量环境键/Limit count environment key
struct TTextFieldLimitEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Int?
}

/// 左侧视图环境键/Leading view environment key
struct TTextFieldLeadingViewEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: (() -> AnyView)? { nil }
}

/// 右侧视图环境键/Trailing view environment key
struct TTextFieldTrailingViewEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: (() -> AnyView)? { nil }
}

/// 密码图标颜色环境键/Password icon color environment key
struct TTextFieldSecureImageForegroundColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .black
}

/// 环境值扩展/Environment values extension
extension EnvironmentValues {
    /// 文本颜色/Text color
    var tTextFieldColor: Color {
        get { self[TTextFieldColorEnvironmentKey.self] }
        set { self[TTextFieldColorEnvironmentKey.self] = newValue }
    }

    /// 标题颜色/Title color
    var tTextFieldTitleColor: Color {
        get { self[TTextFieldTitleColorEnvironmentKey.self] }
        set { self[TTextFieldTitleColorEnvironmentKey.self] = newValue }
    }

    /// 占位符颜色/Placeholder color
    var tTextFieldPlaceHolderColor: Color {
        get { self[TTextFieldPlaceHolderColorEnvironmentKey.self] }
        set { self[TTextFieldPlaceHolderColorEnvironmentKey.self] = newValue }
    }

    /// 禁用状态颜色/Disabled color
    var tTextFieldDisableColor: Color {
        get { self[TTextFieldDisableColorEnvironmentKey.self] }
        set { self[TTextFieldDisableColorEnvironmentKey.self] = newValue }
    }

    /// 背景颜色/Background color
    var tTextFieldBackgroundColor: Color {
        get { self[TTextFieldBackgroundColorEnvironmentKey.self] }
        set { self[TTextFieldBackgroundColorEnvironmentKey.self] = newValue }
    }

    /// 错误颜色/Error color
    var tTextFieldErrorColor: Color {
        get { self[TTextFieldErrorTextColorEnvironmentKey.self] }
        set { self[TTextFieldErrorTextColorEnvironmentKey.self] = newValue }
    }
  
    /// 边框颜色/Border color
    var tTextFieldBorderColor: Color {
        get { self[TTextFieldBorderColorEnvironmentKey.self] }
        set { self[TTextFieldBorderColorEnvironmentKey.self] = newValue }
    }
  
    /// 右侧视图/Trailing view
    var tTextFieldTrailingView: (() -> AnyView)? {
        get { self[TTextFieldTrailingViewEnvironmentKey.self] }
        set { self[TTextFieldTrailingViewEnvironmentKey.self] = newValue }
    }
    
    /// 左侧视图/Leading view
    var tTextFieldLeadingView: (() -> AnyView)? {
        get { self[TTextFieldLeadingViewEnvironmentKey.self] }
        set { self[TTextFieldLeadingViewEnvironmentKey.self] = newValue }
    }
  
    /// 聚焦边框颜色/Focused border color
    var tTextFieldFocusedBorderColor: Color {
        get { self[TTextFieldFocusedBorderColorEnvironmentKey.self] }
        set { self[TTextFieldFocusedBorderColorEnvironmentKey.self] = newValue }
    }
  
    /// 启用聚焦边框/Enable focused border
    var tTextFieldFocusedBorderColorEnable: Bool {
        get { self[TTextFieldFocusedBorderEnableEnvironmentKey.self] }
        set { self[TTextFieldFocusedBorderEnableEnvironmentKey.self] = newValue }
    }
  
    /// 边框类型/Border type
    var tTextFieldBorderType: BorderType {
        get { self[TTextFieldBorderTypeEnvironmentKey.self] }
        set { self[TTextFieldBorderTypeEnvironmentKey.self] = newValue }
    }
  
    /// 禁用自动纠正/Disable auto correction
    var tTextFieldDisableAutoCorrection: Bool {
        get { self[TTextFieldDisableAutoCorrectionEnvironmentKey.self] }
        set { self[TTextFieldDisableAutoCorrectionEnvironmentKey.self] = newValue }
    }
  
    /// 标题字体/Title font
    var tTextFieldTitleFont: Font {
        get { self[TTextFieldTitleFontEnvironmentKey.self] }
        set { self[TTextFieldTitleFontEnvironmentKey.self] = newValue }
    }
  
    /// 错误字体/Error font
    var tTextFieldErrorFont: Font {
        get { self[TTextFieldErrorFontEnvironmentKey.self] }
        set { self[TTextFieldErrorFontEnvironmentKey.self] = newValue }
    }
  
    /// 占位符字体/Placeholder font
    var tTextFieldPlaceHolderFont: Font {
        get { self[TTextFieldPlaceHolderFontEnvironmentKey.self] }
        set { self[TTextFieldPlaceHolderFontEnvironmentKey.self] = newValue }
    }
  
    /// 边框宽度/Border width
    var tTextFieldBorderWidth: CGFloat {
        get { self[TTextFieldBorderWidthEnvironmentKey.self] }
        set { self[TTextFieldBorderWidthEnvironmentKey.self] = newValue }
    }
  
    /// 圆角/Corner radius
    var tTextFieldCornerRadius: CGFloat {
        get { self[TTextFieldCornerRadiusEnvironmentKey.self] }
        set { self[TTextFieldCornerRadiusEnvironmentKey.self] = newValue }
    }
  
    /// 高度/Height
    var tTextFieldHeight: CGFloat {
        get { self[TTextFieldHeightEnvironmentKey.self] }
        set { self[TTextFieldHeightEnvironmentKey.self] = newValue }
    }
  
    /// 标题/Title
    var tTextFieldTitle: String? {
        get { self[TTextFieldTitleEnvironmentKey.self] }
        set { self[TTextFieldTitleEnvironmentKey.self] = newValue }
    }
  
    /// 占位符文本/Placeholder text
    var tTextFieldPlaceHolderText: String {
        get { self[TTextFieldPlaceHolderTextEnvironmentKey.self] }
        set { self[TTextFieldPlaceHolderTextEnvironmentKey.self] = newValue }
    }
  
    /// 截断模式/Truncation mode
    var tTextFieldTruncationMode: Text.TruncationMode {
        get { self[TTextFieldTruncateModeEnvironmentKey.self] }
        set { self[TTextFieldTruncateModeEnvironmentKey.self] = newValue }
    }
  
    /// 限制数量/Limit count
    var tTextFieldLimitCount: Int? {
        get { self[TTextFieldLimitEnvironmentKey.self] }
        set { self[TTextFieldLimitEnvironmentKey.self] = newValue }
    }
  
    /// 密码图标颜色/Password icon color
    var tTextFieldSecureImageColor: Color {
        get { self[TTextFieldSecureImageForegroundColorEnvironmentKey.self] }
        set { self[TTextFieldSecureImageForegroundColorEnvironmentKey.self] = newValue }
    }
}

