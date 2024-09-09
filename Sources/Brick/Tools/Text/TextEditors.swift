//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2024/9/5.
//

import SwiftUI

@available(iOS 15.0, *)
public struct TextEditors: View {
    
    @Binding var text: String
    private let placeholder: String
    private let contentPadding: CGFloat
    private let placeholderPadding: CGFloat
    
    public init(_ placeholder: String,
                text: Binding<String>,
                contentPadding: CGFloat = 8,
                placeholderPadding: CGFloat = 14) {
        self._text = text
        self.placeholder = placeholder
        self.contentPadding = contentPadding
        self.placeholderPadding = placeholderPadding
    }
    
    public var body: some View {
        TextEditor(text: $text)
            .multilineTextAlignment(.leading)
            .padding(contentPadding)
            .ss.hideTextViewBackground()
            .overlay(alignment: .topLeading) {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .opacity(text.isEmpty ? 1 : 0)
                    .padding(placeholderPadding)
                    .allowsHitTesting(false)
            }
    }
}
