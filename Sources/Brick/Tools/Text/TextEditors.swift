//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2024/9/5.
//

import SwiftUI
import Combine
#if os(iOS)
@available(iOS 15.0, *)
public struct TextEditors: View {
    
    @Binding var text: String
    private let placeholder: String
    private let contentPadding: CGFloat
    private let placeholderPadding: CGFloat
    private let textLimit: Int
    
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
    
    func limitText() {
        if textLimit <= 0 { return }
        
        if text.count > textLimit {
            text = String(text.prefix(textLimit))
        }
    }
}
#endif
