//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/12/24.
//

import SwiftUI

struct EmptyPlaceholderModifier<Items: Collection, PlaceholderView: View>: ViewModifier {
    let items: Items
    let placeholder: PlaceholderView
    
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
    public func emptyPlaceholder<Items: Collection, PlaceholderView: View>(_ items: Items, _ placeholder: @escaping () -> PlaceholderView) -> some View {
        modifier(EmptyPlaceholderModifier(items: items, placeholder: placeholder()))
    }
}
