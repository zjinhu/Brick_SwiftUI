//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI

extension SecureField where Label == Text {
    public init(
        _ title: LocalizedStringKey,
        text: Binding<String?>,
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            title,
            text: text.withDefaultValue(""),
            onCommit: onCommit
        )
    }
    
    public init<S: StringProtocol>(
        _ title: S,
        text: Binding<String?>,
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            title,
            text: text.withDefaultValue(""),
            onCommit: onCommit
        )
    }
}
