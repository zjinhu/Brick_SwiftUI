//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/27.
//  自定义文本输入框/Custom text field
//  支持标题、占位符、错误状态、密码显示等功能/Supports title, placeholder, error state, password visibility and more

import SwiftUI

/// 自定义文本输入框/Custom text field
public struct TTextField: View {
    private var text: Binding<String>
    /// 是否禁用/Whether disabled
    private var disable: Binding<Bool>
    /// 是否有错误/Whether has error
    private var error: Binding<Bool>
    /// 错误文本/Error text
    private var errorText: Binding<String>
    /// 是否为密码框/Whether is secure field
    private var isSecure = false
    @State private var secureText = false{
        didSet{
            if secureText{
                isFocused = false
            }
        }
    }
    @State var isFocused = false

    @State private var secureImage : Image?
    /// 密码显示图标/Password visible icon
    private var secureOpenImage : Image? = Image(symbol: .eye)
    /// 密码隐藏图标/Password hidden icon
    private var secureCloseImage : Image? = Image(symbol: .eyeSlash)
    
    /// 初始化自定义文本框/Initialize custom text field
    /// - Parameters:
    ///   - text: 文本绑定/Text binding
    ///   - disable: 是否禁用/Whether disabled
    ///   - error: 是否有错误/Whether has error
    ///   - errorText: 错误文本/Error text
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
                    
                    if let tTextFieldLeadingView {
                        tTextFieldLeadingView()
                            .padding(.trailing, 10)
                            .disabled(disable.wrappedValue)//图片点击
                    }
                    
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
                    
                    if let tTextFieldTrailingView {
                        tTextFieldTrailingView()
                            .padding(.trailing, 12)
                            .disabled(disable.wrappedValue)//图片点击
                    }else{
                        if let image = secureImage{
                            Button {
                                secureText.toggle()
                                secureImage = secureText ? secureCloseImage : secureOpenImage
                            } label: {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(secureImageColor)
                                    .frame(width: 25, height: 25)
                                    .padding(.trailing, 12)
                            }
                            .disabled(disable.wrappedValue)//图片点击

                        }
 
                    }
                    
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
    @Environment(\.tTextFieldSecureImageColor) private var secureImageColor
    
    @Environment(\.tTextFieldTrailingView) private var tTextFieldTrailingView
    @Environment(\.tTextFieldLeadingView) private var tTextFieldLeadingView
    
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
    /// 设置为密码框/Set as secure field
    /// - Parameter secure: 是否为密码框/Whether is secure field
    /// - Returns: 配置后的文本框/Configured text field
    public func tTextFieldSecure(_ secure: Bool) -> Self{
        var copy = self
        copy._secureText = State(initialValue: secure)
        if secure{
            copy._secureImage = State(initialValue: copy.secureCloseImage)
        }
        copy.isSecure = secure
        return copy
    }
    
    /// 自定义密码显示/隐藏图标/Custom password visibility icons
    /// - Parameters:
    ///   - open: 显示密码时的图标/Icon when password is visible
    ///   - close: 隐藏密码时的图标/Icon when password is hidden
    /// - Returns: 配置后的文本框/Configured text field
    public func tTextFieldSecureImage(open: Image, close: Image) -> Self{
        var copy = self
        copy.secureOpenImage = open
        copy.secureCloseImage = close
        copy._secureImage = State(initialValue: copy.secureCloseImage)
        return copy
    }
}

/// TTextField View扩展/TTextField View extensions
extension View {
    
    /// 设置文本输入限制/Sets text input limit
    /// - Parameter count: 最大字符数/Maximum character count
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldLimitCount(_ count: Int) -> some View {
        environment(\.tTextFieldLimitCount, count)
    }
    
    /// 设置文本截断模式/Sets text truncation mode
    /// - Parameter mode: 截断模式/Truncation mode
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldTruncationMode(_ mode: Text.TruncationMode) -> some View {
        environment(\.tTextFieldTruncationMode, mode)
    }
    
    /// 设置标题/Sets title
    /// - Parameter title: 标题文本/Title text
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldTitle(_ title: String) -> some View {
        environment(\.tTextFieldTitle, title)
    }
    
    /// 设置占位符文本/Sets placeholder text
    /// - Parameter title: 占位符文本/Placeholder text
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldPlaceHolderText(_ title: String) -> some View {
        environment(\.tTextFieldPlaceHolderText, title)
    }
    
    /// 设置文本颜色/Sets text color
    /// - Parameter color: 文本颜色/Text color
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldTextColor(_ color: Color) -> some View {
        environment(\.tTextFieldColor, color)
    }
    
