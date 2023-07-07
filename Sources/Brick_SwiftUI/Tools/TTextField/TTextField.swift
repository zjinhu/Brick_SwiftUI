//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/27.
//

import SwiftUI

public struct TTextField: View {
    private var text: Binding<String>
    private var disable: Binding<Bool>
    private var error: Binding<Bool>
    private var errorText: Binding<String>
    private var isSecure = false
    @State private var secureText = false{
        didSet{
            if secureText{
                isFocused = false
            }
        }
    }
    @State var isFocused = false
    
    private var trailingImageClick: (() -> Void)?
    @State private var trailingImage : Image?
    private var secureOpenImage : Image? = Image(symbol: .eye)
    private var secureCloseImage : Image? = Image(symbol: .eyeSlash)
    
    public init(text: Binding<String>,
                disable: Binding<Bool> = .constant(false),
                error: Binding<Bool> = .constant(false),
                errorText: Binding<String> = .constant("")) {
        self.text = text
        self.disable = disable
        self.error = error
        self.errorText = errorText
    }
    
    public var body: some View{
        VStack(spacing: 8){
            //Title
            if let textFieldTitle{
                Text(textFieldTitle)
                    .font(titleFont)
                    .foregroundColor(titleColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(spacing: 0){
                //TextField
                HStack(spacing: 0){
                    secureAnyView()
                        .placeholder(when: text.wrappedValue.isEmpty, placeholder: {
                            Text(placeHolderText)
                                .foregroundColor(placeHolderTextColor)
                                .font(placeHolderFont)
                        })
                        .frame(maxWidth: .infinity)
                        .frame(height: textFieldHeight)
                        .foregroundColor(textColor)
                        .disabled(disable.wrappedValue)
                        .padding([.leading, .trailing], borderType == .square ? 12 : 1)
                        .disableAutocorrection(disableAutoCorrection)
                        .onReceive(text.wrappedValue.publisher.collect()) {
                            if let limitCount{
                                let s = String($0.prefix(limitCount))
                                if text.wrappedValue != s && (limitCount != 0){
                                    text.wrappedValue = s
                                }
                            }
                        }
                        .truncationMode(truncationMode)
                        .background(Color.clear)
                    trailingImage?
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(trailingImageForegroundColor)
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 12)
                        .onTapGesture {
                            if !isSecure{
                                trailingImageClick?()
                            }
                            else{
                                secureText.toggle()
                                trailingImage = secureText ? secureCloseImage : secureOpenImage
                            }
                        }
                        .disabled(disable.wrappedValue)//图片点击
                    
                }.background(
                    RoundedRectangle(cornerRadius: getCornerRadius())
                        .stroke(borderColor, lineWidth: getBorderWidth(type: .square))
                        .background(backgroundColor.cornerRadius(getCornerRadius()))
                )
                //Bottom Line
                if borderType == .line{
                    Rectangle()
                        .frame(height: getBorderWidth(type: .line))
                        .foregroundColor(borderColor)
                }
            }
            //Bottom text
            if error.wrappedValue {
                    Text(errorText.wrappedValue)
                        .font(errorFont)
                        .foregroundColor(errorTextColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private func secureAnyView() -> AnyView{
        if !secureText{
            return AnyView(TextField("", text: text, onEditingChanged: { changed in
                if changed{
                    isFocused = true
                }
                else{
                    isFocused = false
                }
            }))
        }
        else{
            return AnyView(SecureField("", text: text))
        }
    }
    
    private func getBorderWidth(type: BorderType) -> CGFloat{
        if type == .square{
            return borderType == .square ? borderWidth : 0.0
        }
        else{
            return borderWidth
        }
    }
    
    private func getCornerRadius() -> CGFloat{
        return borderType == .square ? cornerRadius : 0.0
    }
    
    
    @Environment(\.tTextFieldColor) private var textColor
    @Environment(\.tTextFieldTitleColor) private var titleColor
    @Environment(\.tTextFieldPlaceHolderColor) private var placeHolderTextColor
    @Environment(\.tTextFieldDisableColor) private var disableColor
    
    @Environment(\.tTextFieldBackgroundColor) private var backgroundColor
    @Environment(\.tTextFieldErrorColor) private var errorTextColor
    @Environment(\.tTextFieldBorderColor) private var borderColor
    @Environment(\.tTextFieldTrailingImageColor) private var trailingImageForegroundColor
    
    @Environment(\.tTextFieldFocusedBorderColor) private var focusedBorderColor
    @Environment(\.tTextFieldFocusedBorderColorEnable) private var focusedBorderColorEnable
    @Environment(\.tTextFieldBorderType) private var borderType
    @Environment(\.tTextFieldDisableAutoCorrection) private var disableAutoCorrection
    
    @Environment(\.tTextFieldTitleFont) private var titleFont
    @Environment(\.tTextFieldErrorFont) private var errorFont
    @Environment(\.tTextFieldPlaceHolderFont) private var placeHolderFont
    @Environment(\.tTextFieldBorderWidth) private var borderWidth
    
    @Environment(\.tTextFieldCornerRadius) private var cornerRadius
    @Environment(\.tTextFieldHeight) private var textFieldHeight
    
    @Environment(\.tTextFieldTitle) private var textFieldTitle
    @Environment(\.tTextFieldPlaceHolderText) private var placeHolderText

    @Environment(\.tTextFieldTruncationMode) private var truncationMode
    @Environment(\.tTextFieldLimitCount) private var limitCount

    
}

extension TTextField{
    
    public func tTextFieldTrailingImage(_ image: Image, click: (()->Void)? = nil) -> Self{
        var copy = self
        copy._trailingImage = State(initialValue: image)
        copy.trailingImageClick = click
        return copy
    }
    
    public func tTextFieldSecure(_ secure: Bool) -> Self{
        var copy = self
        copy._secureText = State(initialValue: secure)
        if secure{
            copy._trailingImage = State(initialValue: copy.secureCloseImage)
        }
        copy.isSecure = secure
        return copy
    }
    
    public func tTextFieldSecureImage(open: Image, close: Image) -> Self{
        var copy = self
        copy.secureOpenImage = open
        copy.secureCloseImage = close
        copy._trailingImage = State(initialValue: copy.secureCloseImage)
        return copy
    }
}

extension View {

    public func tTextFieldLimitCount(_ count: Int) -> some View {
        environment(\.tTextFieldLimitCount, count)
    }
    
    public func tTextFieldTruncationMode(_ mode: Text.TruncationMode) -> some View {
        environment(\.tTextFieldTruncationMode, mode)
    }

    public func tTextFieldTitle(_ title: String) -> some View {
        environment(\.tTextFieldTitle, title)
    }
    
    public func tTextFieldPlaceHolderText(_ title: String) -> some View {
        environment(\.tTextFieldPlaceHolderText, title)
    }
    
    public func tTextFieldTextColor(_ color: Color) -> some View {
        environment(\.tTextFieldColor, color)
    }
    
    public func tTextFieldTitleColor(_ color: Color) -> some View {
        environment(\.tTextFieldTitleColor, color)
    }
    
    public func tTextFieldPlaceHolderTextColor(_ color: Color) -> some View {
        environment(\.tTextFieldPlaceHolderColor, color)
    }
    
    public func tTextFieldDisableColor(_ color: Color) -> some View {
        environment(\.tTextFieldDisableColor, color)
    }
    
    public func tTextFieldBackgroundColor(_ color: Color) -> some View {
        environment(\.tTextFieldBackgroundColor, color)
    }
    
    public func tTextFieldErrorTextColor(_ color: Color) -> some View {
        environment(\.tTextFieldErrorColor, color)
    }
    
    public func tTextFieldBorderColor(_ color: Color) -> some View {
        environment(\.tTextFieldBorderColor, color)
    }
    
    public func tTextFieldTrailingImageForegroundColor(_ color: Color) -> some View {
        environment(\.tTextFieldTrailingImageColor, color)
    }
    
    public func tTextFieldFocusedBorderColor(_ color: Color) -> some View {
        environment(\.tTextFieldFocusedBorderColor, color)
    }
    
    
    public func tTextFieldFocusedBorderColorEnable(_ enable: Bool) -> some View {
        environment(\.tTextFieldFocusedBorderColorEnable, enable)
    }
    
    public func tTextFieldBorderType(_ type: BorderType) -> some View {
        environment(\.tTextFieldBorderType, type)
    }
    
    public func tTextFieldDisableAutoCorrection(_ auto: Bool) -> some View {
        environment(\.tTextFieldDisableAutoCorrection, auto)
    }
    
    public func tTextFieldTitleFont(_ font: Font) -> some View {
        environment(\.tTextFieldTitleFont, font)
    }
    
    public func tTextFieldErrorFont(_ font: Font) -> some View {
        environment(\.tTextFieldErrorFont, font)
    }
    
    public func tTextFieldPlaceHolderFont(_ font: Font) -> some View {
        environment(\.tTextFieldPlaceHolderFont, font)
    }
    
    public func tTextFieldBorderWidth(_ width: CGFloat) -> some View {
        environment(\.tTextFieldBorderWidth, width)
    }
    
    public func tTextFieldCornerRadius(_ radius: CGFloat) -> some View {
        environment(\.tTextFieldCornerRadius, radius)
    }
    
    public func tTextFieldHeight(_ height: CGFloat) -> some View {
        environment(\.tTextFieldHeight, height)
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
