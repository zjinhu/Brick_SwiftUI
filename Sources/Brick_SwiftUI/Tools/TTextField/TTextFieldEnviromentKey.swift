//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/27.
//

import SwiftUI
struct TTextFieldColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .black
}

extension EnvironmentValues {
    var tTextFieldColor: Color {
        get { self[TTextFieldColorEnvironmentKey.self] }
        set { self[TTextFieldColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldTitleColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .black
}

extension EnvironmentValues {
    var tTextFieldTitleColor: Color {
        get { self[TTextFieldTitleColorEnvironmentKey.self] }
        set { self[TTextFieldTitleColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldPlaceHolderColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .gray.opacity(0.8)
}

extension EnvironmentValues {
    var tTextFieldPlaceHolderColor: Color {
        get { self[TTextFieldPlaceHolderColorEnvironmentKey.self] }
        set { self[TTextFieldPlaceHolderColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldDisableColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .gray.opacity(0.5)
}

extension EnvironmentValues {
    var tTextFieldDisableColor: Color {
        get { self[TTextFieldDisableColorEnvironmentKey.self] }
        set { self[TTextFieldDisableColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldBackgroundColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .white
}

extension EnvironmentValues {
    var tTextFieldBackgroundColor: Color {
        get { self[TTextFieldBackgroundColorEnvironmentKey.self] }
        set { self[TTextFieldBackgroundColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldErrorTextColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .red
}

extension EnvironmentValues {
    var tTextFieldErrorColor: Color {
        get { self[TTextFieldErrorTextColorEnvironmentKey.self] }
        set { self[TTextFieldErrorTextColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldBorderColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .gray
}

extension EnvironmentValues {
    var tTextFieldBorderColor: Color {
        get { self[TTextFieldBorderColorEnvironmentKey.self] }
        set { self[TTextFieldBorderColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldTrailingImageForegroundColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .black
}

extension EnvironmentValues {
    var tTextFieldTrailingImageColor: Color {
        get { self[TTextFieldTrailingImageForegroundColorEnvironmentKey.self] }
        set { self[TTextFieldTrailingImageForegroundColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldFocusedBorderColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .gray
}

extension EnvironmentValues {
    var tTextFieldFocusedBorderColor: Color {
        get { self[TTextFieldFocusedBorderColorEnvironmentKey.self] }
        set { self[TTextFieldFocusedBorderColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldFocusedBorderEnableEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    var tTextFieldFocusedBorderColorEnable: Bool {
        get { self[TTextFieldFocusedBorderEnableEnvironmentKey.self] }
        set { self[TTextFieldFocusedBorderEnableEnvironmentKey.self] = newValue }
    }
}

public enum BorderType {
    case square
    case line
}

struct TTextFieldBorderTypeEnvironmentKey: EnvironmentKey {
    static var defaultValue: BorderType = .square
}
 
extension EnvironmentValues {
    var tTextFieldBorderType: BorderType {
        get { self[TTextFieldBorderTypeEnvironmentKey.self] }
        set { self[TTextFieldBorderTypeEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldDisableAutoCorrectionEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    var tTextFieldDisableAutoCorrection: Bool {
        get { self[TTextFieldDisableAutoCorrectionEnvironmentKey.self] }
        set { self[TTextFieldDisableAutoCorrectionEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldTitleFontEnvironmentKey: EnvironmentKey {
    static var defaultValue: Font = .system(size: 15)
}

extension EnvironmentValues {
    var tTextFieldTitleFont: Font {
        get { self[TTextFieldTitleFontEnvironmentKey.self] }
        set { self[TTextFieldTitleFontEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldErrorFontEnvironmentKey: EnvironmentKey {
    static var defaultValue: Font = .system(size: 15)
}

extension EnvironmentValues {
    var tTextFieldErrorFont: Font {
        get { self[TTextFieldErrorFontEnvironmentKey.self] }
        set { self[TTextFieldErrorFontEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldPlaceHolderFontEnvironmentKey: EnvironmentKey {
    static var defaultValue: Font = .system(size: 15)
}

extension EnvironmentValues {
    var tTextFieldPlaceHolderFont: Font {
        get { self[TTextFieldPlaceHolderFontEnvironmentKey.self] }
        set { self[TTextFieldPlaceHolderFontEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldBorderWidthEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat = 1
}

extension EnvironmentValues {
    var tTextFieldBorderWidth: CGFloat {
        get { self[TTextFieldBorderWidthEnvironmentKey.self] }
        set { self[TTextFieldBorderWidthEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldCornerRadiusEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat = 5
}

extension EnvironmentValues {
    var tTextFieldCornerRadius: CGFloat {
        get { self[TTextFieldCornerRadiusEnvironmentKey.self] }
        set { self[TTextFieldCornerRadiusEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldHeightEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat = 45
}

extension EnvironmentValues {
    var tTextFieldHeight: CGFloat {
        get { self[TTextFieldHeightEnvironmentKey.self] }
        set { self[TTextFieldHeightEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldTitleEnvironmentKey: EnvironmentKey {
    static var defaultValue: String?
}

extension EnvironmentValues {
    var tTextFieldTitle: String? {
        get { self[TTextFieldTitleEnvironmentKey.self] }
        set { self[TTextFieldTitleEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldPlaceHolderTextEnvironmentKey: EnvironmentKey {
    static var defaultValue: String = ""
}

extension EnvironmentValues {
    var tTextFieldPlaceHolderText: String {
        get { self[TTextFieldPlaceHolderTextEnvironmentKey.self] }
        set { self[TTextFieldPlaceHolderTextEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldTruncateModeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Text.TruncationMode = .tail
}

extension EnvironmentValues {
    var tTextFieldTruncationMode: Text.TruncationMode {
        get { self[TTextFieldTruncateModeEnvironmentKey.self] }
        set { self[TTextFieldTruncateModeEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldLimitEnvironmentKey: EnvironmentKey {
    static var defaultValue: Int?
}

extension EnvironmentValues {
    var tTextFieldLimitCount: Int? {
        get { self[TTextFieldLimitEnvironmentKey.self] }
        set { self[TTextFieldLimitEnvironmentKey.self] = newValue }
    }
}

