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
                        .disabled(disable.wrappedValue)
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
            if let error = error.wrappedValue{
                if error{
                    Text(errorText.wrappedValue)
                        .font(errorFont)
                        .foregroundColor(errorTextColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
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
    
    
    @Environment(\.textColor) private var textColor
    @Environment(\.titleColor) private var titleColor
    @Environment(\.placeHolderTextColor) private var placeHolderTextColor
    @Environment(\.disableColor) private var disableColor
    
    @Environment(\.backgroundColor) private var backgroundColor
    @Environment(\.errorTextColor) private var errorTextColor
    @Environment(\.borderColor) private var borderColor
    @Environment(\.trailingImageForegroundColor) private var trailingImageForegroundColor
    
    @Environment(\.focusedBorderColor) private var focusedBorderColor
    @Environment(\.focusedBorderColorEnable) private var focusedBorderColorEnable
    @Environment(\.borderType) private var borderType
    @Environment(\.disableAutoCorrection) private var disableAutoCorrection
    
    @Environment(\.titleFont) private var titleFont
    @Environment(\.errorFont) private var errorFont
    @Environment(\.placeHolderFont) private var placeHolderFont
    @Environment(\.borderWidth) private var borderWidth
    
    @Environment(\.cornerRadius) private var cornerRadius
    @Environment(\.textFieldHeight) private var textFieldHeight
    
    @Environment(\.textFieldTitle) private var textFieldTitle
    @Environment(\.placeHolderText) private var placeHolderText

    @Environment(\.truncationMode) private var truncationMode
    @Environment(\.limitCount) private var limitCount
    
    @Environment(\.secureOpenImage) private var secureOpenImage
    @Environment(\.secureCloseImage) private var secureCloseImage
    
}

extension TTextField{
    
    public func tTextFieldTrailingImage(_ image: Image, click: @escaping (()->Void)) -> Self{
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
}

extension View {
    
    public func tTextFieldSecureOpenImage(_ image: Image) -> some View {
        environment(\.secureOpenImage, image)
    }
    
    public func tTextFieldSecureCloseImage(_ image: Image) -> some View {
        environment(\.secureCloseImage, image)
    }
    
    public func tTextFieldLimitCount(_ count: Int) -> some View {
        environment(\.limitCount, count)
    }
    
    public func tTextFieldTruncationMode(_ mode: Text.TruncationMode) -> some View {
        environment(\.truncationMode, mode)
    }

    public func tTextFieldTitle(_ title: String) -> some View {
        environment(\.textFieldTitle, title)
    }
    
    public func tTextFieldPlaceHolderText(_ title: String) -> some View {
        environment(\.placeHolderText, title)
    }
    
    public func tTextFieldTextColor(_ color: Color) -> some View {
        environment(\.textColor, color)
    }
    
    public func tTextFieldTitleColor(_ color: Color) -> some View {
        environment(\.titleColor, color)
    }
    
    public func tTextFieldPlaceHolderTextColor(_ color: Color) -> some View {
        environment(\.placeHolderTextColor, color)
    }
    
    public func tTextFieldDisableColor(_ color: Color) -> some View {
        environment(\.disableColor, color)
    }
    
    public func tTextFieldBackgroundColor(_ color: Color) -> some View {
        environment(\.backgroundColor, color)
    }
    
    public func tTextFieldErrorTextColor(_ color: Color) -> some View {
        environment(\.errorTextColor, color)
    }
    
    public func tTextFieldBorderColor(_ color: Color) -> some View {
        environment(\.borderColor, color)
    }
    
    public func tTextFieldTrailingImageForegroundColor(_ color: Color) -> some View {
        environment(\.trailingImageForegroundColor, color)
    }
    
    public func tTextFieldFocusedBorderColor(_ color: Color) -> some View {
        environment(\.focusedBorderColor, color)
    }
    
    
    public func tTextFieldFocusedBorderColorEnable(_ enable: Bool) -> some View {
        environment(\.focusedBorderColorEnable, enable)
    }
    
    public func tTextFieldBorderType(_ type: BorderType) -> some View {
        environment(\.borderType, type)
    }
    
    public func tTextFieldDisableAutoCorrection(_ auto: Bool) -> some View {
        environment(\.disableAutoCorrection, auto)
    }
    
    public func tTextFieldTitleFont(_ font: Font) -> some View {
        environment(\.titleFont, font)
    }
    
    public func tTextFieldErrorFont(_ font: Font) -> some View {
        environment(\.errorFont, font)
    }
    
    public func tTextFieldPlaceHolderFont(_ font: Font) -> some View {
        environment(\.placeHolderFont, font)
    }
    
    public func tTextFieldBorderWidth(_ width: CGFloat) -> some View {
        environment(\.borderWidth, width)
    }
    
    public func tTextFieldCornerRadius(_ radius: CGFloat) -> some View {
        environment(\.cornerRadius, radius)
    }
    
    public func tTextFieldHeight(_ height: CGFloat) -> some View {
        environment(\.textFieldHeight, height)
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
