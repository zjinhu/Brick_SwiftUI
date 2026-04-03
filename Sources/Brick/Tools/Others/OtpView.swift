//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/7/4.
//

import SwiftUI
#if os(iOS)

/// OTP验证码输入视图/OTP verification code input view
/// 支持数字键盘和自动填充一次性验证码。/Supports number pad and auto-fill one-time code.
@available(iOS 15.0, *)
public struct OtpView: View {
    /// 激活状态颜色/Active state color
    private var activeColor: Color
    /// 非激活状态颜色/Inactive state color
    private var inActiveColor: Color
    /// 输入完成回调/Input completion callback
    private let callback: (String) -> Void
    /// 验证码长度/Verification code length
    private let length: Int
    
    @State private var otpText = ""
    @FocusState private var isKeyboardShowing: Bool
    
    /// 初始化OTP视图/Initialize OTP view
    /// - Parameters:
    ///   - activeColor: 激活状态颜色/Active state color
    ///   - inActiveColor: 非激活状态颜色/Inactive state color
    ///   - length: 验证码长度/Verification code length
    ///   - callback: 输入完成回调/Input completion callback
    public init(activeColor: Color,
                inActiveColor: Color,
                length:Int,
                _ callback: @escaping (String) -> Void) {
        self.activeColor = activeColor
        self.inActiveColor = inActiveColor
        self.length = length
        self.callback = callback
    }
    
    public var body: some View {
        HStack(spacing: 0){
            ForEach(0...length-1, id: \.self) { index in
                OTPTextBox(index)
            }
        }
        .background{
            TextField("", text: $otpText.limit(4))
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .frame(width: 1, height: 1)
                .opacity(0.001)
                .blendMode(.screen)
                .focused($isKeyboardShowing)
                .ss.onChange(of: otpText) { newValue in
                    if newValue.count == length {
                        callback(newValue)
                    }
                }
                .onAppear {
                    DispatchQueue.main.async {
                        isKeyboardShowing = true
                    }
                }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isKeyboardShowing = true
        }
    }
    
    /// OTP输入框/OTP input box
    @ViewBuilder
    func OTPTextBox(_ index: Int) -> some View {
        ZStack{
            if otpText.count > index {
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
            } else {
                Text(" ")
            }
        }
        .frame(width: 45, height: 45)
        .background{
            let status = (isKeyboardShowing && otpText.count == index)
            status ? activeColor.opacity(0.1) : .clear
        }
        .background {
            let status = (isKeyboardShowing && otpText.count == index)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(status ? activeColor : inActiveColor)
                .animation(.easeInOut(duration: 0.2), value: status)
            
        }
        .padding()
    }
}

/// 字符串绑定长度限制扩展/String binding length limit extension
extension Binding where Value == String {
    /// 限制字符串长度/Limit string length
    /// - Parameter length: 最大长度/Maximum length
    /// - Returns: 限制后的绑定/Limited binding
    func limit(_ length: Int)->Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}
#endif
