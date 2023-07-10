//
//  UnderLineView.swift
//  AIChat
//
//  Created by iOS on 2023/7/7.
//

import SwiftUI

public struct UnderLineTextView: View {
 
    @Environment(\.underLineTitle) private var underLineTitle
    @Environment(\.underLineTitleColor) private var underLineTitleColor
    @Environment(\.underLineTitleFont) private var underLineTitleFont
    
    @Environment(\.underLineText) private var underLineText
    @Environment(\.underLineTextFont) private var underLineTextFont
    @Environment(\.underLineTextColor) private var underLineTextColor
    
    @Environment(\.underLineTextHeight) private var underLineTextHeight
    @Environment(\.underLineTrailingImageColor) private var underLineTrailingImageColor
    @Environment(\.underLineTextTruncationMode) private var underLineTextTruncationMode
    @Environment(\.underLineColor) private var underLineColor
    @Environment(\.underLineHeight) private var underLineHeight
    
    @Environment(\.underLineTrailingImage) private var underLineTrailingImage
    @Environment(\.underLineTrailingImageClick) private var underLineTrailingImageClick
    
    public init(){}
    
    public var body: some View {
        VStack(spacing: 8){
            
            if let underLineTitle{
                Text(underLineTitle)
                    .font(underLineTitleFont)
                    .foregroundColor(underLineTitleColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(alignment: .leading, spacing: 0){
                HStack(spacing: 0){
                    Text(underLineText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 1)
                        .frame(height: underLineTextHeight)
                        .foregroundColor(underLineTextColor)
                        .truncationMode(underLineTextTruncationMode)
                        .background(Color.clear)
                    
                    Spacer()
                    
                    underLineTrailingImage?
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(underLineTrailingImageColor)
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 12)
                        .onTapGesture {
                            underLineTrailingImageClick?()
                        }
                }
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: underLineHeight)
                    .foregroundColor(underLineColor)
            }
        }
    }

}

struct UnderLineTextView_Previews: PreviewProvider {
    static var previews: some View {
        UnderLineTextView()
            .underLineText("123")
            .underLineTitle("123")
            .underLineColor(.red)
            .padding()
    }
}

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
    
    public func underLineTrailingImageColor(_ color: Color) -> some View {
        environment(\.underLineTrailingImageColor, color)
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

    public func underLineTrailingImage(_ image: Image) -> some View {
        environment(\.underLineTrailingImage, image)
    }
    
    public func underLineTrailingImageClick(_ click: @escaping () -> Void) -> some View {
        environment(\.underLineTrailingImageClick, click)
    }
}

struct UnderLineTextTruncateModeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Text.TruncationMode = .tail
}

extension EnvironmentValues {
    var underLineTextTruncationMode: Text.TruncationMode {
        get { self[UnderLineTextTruncateModeEnvironmentKey.self] }
        set { self[UnderLineTextTruncateModeEnvironmentKey.self] = newValue }
    }
}

struct UnderLineTextTitleEnvironmentKey: EnvironmentKey {
    static var defaultValue: String?
}

extension EnvironmentValues {
    var underLineTitle: String? {
        get { self[UnderLineTextTitleEnvironmentKey.self] }
        set { self[UnderLineTextTitleEnvironmentKey.self] = newValue }
    }
}

struct UnderLineTextEnvironmentKey: EnvironmentKey {
    static var defaultValue: String = ""
}

extension EnvironmentValues {
    var underLineText: String {
        get { self[UnderLineTextEnvironmentKey.self] }
        set { self[UnderLineTextEnvironmentKey.self] = newValue }
    }
}

struct UnderLineTextLineColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color? = nil
}

extension EnvironmentValues {
    var underLineColor: Color? {
        get { self[UnderLineTextLineColorEnvironmentKey.self] }
        set { self[UnderLineTextLineColorEnvironmentKey.self] = newValue }
    }
}

struct UnderLineHeightEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat = 1
}

extension EnvironmentValues {
    var underLineHeight: CGFloat {
        get { self[UnderLineHeightEnvironmentKey.self] }
        set { self[UnderLineHeightEnvironmentKey.self] = newValue }
    }
}

struct UnderLineTitleFontEnvironmentKey: EnvironmentKey {
    static var defaultValue: Font = .system(size: 15)
}

extension EnvironmentValues {
    var underLineTitleFont: Font {
        get { self[UnderLineTitleFontEnvironmentKey.self] }
        set { self[UnderLineTitleFontEnvironmentKey.self] = newValue }
    }
}

struct UnderLineTextFontEnvironmentKey: EnvironmentKey {
    static var defaultValue: Font = .system(size: 15)
}

extension EnvironmentValues {
    var underLineTextFont: Font {
        get { self[UnderLineTextFontEnvironmentKey.self] }
        set { self[UnderLineTextFontEnvironmentKey.self] = newValue }
    }
}

struct UnderLineTitleColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color? = nil
}

extension EnvironmentValues {
    var underLineTitleColor: Color? {
        get { self[UnderLineTitleColorEnvironmentKey.self] }
        set { self[UnderLineTitleColorEnvironmentKey.self] = newValue }
    }
}

struct UnderLineTextHeightEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat = 50
}

extension EnvironmentValues {
    var underLineTextHeight: CGFloat {
        get { self[UnderLineTextHeightEnvironmentKey.self] }
        set { self[UnderLineTextHeightEnvironmentKey.self] = newValue }
    }
}

struct UnderLineTextColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color? = nil
}

extension EnvironmentValues {
    var underLineTextColor: Color? {
        get { self[UnderLineTextColorEnvironmentKey.self] }
        set { self[UnderLineTextColorEnvironmentKey.self] = newValue }
    }
}

struct UnderLineTrailingImageColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color? = nil
}

extension EnvironmentValues {
    var underLineTrailingImageColor: Color? {
        get { self[UnderLineTrailingImageColorEnvironmentKey.self] }
        set { self[UnderLineTrailingImageColorEnvironmentKey.self] = newValue }
    }
}


struct UnderLineTrailingImageEnvironmentKey: EnvironmentKey {
    static var defaultValue: Image? = nil
}

extension EnvironmentValues {
    var underLineTrailingImage: Image? {
        get { self[UnderLineTrailingImageEnvironmentKey.self] }
        set { self[UnderLineTrailingImageEnvironmentKey.self] = newValue }
    }
}


struct UnderLineTrailingImageClickEnvironmentKey: EnvironmentKey {
    static var defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var underLineTrailingImageClick: (() -> Void)? {
        get { self[UnderLineTrailingImageClickEnvironmentKey.self] }
        set { self[UnderLineTrailingImageClickEnvironmentKey.self] = newValue }
    }
}
