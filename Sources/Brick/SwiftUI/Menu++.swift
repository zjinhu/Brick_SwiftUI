//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI
 
@available(tvOS 17.0, *)
@available(watchOS, unavailable)
extension Menu {
    public init(
        systemImage: SFSymbolName,
        @ViewBuilder content: () -> Content
    ) where Label == Image {
        let content = content()
        
        self.init(content: { content }) {
            Image(symbol: systemImage)
        }
    }
}

@available(tvOS 17.0, *)
@available(watchOS, unavailable)
extension View {
    /// Presents a `Menu` when this view is pressed.
    public func menuOnPress<MenuContent: View>(
        @ViewBuilder content: () -> MenuContent
    ) -> some View {
        Menu(content: content) {
            self
        }
        .menuStyle(BorderlessButtonMenuStyle())
        .buttonStyle(PlainButtonStyle())
    }
}
