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
    var textColor: Color {
        get { self[TTextFieldColorEnvironmentKey.self] }
        set { self[TTextFieldColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldTitleColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .black
}

extension EnvironmentValues {
    var titleColor: Color {
        get { self[TTextFieldTitleColorEnvironmentKey.self] }
        set { self[TTextFieldTitleColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldPlaceHolderColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .gray.opacity(0.8)
}

extension EnvironmentValues {
    var placeHolderTextColor: Color {
        get { self[TTextFieldPlaceHolderColorEnvironmentKey.self] }
        set { self[TTextFieldPlaceHolderColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldDisableColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .gray.opacity(0.5)
}

extension EnvironmentValues {
    var disableColor: Color {
        get { self[TTextFieldDisableColorEnvironmentKey.self] }
        set { self[TTextFieldDisableColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldBackgroundColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .white
}

extension EnvironmentValues {
    var backgroundColor: Color {
        get { self[TTextFieldBackgroundColorEnvironmentKey.self] }
        set { self[TTextFieldBackgroundColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldErrorTextColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .red
}

extension EnvironmentValues {
    var errorTextColor: Color {
        get { self[TTextFieldErrorTextColorEnvironmentKey.self] }
        set { self[TTextFieldErrorTextColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldBorderColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .gray
}

extension EnvironmentValues {
    var borderColor: Color {
        get { self[TTextFieldBorderColorEnvironmentKey.self] }
        set { self[TTextFieldBorderColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldTrailingImageForegroundColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .black
}

extension EnvironmentValues {
    var trailingImageForegroundColor: Color {
        get { self[TTextFieldTrailingImageForegroundColorEnvironmentKey.self] }
        set { self[TTextFieldTrailingImageForegroundColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldFocusedBorderColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .gray
}

extension EnvironmentValues {
    var focusedBorderColor: Color {
        get { self[TTextFieldFocusedBorderColorEnvironmentKey.self] }
        set { self[TTextFieldFocusedBorderColorEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldFocusedBorderEnableEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    var focusedBorderColorEnable: Bool {
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
    var borderType: BorderType {
        get { self[TTextFieldBorderTypeEnvironmentKey.self] }
        set { self[TTextFieldBorderTypeEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldDisableAutoCorrectionEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    var disableAutoCorrection: Bool {
        get { self[TTextFieldDisableAutoCorrectionEnvironmentKey.self] }
        set { self[TTextFieldDisableAutoCorrectionEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldTitleFontEnvironmentKey: EnvironmentKey {
    static var defaultValue: Font = .system(size: 15)
}

extension EnvironmentValues {
    var titleFont: Font {
        get { self[TTextFieldTitleFontEnvironmentKey.self] }
        set { self[TTextFieldTitleFontEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldErrorFontEnvironmentKey: EnvironmentKey {
    static var defaultValue: Font = .system(size: 15)
}

extension EnvironmentValues {
    var errorFont: Font {
        get { self[TTextFieldErrorFontEnvironmentKey.self] }
        set { self[TTextFieldErrorFontEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldPlaceHolderFontEnvironmentKey: EnvironmentKey {
    static var defaultValue: Font = .system(size: 15)
}

extension EnvironmentValues {
    var placeHolderFont: Font {
        get { self[TTextFieldPlaceHolderFontEnvironmentKey.self] }
        set { self[TTextFieldPlaceHolderFontEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldBorderWidthEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat = 1
}

extension EnvironmentValues {
    var borderWidth: CGFloat {
        get { self[TTextFieldBorderWidthEnvironmentKey.self] }
        set { self[TTextFieldBorderWidthEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldCornerRadiusEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat = 5
}

extension EnvironmentValues {
    var cornerRadius: CGFloat {
        get { self[TTextFieldCornerRadiusEnvironmentKey.self] }
        set { self[TTextFieldCornerRadiusEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldHeightEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat = 45
}

extension EnvironmentValues {
    var textFieldHeight: CGFloat {
        get { self[TTextFieldHeightEnvironmentKey.self] }
        set { self[TTextFieldHeightEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldTitleEnvironmentKey: EnvironmentKey {
    static var defaultValue: String?
}

extension EnvironmentValues {
    var textFieldTitle: String? {
        get { self[TTextFieldTitleEnvironmentKey.self] }
        set { self[TTextFieldTitleEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldPlaceHolderTextEnvironmentKey: EnvironmentKey {
    static var defaultValue: String = ""
}

extension EnvironmentValues {
    var placeHolderText: String {
        get { self[TTextFieldPlaceHolderTextEnvironmentKey.self] }
        set { self[TTextFieldPlaceHolderTextEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldSecureEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    var isSecure: Bool {
        get { self[TTextFieldSecureEnvironmentKey.self] }
        set { self[TTextFieldSecureEnvironmentKey.self] = newValue }
    }
}


struct TTextFieldTruncateModeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Text.TruncationMode = .tail
}

extension EnvironmentValues {
    var truncationMode: Text.TruncationMode {
        get { self[TTextFieldTruncateModeEnvironmentKey.self] }
        set { self[TTextFieldTruncateModeEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldLimitEnvironmentKey: EnvironmentKey {
    static var defaultValue: Int?
}

extension EnvironmentValues {
    var limitCount: Int? {
        get { self[TTextFieldLimitEnvironmentKey.self] }
        set { self[TTextFieldLimitEnvironmentKey.self] = newValue }
    }
}


struct TTextFieldSecureOpenEnvironmentKey: EnvironmentKey {
    static var defaultValue: Image = Image(systemName: .eye)
}

extension EnvironmentValues {
    var secureOpenImage: Image {
        get { self[TTextFieldSecureOpenEnvironmentKey.self] }
        set { self[TTextFieldSecureOpenEnvironmentKey.self] = newValue }
    }
}

struct TTextFieldSecureCloseEnvironmentKey: EnvironmentKey {
    static var defaultValue: Image = Image(systemName: .eyeSlash)
}

extension EnvironmentValues {
    var secureCloseImage: Image {
        get { self[TTextFieldSecureCloseEnvironmentKey.self] }
        set { self[TTextFieldSecureCloseEnvironmentKey.self] = newValue }
    }
}
