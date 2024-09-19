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
    @FocusState private var isTextEditorFocused: Bool

    var sendAction: SendCommentAction?
    public typealias SendCommentAction = () -> Void
    
    public init(inputText: Binding<String>,
         placeholder: Binding<String>,
         sendAction: SendCommentAction? = nil) {
        self._inputText = inputText
        self._placeholder = placeholder
        self.sendAction = sendAction
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
                    .foregroundStyle(.white)
                
                
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
                .fill(Color(hex: "3c3c45"))
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
    AutoHeightTextEditor(inputText: .constant(""), placeholder: .constant("11111"))
}
#endif
