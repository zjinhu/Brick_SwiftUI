//
// Copyright (c) Vatsal Manot
//

import SwiftUI
 
@available(tvOS, unavailable)
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

@available(tvOS, unavailable)
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
