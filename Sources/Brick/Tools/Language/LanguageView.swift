//
//  LanguageView.swift
//  Plants
//
//  Created by 狄烨 on 2023/9/19.
//

import SwiftUI

public struct LanguageView<Content: View>: View {
    private let content: Content
    @StateObject private var settings: LanguageSettings = .shared

    public init(_ content: () -> Content) {
        self.content = content()
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
    LanguageView {
        Text("Hi")
    }
}
