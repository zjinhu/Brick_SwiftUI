//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/12/24.
//

import SwiftUI

struct EmptyPlaceholderModifier<Items: Collection>: ViewModifier {
    let items: Items
    let placeholder: AnyView
    
    @ViewBuilder func body(content: Content) -> some View {
        content
            .overlay {
                if items.isEmpty {
                    placeholder
                }
            }
    }
}

extension View {
    func emptyPlaceholder<Items: Collection, PlaceholderView: View>(_ items: Items, _ placeholder: @escaping () -> PlaceholderView) -> some View {
        modifier(EmptyPlaceholderModifier(items: items, placeholder: AnyView(placeholder())))
    }
}
