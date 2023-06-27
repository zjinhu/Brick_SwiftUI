//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/27.
//

import SwiftUI

public struct TTextField: View {

    @State private var trailingImage : Image?
    @State private var secureText = false{
        didSet{
            if secureText{
                isFocused = false
            }
        }
    }
    @State var isFocused = false
    private var text: Binding<String>
    private var disable: Binding<Bool>?
    private var error: Binding<Bool>?
    private var errorText: Binding<String>?
    private var isSecureText: Bool = false
    private var titleText: String?
    private var placeHolderText: String = ""
    private var trailingImageClick: (() -> Void)?
    private var secureTextImageOpen : Image? = Image(systemName: "eye.fill")
    private var secureTextImageClose : Image? = Image(systemName: "eye.slash.fill")
    private var maxCount: Int?
    private var truncationMode: Text.TruncationMode = Text.TruncationMode.tail
    
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

    
    public init(text: Binding<String>) {
        self.text = text
    }
    
    public var body: some View{
        VStack(spacing: 8){
            //Title
            if let titleText{
                Text(titleText)
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
                        .disabled(disable?.wrappedValue ?? false)
                        .padding([.leading, .trailing], borderType == .square ? 12 : 1)
                        .disableAutocorrection(disableAutoCorrection)
                        .onReceive(text.wrappedValue.publisher.collect()) {
                            if let maxCount{
                                let s = String($0.prefix(maxCount))
                                if text.wrappedValue != s && (maxCount != 0){
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
                            if !isSecureText{
                                trailingImageClick?()
                            }
                            else{
                                secureText.toggle()
                                trailingImage = secureText ? secureTextImageClose : secureTextImageOpen
                            }
                        }
                        .disabled(disable?.wrappedValue ?? false)
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
            if let error = error?.wrappedValue{
                if error{
                    Text(errorText?.wrappedValue ?? "")
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

}
 
extension TTextField{
    
    public func tTitleText(_ titleText: String) -> Self{
        var copy = self
        copy.titleText = titleText
        return copy
    }
    
    public func tPlaceHolderText(_ placeHolderText: String) -> Self {
        var copy = self
        copy.placeHolderText = placeHolderText
        return copy
    }
    public func tDisable(_ disable: Binding<Bool>) -> Self{
        var copy = self
        copy.disable = disable
        return copy
    }
    
    public func tError(errorText: Binding<String>, error: Binding<Bool>) -> Self {
        var copy = self
        copy.error = error
        copy.errorText = errorText
        return copy
    }

    public func tTrailingImage(_ image: Image, click: @escaping (()->Void)) -> Self{
        var copy = self
        copy._trailingImage = State(initialValue: image)
        copy.trailingImageClick = click
        return copy
    }
    
    public func tSecureText(_ secure: Bool) -> Self{
        var copy = self
        copy._secureText = State(initialValue: secure)
        if secure{
            copy._trailingImage = State(initialValue: copy.secureTextImageClose)
        }
        copy.isSecureText = secure
        return copy
    }
    
    public func tSecureTextImages(open: Image, close: Image) -> Self{
        var copy = self
        copy.secureTextImageOpen = open
        copy.secureTextImageClose = close
        copy._trailingImage = State(initialValue: copy.secureTextImageClose)
        return copy
    }
    
    public func tMaxCount(_ count: Int) -> Self{
        var copy = self
        copy.maxCount = count
        return copy
    }
    
    public func tTruncateMode(_ mode: Text.TruncationMode) -> Self{
        var copy = self
        copy.truncationMode = mode
        return copy
    }
}
 
extension View {
    
    public func tTextColor(_ color: Color) -> some View {
        environment(\.textColor, color)
    }

    public func tTitleColor(_ color: Color) -> some View {
        environment(\.titleColor, color)
    }
    
    public func tPlaceHolderTextColor(_ color: Color) -> some View {
        environment(\.placeHolderTextColor, color)
    }

    public func tDisableColor(_ color: Color) -> some View {
        environment(\.disableColor, color)
    }
    
    public func tBackgroundColor(_ color: Color) -> some View {
        environment(\.backgroundColor, color)
    }

    public func tErrorTextColor(_ color: Color) -> some View {
        environment(\.errorTextColor, color)
    }
    
    public func tBorderColor(_ color: Color) -> some View {
        environment(\.borderColor, color)
    }

    public func tTrailingImageForegroundColor(_ color: Color) -> some View {
        environment(\.trailingImageForegroundColor, color)
    }
    
    public func tFocusedBorderColor(_ color: Color) -> some View {
        environment(\.focusedBorderColor, color)
    }
    
    
    public func tFocusedBorderColorEnable(_ enable: Bool) -> some View {
        environment(\.focusedBorderColorEnable, enable)
    }
    
    public func tBorderType(_ type: BorderType) -> some View {
        environment(\.borderType, type)
    }
    
    public func tDisableAutoCorrection(_ auto: Bool) -> some View {
        environment(\.disableAutoCorrection, auto)
    }
    
    public func tTitleFont(_ font: Font) -> some View {
        environment(\.titleFont, font)
    }
    
    public func tErrorFont(_ font: Font) -> some View {
        environment(\.errorFont, font)
    }
    
    public func tPlaceHolderFont(_ font: Font) -> some View {
        environment(\.placeHolderFont, font)
    }

    public func tBorderWidth(_ width: CGFloat) -> some View {
        environment(\.borderWidth, width)
    }
    
    public func tCornerRadius(_ radius: CGFloat) -> some View {
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
