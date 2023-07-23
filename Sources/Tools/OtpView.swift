//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/7/4.
//

import SwiftUI
#if os(iOS)
@available(iOS 15.0, *)
public struct OtpView: View {
    private var activeColor: Color
    private var inActiveColor: Color
    private let callback: (String) -> Void
    private let length: Int
    
    @State private var otpText = ""
    @FocusState private var isKeyboardShowing: Bool
    
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
                .onChange(of: otpText) { newValue in
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

extension Binding where Value == String {
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
