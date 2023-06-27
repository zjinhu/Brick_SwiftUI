//
//  ToastView.swift
//  Toast
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

struct ToastView<Content: View>: View {
    @StateObject private var keyboardObserver = KeyboardManager()
    
    init(isActive: Binding<Bool>,
                padding: CGFloat = 10,
                defaultOffset: CGFloat = 0,
                @ViewBuilder content: @escaping ContentBuilder) {
        _isActive = isActive
        self.padding = padding
        self.defaultOffset = defaultOffset
        self.content = content 
    }
    
    typealias ContentBuilder = (_ isActive: Bool) -> Content
    private let content: ContentBuilder
    private let defaultOffset: CGFloat
    private let padding: CGFloat
    @Binding private var isActive: Bool
    
    var body: some View {
        content(isActive)
            .animation(.spring())
            .offset(y: !isActive ? offset : -offset)
            .padding(.horizontal, padding)
            .padding(.top, UIScreen.safeArea.top)
            .padding(.bottom, UIScreen.safeArea.bottom + keyboardObserver.keyboardHeight)
    }
}

extension ToastView {
    
    var offset: CGFloat {
        if isActive { return 0 }
        return defaultOffset
    }
    
    func dismiss() {
        isActive = false
    }
}
