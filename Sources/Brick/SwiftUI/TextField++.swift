//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI
extension TextField where Label == Text {
    public init(
        _ title: LocalizedStringKey,
        text: Binding<String>,
        isEditing: Binding<Bool>,
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            title,
            text: text,
            onEditingChanged: { isEditing.wrappedValue = $0 },
            onCommit: onCommit
        )
    }
    
    public init(
        _ title: LocalizedStringKey,
        text: Binding<String?>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            title,
            text: text.withDefaultValue(""),
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }
    
    public init(
        _ title: LocalizedStringKey,
        text: Binding<String?>,
        isEditing: Binding<Bool>,
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            title,
            text: text,
            onEditingChanged: { isEditing.wrappedValue = $0 },
            onCommit: onCommit
        )
    }
}
