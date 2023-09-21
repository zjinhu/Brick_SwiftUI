//
// Copyright (c) Vatsal Manot
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
