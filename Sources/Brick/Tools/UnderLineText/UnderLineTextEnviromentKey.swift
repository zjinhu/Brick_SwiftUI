//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/7/11.
//

import SwiftUI

extension View {

    public func underLineTitle(_ title: String) -> some View {
        environment(\.underLineTitle, title)
    }
    
    public func underLineTitleColor(_ color: Color) -> some View {
        environment(\.underLineTitleColor, color)
    }

    public func underLineTitleFont(_ font: Font) -> some View {
        environment(\.underLineTitleFont, font)
    }
    
    public func underLineText(_ text: String) -> some View {
        environment(\.underLineText, text)
    }
    
    public func underLineTextFont(_ font: Font) -> some View {
        environment(\.underLineTextFont, font)
    }
    
    public func underLineTextColor(_ color: Color) -> some View {
        environment(\.underLineTextColor, color)
    }
    
    public func underLineTextHeight(_ height: CGFloat) -> some View {
        environment(\.underLineTextHeight, height)
    }
    
    public func underLineTextTruncationMode(_ mode: Text.TruncationMode) -> some View {
        environment(\.underLineTextTruncationMode, mode)
    }
    
    public func underLineColor(_ color: Color) -> some View {
        environment(\.underLineColor, color)
    }
    
    public func underLineHeight(_ height: CGFloat) -> some View {
        environment(\.underLineHeight, height)
    }

    public func underLineLeadingView<V: View>(_ content: @escaping () -> V) -> some View {
        environment(\.underLineLeadingView, { AnyView(content()) })
    }
    
    public func underLineTrailingView<V: View>(_ content: @escaping () -> V) -> some View {
        environment(\.underLineTrailingView, { AnyView(content()) })
    }
}

@MainActor
extension EnvironmentValues {
    var underLineTextTruncationMode: Text.TruncationMode {
        get { self[UnderLineTextTruncateModeEnvironmentKey.self] }
        set { self[UnderLineTextTruncateModeEnvironmentKey.self] = newValue }
    }
 
    var underLineTitle: String? {
        get { self[UnderLineTextTitleEnvironmentKey.self] }
        set { self[UnderLineTextTitleEnvironmentKey.self] = newValue }
    }
 
    var underLineText: String {
        get { self[UnderLineTextEnvironmentKey.self] }
        set { self[UnderLineTextEnvironmentKey.self] = newValue }
    }
 
    var underLineColor: Color? {
        get { self[UnderLineTextLineColorEnvironmentKey.self] }
        set { self[UnderLineTextLineColorEnvironmentKey.self] = newValue }
    }
 
    var underLineHeight: CGFloat {
        get { self[UnderLineHeightEnvironmentKey.self] }
        set { self[UnderLineHeightEnvironmentKey.self] = newValue }
    }
 
    var underLineTitleFont: Font {
        get { self[UnderLineTitleFontEnvironmentKey.self] }
        set { self[UnderLineTitleFontEnvironmentKey.self] = newValue }
    }
 
    var underLineTextFont: Font {
        get { self[UnderLineTextFontEnvironmentKey.self] }
        set { self[UnderLineTextFontEnvironmentKey.self] = newValue }
    }
 
    var underLineTitleColor: Color? {
        get { self[UnderLineTitleColorEnvironmentKey.self] }
        set { self[UnderLineTitleColorEnvironmentKey.self] = newValue }
    }
 
    var underLineTextHeight: CGFloat {
        get { self[UnderLineTextHeightEnvironmentKey.self] }
        set { self[UnderLineTextHeightEnvironmentKey.self] = newValue }
    }
 
    var underLineTextColor: Color? {
        get { self[UnderLineTextColorEnvironmentKey.self] }
        set { self[UnderLineTextColorEnvironmentKey.self] = newValue }
    }
 
    var underLineTrailingView: (() -> AnyView)? {
        get { self[UnderLineTrailingViewEnvironmentKey.self] }
        set { self[UnderLineTrailingViewEnvironmentKey.self] = newValue }
    }
    
    var underLineLeadingView: (() -> AnyView)? {
        get { self[UnderLineLeadingViewEnvironmentKey.self] }
        set { self[UnderLineLeadingViewEnvironmentKey.self] = newValue }
    }
}
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
