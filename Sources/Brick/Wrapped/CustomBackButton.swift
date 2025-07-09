//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/26.
//

import SwiftUI
#if os(iOS)

@available(macOS, unavailable)
@available(tvOS, unavailable)
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

@available(macOS, unavailable)
@available(tvOS, unavailable)
extension Brick where Wrapped: View {
    @MainActor public func navigationCustomBackButton<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        wrapped.modifier(CustomBackButton(view: content()))
    }
}

#endif
