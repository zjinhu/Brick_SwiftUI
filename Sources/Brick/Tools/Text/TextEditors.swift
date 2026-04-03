//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2024/9/5.
//  增强的TextEditor组件/Enhanced TextEditor component
//  支持占位符、文本限制等功能/Supports placeholder, text limit and more

import SwiftUI
import Combine
#if os(iOS)
/// 增强的TextEditor/Enhanced TextEditor (iOS 15+)
@available(iOS 15.0, *)
public struct TextEditors: View {
    
    /// 文本绑定/Text binding
    @Binding var text: String
    /// 占位符文本/Placeholder text
    private let placeholder: String
    /// 内容内边距/Content padding
    private let contentPadding: CGFloat
    /// 占位符内边距/Placeholder padding
    private let placeholderPadding: CGFloat
    /// 文本限制字符数/Text limit character count
    private let textLimit: Int
    /// 初始化TextEditors/Initialize TextEditors
    /// - Parameters:
    ///   - placeholder: 占位符文本/Placeholder text
    ///   - text: 文本绑定/Text binding
    ///   - contentPadding: 内容内边距/Content padding
    ///   - placeholderPadding: 占位符内边距/Placeholder padding
    ///   - textLimit: 文本限制字符数（0表示不限制）/Text limit (0 = no limit)
    public init(_ placeholder: String,
                text: Binding<String>,
                contentPadding: CGFloat = 8,
                placeholderPadding: CGFloat = 14,
                textLimit: Int = 0) {
        self._text = text
        self.placeholder = placeholder
        self.contentPadding = contentPadding
        self.placeholderPadding = placeholderPadding
        self.textLimit = textLimit
    }
    
    public var body: some View {
        TextEditor(text: $text)
            .multilineTextAlignment(.leading)
            .padding(contentPadding)
            .ss.hideTextViewBackground()
            .onReceive(Just(text)) { _ in limitText() }
            .overlay(alignment: .topLeading) {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .opacity(text.isEmpty ? 1 : 0)
                    .padding(placeholderPadding)
                    .allowsHitTesting(false)
            }
    }
    
    /// 限制文本长度/Limit text length
    func limitText() {
        if textLimit <= 0 { return }
        
        if text.count > textLimit {
            text = String(text.prefix(textLimit))
        }
    }
}
#endif
