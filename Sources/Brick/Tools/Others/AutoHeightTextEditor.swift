//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/18/24.
//

import SwiftUI
#if os(iOS)

/// 自动高度文本编辑器/Auto height text editor
/// 根据内容自动调整高度的文本编辑器，支持占位符。/Text editor that auto-adjusts height based on content, with placeholder support.
@available(iOS 15.0, *)
public struct AutoHeightTextEditor: View {
    
    @State private var textEditorHeight : CGFloat = 20
    /// 输入文本绑定/Input text binding
    @Binding var inputText: String
    /// 占位符文本绑定/Placeholder text binding
    @Binding var placeholder: String
    /// 焦点状态绑定/Focus state binding
    @FocusState.Binding var isTextEditorFocused: Bool
    
    /// 背景颜色/Background color
    let backgroundColor: Color
    /// 文本颜色/Text color
    let textColor: Color
    
    /// 初始化自动高度文本编辑器/Initialize auto height text editor
    /// - Parameters:
    ///   - inputText: 输入文本绑定/Input text binding
    ///   - placeholder: 占位符文本绑定/Placeholder text binding
    ///   - textFocused: 焦点状态绑定/Focus state binding
    ///   - textColor: 文本颜色，默认.primary/Text color, default .primary
    ///   - backgroundColor: 背景颜色，默认灰色半透明/Background color, default gray opacity
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

/// 视图高度偏好键/View height preference key
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
