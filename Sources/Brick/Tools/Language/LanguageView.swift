//
//  LanguageView.swift
//  Plants
//
//  Created by 狄烨 on 2023/9/19.
//

import SwiftUI

/// 语言视图/Language view
/// 根据LanguageSettings自动调整区域和布局方向的视图包装器。/View wrapper that automatically adjusts locale and layout direction based on LanguageSettings.
public struct LanguageView<Content: View>: View {
    private let content: Content
    @StateObject private var settings: LanguageSettings = .shared

    /// 初始化语言视图/Initialize language view
    /// - Parameter content: 内容视图/Content view
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