    /// 设置标题颜色/Sets title color
    /// - Parameter color: 标题颜色/Title color
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldTitleColor(_ color: Color) -> some View {
        environment(\.tTextFieldTitleColor, color)
    }
    
    /// 设置占位符颜色/Sets placeholder color
    /// - Parameter color: 占位符颜色/Placeholder color
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldPlaceHolderTextColor(_ color: Color) -> some View {
        environment(\.tTextFieldPlaceHolderColor, color)
    }
    
    /// 设置禁用状态颜色/Sets disabled state color
    /// - Parameter color: 禁用状态颜色/Disabled state color
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldDisableColor(_ color: Color) -> some View {
        environment(\.tTextFieldDisableColor, color)
    }
    
    /// 设置背景颜色/Sets background color
    /// - Parameter color: 背景颜色/Background color
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldBackgroundColor(_ color: Color) -> some View {
        environment(\.tTextFieldBackgroundColor, color)
    }
    
    /// 设置错误文本颜色/Sets error text color
    /// - Parameter color: 错误文本颜色/Error text color
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldErrorTextColor(_ color: Color) -> some View {
        environment(\.tTextFieldErrorColor, color)
    }
    
    /// 设置边框颜色/Sets border color
    /// - Parameter color: 边框颜色/Border color
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldBorderColor(_ color: Color) -> some View {
        environment(\.tTextFieldBorderColor, color)
    }
    
    /// 设置左侧视图/Sets leading view
    /// - Parameter content: 左侧视图构建闭包/Leading view build closure
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldLeadingView<V: View>(_ content: @escaping () -> V) -> some View {
        environment(\.tTextFieldLeadingView, { AnyView(content()) })
    }
    
    /// 设置右侧视图/Sets trailing view
    /// - Parameter content: 右侧视图构建闭包/Trailing view build closure
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldTrailingView<V: View>(_ content: @escaping () -> V) -> some View {
        environment(\.tTextFieldTrailingView, { AnyView(content()) })
    }
    
    /// 设置密码图标颜色/Sets password icon color
    /// - Parameter color: 密码图标颜色/Password icon color
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldSecureImageForegroundColor(_ color: Color) -> some View {
        environment(\.tTextFieldSecureImageColor, color)
    }
    
    /// 设置聚焦边框颜色/Sets focused border color
    /// - Parameter color: 聚焦边框颜色/Focused border color
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldFocusedBorderColor(_ color: Color) -> some View {
        environment(\.tTextFieldFocusedBorderColor, color)
    }
    
    
    /// 启用/禁用聚焦边框颜色/Enable/disable focused border color
    /// - Parameter enable: 是否启用/Whether enabled
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldFocusedBorderColorEnable(_ enable: Bool) -> some View {
        environment(\.tTextFieldFocusedBorderColorEnable, enable)
    }
    
    /// 设置边框类型/Sets border type
    /// - Parameter type: 边框类型/Border type
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldBorderType(_ type: BorderType) -> some View {
        environment(\.tTextFieldBorderType, type)
    }
    
    /// 设置禁用自动纠正/Disable auto correction
    /// - Parameter auto: 是否禁用/Whether disabled
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldDisableAutoCorrection(_ auto: Bool) -> some View {
        environment(\.tTextFieldDisableAutoCorrection, auto)
    }
    
    /// 设置标题字体/Sets title font
    /// - Parameter font: 标题字体/Title font
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldTitleFont(_ font: Font) -> some View {
        environment(\.tTextFieldTitleFont, font)
    }
    
    /// 设置错误字体/Sets error font
    /// - Parameter font: 错误字体/Error font
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldErrorFont(_ font: Font) -> some View {
        environment(\.tTextFieldErrorFont, font)
    }
    
    /// 设置占位符字体/Sets placeholder font
    /// - Parameter font: 占位符字体/Placeholder font
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldPlaceHolderFont(_ font: Font) -> some View {
        environment(\.tTextFieldPlaceHolderFont, font)
    }
    
    /// 设置边框宽度/Sets border width
    /// - Parameter width: 边框宽度/Border width
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldBorderWidth(_ width: CGFloat) -> some View {
        environment(\.tTextFieldBorderWidth, width)
    }
    
    /// 设置圆角/Sets corner radius
    /// - Parameter radius: 圆角半径/Corner radius
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldCornerRadius(_ radius: CGFloat) -> some View {
        environment(\.tTextFieldCornerRadius, radius)
    }
    
    /// 设置输入框高度/Sets text field height
    /// - Parameter height: 高度/Height
    /// - Returns: 配置后的视图/Configured view
    public func tTextFieldHeight(_ height: CGFloat) -> some View {
        environment(\.tTextFieldHeight, height)
    }
    
    /// 占位符视图扩展/Placeholder view extension
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
