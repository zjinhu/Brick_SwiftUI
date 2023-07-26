//
//  SwiftUIView.swift
//  
//
//  Created by 狄烨 on 2023/7/26.
//

import SwiftUI
public struct LanguageManagerView<Content: View>: View {
    
    private let content: Content
    @ObservedObject private var settings: LanguageOB
    
    public init(_ defaultLanguage: Languages, content: () -> Content) {
        self.content = content()
        self.settings = LanguageOB(defaultLanguage: defaultLanguage)
    }
    
    public var body: some View {
        content
            .environment(\.locale, settings.local)
            .environment(\.layoutDirection, settings.layout)
            .id(settings.uuid)
            .environmentObject(settings)
    }
}

public extension String {
    var localized: LocalizedStringKey {
        return LocalizedStringKey(self)
    }
}
