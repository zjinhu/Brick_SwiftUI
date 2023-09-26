//
//  LanguageView.swift
//  Plants
//
//  Created by 狄烨 on 2023/9/19.
//

import SwiftUI

public struct LanguageView<Content: View>: View {
    private let content: Content
    @ObservedObject private var settings: LanguageSettings

    public init(_ defaultLanguage: Languages, content: () -> Content) {
        self.content = content()
        self.settings = LanguageSettings(defaultLanguage: defaultLanguage)
    }
    
    public var body: some View {
        content
            .environment(\.locale, settings.local)
            .environment(\.layoutDirection, settings.layout)
            .id(settings.uuid)
            .environmentObject(settings)
    }
}

#Preview {
    LanguageView(.deviceLanguage) {
        Text("Hi")
    }
}
