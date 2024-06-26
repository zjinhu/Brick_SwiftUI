//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI

extension Label where Title == Text {
    /// Creates a label with a system icon image and a title generated from a
    /// localized string.
        public init(_ titleKey: LocalizedStringKey, @ViewBuilder icon: () -> Icon) {
        self.init(title: { Text(titleKey) }, icon: icon)
    }
    
    /// Creates a label with a system icon image and a title generated from a
    /// string.
        public init<S: StringProtocol>(_ title: S,  @ViewBuilder icon: () -> Icon) {
        self.init(title: { Text(title) }, icon: icon)
    }
}

extension Label where Title == Text, Icon == Image {
    /// Creates a label with a system icon image and a title generated from a
    /// localized string.
        public init(_ titleKey: LocalizedStringKey, systemImage symbol: SFSymbolName) {
        self.init(titleKey, systemImage: symbol.symbolName)
    }
    
    /// Creates a label with a system icon image and a title generated from a
    /// string.
        public init<S: StringProtocol>(_ title: S, systemImage symbol: SFSymbolName) {
        self.init(title, systemImage: symbol.symbolName)
    }
}

public extension View {
    
    /// Convert the view to a label.
    ///
    /// - Parameters:
    ///   - text: The label text.
    func label(
        _ text: LocalizedStringKey,
        bundle: Bundle? = nil
    ) -> some View {
        Label {
            Text(text, bundle: bundle)
        } icon: {
            self
        }
    }
}
