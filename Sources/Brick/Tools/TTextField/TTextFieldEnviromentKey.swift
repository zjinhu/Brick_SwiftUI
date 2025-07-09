//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/27.
//

import SwiftUI

struct TTextFieldColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .black
}

struct TTextFieldTitleColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .black
}

struct TTextFieldPlaceHolderColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .gray.opacity(0.8)
}

struct TTextFieldDisableColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .gray.opacity(0.5)
}

struct TTextFieldBackgroundColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .white
}

struct TTextFieldErrorTextColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .red
}

struct TTextFieldBorderColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .gray
}

struct TTextFieldFocusedBorderColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .gray
}

struct TTextFieldFocusedBorderEnableEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Bool = false
}

public enum BorderType {
    case square
    case line
}

struct TTextFieldBorderTypeEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: BorderType = .square
}
 
struct TTextFieldDisableAutoCorrectionEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Bool = false
}

struct TTextFieldTitleFontEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Font = .system(size: 15, weight: .bold)
}

struct TTextFieldErrorFontEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Font = .system(size: 15)
}

struct TTextFieldPlaceHolderFontEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Font = .system(size: 15)
}

struct TTextFieldBorderWidthEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: CGFloat = 1
}

struct TTextFieldCornerRadiusEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: CGFloat = 5
}

struct TTextFieldHeightEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: CGFloat = 45
}

struct TTextFieldTitleEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: String?
}

struct TTextFieldPlaceHolderTextEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: String = ""
}

struct TTextFieldTruncateModeEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Text.TruncationMode = .tail
}

struct TTextFieldLimitEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Int?
}

struct TTextFieldLeadingViewEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: (() -> AnyView)? { nil }
}

struct TTextFieldTrailingViewEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: (() -> AnyView)? { nil }
}

struct TTextFieldSecureImageForegroundColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .black
}

extension EnvironmentValues {
    var tTextFieldColor: Color {
        get { self[TTextFieldColorEnvironmentKey.self] }
        set { self[TTextFieldColorEnvironmentKey.self] = newValue }
    }

    var tTextFieldTitleColor: Color {
        get { self[TTextFieldTitleColorEnvironmentKey.self] }
        set { self[TTextFieldTitleColorEnvironmentKey.self] = newValue }
    }

    var tTextFieldPlaceHolderColor: Color {
        get { self[TTextFieldPlaceHolderColorEnvironmentKey.self] }
        set { self[TTextFieldPlaceHolderColorEnvironmentKey.self] = newValue }
    }

    var tTextFieldDisableColor: Color {
        get { self[TTextFieldDisableColorEnvironmentKey.self] }
        set { self[TTextFieldDisableColorEnvironmentKey.self] = newValue }
    }

    var tTextFieldBackgroundColor: Color {
        get { self[TTextFieldBackgroundColorEnvironmentKey.self] }
        set { self[TTextFieldBackgroundColorEnvironmentKey.self] = newValue }
    }

    var tTextFieldErrorColor: Color {
        get { self[TTextFieldErrorTextColorEnvironmentKey.self] }
        set { self[TTextFieldErrorTextColorEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldBorderColor: Color {
        get { self[TTextFieldBorderColorEnvironmentKey.self] }
        set { self[TTextFieldBorderColorEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldTrailingView: (() -> AnyView)? {
        get { self[TTextFieldTrailingViewEnvironmentKey.self] }
        set { self[TTextFieldTrailingViewEnvironmentKey.self] = newValue }
    }
    
    var tTextFieldLeadingView: (() -> AnyView)? {
        get { self[TTextFieldLeadingViewEnvironmentKey.self] }
        set { self[TTextFieldLeadingViewEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldFocusedBorderColor: Color {
        get { self[TTextFieldFocusedBorderColorEnvironmentKey.self] }
        set { self[TTextFieldFocusedBorderColorEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldFocusedBorderColorEnable: Bool {
        get { self[TTextFieldFocusedBorderEnableEnvironmentKey.self] }
        set { self[TTextFieldFocusedBorderEnableEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldBorderType: BorderType {
        get { self[TTextFieldBorderTypeEnvironmentKey.self] }
        set { self[TTextFieldBorderTypeEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldDisableAutoCorrection: Bool {
        get { self[TTextFieldDisableAutoCorrectionEnvironmentKey.self] }
        set { self[TTextFieldDisableAutoCorrectionEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldTitleFont: Font {
        get { self[TTextFieldTitleFontEnvironmentKey.self] }
        set { self[TTextFieldTitleFontEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldErrorFont: Font {
        get { self[TTextFieldErrorFontEnvironmentKey.self] }
        set { self[TTextFieldErrorFontEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldPlaceHolderFont: Font {
        get { self[TTextFieldPlaceHolderFontEnvironmentKey.self] }
        set { self[TTextFieldPlaceHolderFontEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldBorderWidth: CGFloat {
        get { self[TTextFieldBorderWidthEnvironmentKey.self] }
        set { self[TTextFieldBorderWidthEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldCornerRadius: CGFloat {
        get { self[TTextFieldCornerRadiusEnvironmentKey.self] }
        set { self[TTextFieldCornerRadiusEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldHeight: CGFloat {
        get { self[TTextFieldHeightEnvironmentKey.self] }
        set { self[TTextFieldHeightEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldTitle: String? {
        get { self[TTextFieldTitleEnvironmentKey.self] }
        set { self[TTextFieldTitleEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldPlaceHolderText: String {
        get { self[TTextFieldPlaceHolderTextEnvironmentKey.self] }
        set { self[TTextFieldPlaceHolderTextEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldTruncationMode: Text.TruncationMode {
        get { self[TTextFieldTruncateModeEnvironmentKey.self] }
        set { self[TTextFieldTruncateModeEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldLimitCount: Int? {
        get { self[TTextFieldLimitEnvironmentKey.self] }
        set { self[TTextFieldLimitEnvironmentKey.self] = newValue }
    }
 
    var tTextFieldSecureImageColor: Color {
        get { self[TTextFieldSecureImageForegroundColorEnvironmentKey.self] }
        set { self[TTextFieldSecureImageForegroundColorEnvironmentKey.self] = newValue }
    }
}

