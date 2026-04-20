//
//  ColorEx.swift
//  SwiftBrick
//
//  Created by iOS on 2023/4/20.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import SwiftUI

#if os(iOS)
import UIKit
// MARK: - Color Hex 初始化 / Color Hex Initialization
public extension Color {

    /// 转换为十六进制字符串 / Convert to hex string
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

// MARK: - 动态颜色 / Dynamic Colors
public extension Color {
    /// 动态颜色 (支持明暗模式) / Dynamic color (light/dark mode support)
    /// - Parameters:
    ///   - light: 浅色模式颜色 / Light mode color
    ///   - dark: 深色模式颜色 / Dark mode color
    static func dynamic(light: String, dark: String) -> Color {
        let l = UIColor(hex: light)
        let d = UIColor(hex: dark)
        return UIColor.dynamicColor(light: l, dark: d).toColor()
    }
    
    
    static func dynamic(light: Color, dark: Color) -> Color {
        let l = UIColor(light)
        let d = UIColor(dark)
        return UIColor.dynamicColor(light: l, dark: d).toColor()
    }
    
    
    /// 转换为 UIColor / Convert to UIColor
    func toUIColor() -> UIColor {
        return UIColor(self)
    }
}

public extension UIColor {
    /// 转换为 Color / Convert to Color
    func toColor() -> Color {
        return Color(self)
    }
}

/// 主题变化检测修饰器 / Theme change detection modifier
struct DetectThemeChange: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        
        if(colorScheme == .dark){
            content.colorInvert()
        }else{
            content
        }
    }
}

/// 视图扩展: 深色主题反转 / View extension: dark theme invert
public extension View {
    func invertOnDarkTheme() -> some View {
        modifier(DetectThemeChange())
    }
}
#endif

// MARK: - 主题相关颜色 / Theme Colors
public extension Color {
    /// 默认背景色 / Default background color
    static let defaultBackground = Color(light: .white, dark: .black)
    
    /// List 背景色 (适配明暗模式) / List background (light/dark mode)
    @ViewBuilder
    static func listBackground(forScheme scheme: ColorScheme) -> some View {
        if scheme == .light {
            Color.primary.colorInvert()
        } else {
            Color.primary.opacity(0.102)
        }
    }
}

public extension Color {
    /// 使用 UInt64 十六进制值初始化颜色 / Initialize color with UInt64 hex value
    /// - Parameters:
    ///   - hex: 十六进制值 (如 0xabcdef) / Hex value (e.g. 0xabcdef)
    ///   - alpha: 透明度 (0-1) / Alpha (0-1)
    init(hex: UInt64, alpha: CGFloat = 1) {
        let color = ColorRepresentable(hex: hex, alpha: alpha)
        self.init(color)
    }
    
    /// 使用十六进制字符串初始化颜色 / Initialize color with hex string
    /// 支持格式: "abcdef", "#abcdef", "0xabcdef" / Supports: "abcdef", "#abcdef", "0xabcdef"
    /// - Parameters:
    ///   - hex: 十六进制字符串 / Hex string
    ///   - alpha: 透明度 (0-1) / Alpha (0-1)
    init?(hex: String, alpha: CGFloat = 1) {
        guard let color = ColorRepresentable(hex: hex, alpha: alpha) else { return nil }
        self.init(color)
    }
    
    /// 静态方法: 使用 UInt64 十六进制值创建颜色 / Static method to create color with UInt64 hex
    static func hex(_ hex: UInt64, alpha: CGFloat = 1) -> Color {
        Color(hex: hex, alpha: alpha)
    }
    
    /// 静态方法: 使用十六进制字符串创建颜色 / Static method to create color with hex string
    static func hex(_ hex: String, alpha: CGFloat = 1) -> Color? {
        Color(hex: hex, alpha: alpha)
    }
    
    /// 使用字符串初始化颜色 (自动处理 # 和 0x 前缀) / Initialize with string (auto-handle # and 0x prefix)
    /// - Parameter hex: 十六进制字符串 / Hex string
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(red: r, green: g, blue: b, opacity: a)
            return
        }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            self.init(red: r, green: g, blue: b, opacity: a)
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

// MARK: - 随机颜色 / Random Colors
extension Color {
    /// 几乎透明的颜色 / Almost clear color
    public static var almostClear: Color {
        Color.black.opacity(0.0001)
    }
    
    /// 生成随机颜色 / Generate random color
    /// - Parameters:
    ///   - range: RGB 范围 / RGB range
    ///   - randomOpacity: 是否随机透明度 / Whether random opacity
    public static func random(in range: ClosedRange<Double> = 0...1,
                              randomOpacity: Bool = false) -> Color {
        Color(red: .random(in: range),
              green: .random(in: range),
              blue: .random(in: range),
              opacity: randomOpacity ? .random(in: 0...1) : 1)
    }
}

// MARK: - ColorRepresentable 初始化 / ColorRepresentable Initialization
public extension ColorRepresentable {
    
    /// Initialize a color with a hex value, e.g. `0xabcdef`.
    ///
    /// - Parameters:
    ///   - hex: The hex value to apply.
    ///   - alpha: The alpha value to apply, from 0 to 1.
    convenience init(hex: UInt64, alpha: CGFloat = 1) {
        let r = CGFloat((hex >> 16) & 0xff) / 255
        let g = CGFloat((hex >> 08) & 0xff) / 255
        let b = CGFloat((hex >> 00) & 0xff) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    /// Initialize a color with a hex string, e.g. `#abcdef`.
    ///
    /// This supports multiple string formats, like `abcdef`,
    /// `#abcdef`, `0xabcdef`, and `#abcdef`.
    ///
    /// - Parameters:
    ///   - hex: The hex string to parse.
    ///   - alpha: The alpha value to apply, from 0 to 1.
    convenience init?(hex: String, alpha: CGFloat = 1) {
        let hex = hex.cleanedForHex()
        guard hex.conforms(to: "[a-fA-F0-9]+") else { return nil }
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        self.init(hex: hexNumber, alpha: alpha)
    }
}

// MARK: - 字符串扩展 / String Extension
private extension String {
    
    /// 清理十六进制字符串 / Clean hex string
    func cleanedForHex() -> String {
        if hasPrefix("0x") {
            return String(dropFirst(2))
        }
        if hasPrefix("#") {
            return String(dropFirst(1))
        }
        return self
    }
    
    /// 正则匹配 / Regex match
    func conforms(to pattern: String) -> Bool {
        let pattern = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pattern.evaluate(with: self)
    }
}

// MARK: - 平台类型别名 / Platform Typealias
#if os(macOS)
import class AppKit.NSColor

/**
 This typealias helps bridging UIKit and AppKit when working
 with colors in a multi-platform context.
 */
public typealias ColorRepresentable = NSColor


#endif

#if canImport(UIKit)
import class UIKit.UIColor

/**
 This typealias helps bridging UIKit and AppKit when working
 with colors in a multi-platform context.
 */
public typealias ColorRepresentable = UIColor
#endif
