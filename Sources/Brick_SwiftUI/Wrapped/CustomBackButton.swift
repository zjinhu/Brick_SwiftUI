//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/26.
//

import SwiftUI
@available(macOS, unavailable)
@available(watchOS, unavailable)
struct CustomBackButton<Image: View>: ViewModifier {
    @Environment(\.dismiss) var dismiss
    let view: Image
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        view
                    }
                }
            }
    }
}

extension Brick where Wrapped: View {
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public func navigationCustomBackButton<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        wrapped.modifier(CustomBackButton(view: content()))
    }
}
