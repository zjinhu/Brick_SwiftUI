//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/18/24.
//

import SwiftUI
#if os(iOS)
@available(iOS 15.0, *)
public struct AutoHeightTextEditor: View {
    
    @State private var textEditorHeight : CGFloat = 20
    @Binding var inputText: String
    @Binding var placeholder: String
    @FocusState.Binding var isTextEditorFocused: Bool
    
    let backgroundColor: Color
    let textColor: Color
    
    public init(inputText: Binding<String>,
                placeholder: Binding<String>,
                textFocused: FocusState<Bool>.Binding,
                textColor: Color = .primary,
                backgroundColor: Color = Color.gray.opacity(0.1)) {
        self._inputText = inputText
        self._placeholder = placeholder
        self._isTextEditorFocused = textFocused
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    public var body: some View {
        HStack(alignment: .bottom, spacing: 0){
            ZStack(alignment: .leading) {
                
                Text(inputText)
                    .font(.system(size: 14))
                    .lineSpacing(0)
                    .lineLimit(4)
                    .foregroundColor(.clear)
                    .padding(14)
                    .background(
                        GeometryReader {
                            Color.clear.preference(key: ViewHeightKey.self,
                                                   value: $0.frame(in: .local).size.height)
                        }
                    )
                
                TextEditor(text: $inputText)
                    .focused($isTextEditorFocused)
                    .padding(6)
                    .font(.system(size: 14))
                    .frame(height: max(40, textEditorHeight))
                    .ss.hideTextViewBackground()
                    .foregroundStyle(textColor)
                
                
                if inputText.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                        .allowsHitTesting(false) // 禁用点击事件，这样点击会透传到下层 Button
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
        )
        .onPreferenceChange(ViewHeightKey.self) {
            textEditorHeight = $0
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

@available(iOS 15.0, *)
#Preview {
    struct PreviewWrapper: View {
        @State private var text = ""
        @State private var placeholderText = "11111"
        @FocusState private var isFocused: Bool
        
        var body: some View {
            VStack {
                AutoHeightTextEditor(
                    inputText: $text,
                    placeholder: $placeholderText,
                    textFocused: $isFocused
                )
                .padding()
                
                Button("关闭键盘") {
                    isFocused = false
                }
            }
        }
    }
    
    return PreviewWrapper()
}
#endif
