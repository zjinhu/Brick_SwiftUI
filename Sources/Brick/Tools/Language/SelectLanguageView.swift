//
//  SelectLanguageView.swift
//  Plants
//
//  Created by 狄烨 on 2023/9/19.
//

import SwiftUI

/// 选择语言视图/Select language view
/// 显示可用语言列表并允许用户选择。/Shows available languages list and allows user to select.
public struct SelectLanguageView: View {

    /// 初始化选择语言视图/Initialize select language view
    public init() { }
    
    public var body: some View {
        List(Localize.getList()) { lg in
            Button {
                withAnimation {
                    LanguageSettings.shared.selectedLanguage = lg.localize
                    LanguageSettings.shared.currentDisplayLanguage = lg.country
                }
            } label: {
                HStack {
                    Text(lg.country)
                    Spacer()
                    if LanguageSettings.shared.selectedLanguage == lg.localize {
                        Image(systemName: "checkmark")
                    }
                }
            }
         }
        .navigationTitle("Language")
    }
}

#Preview {
    SelectLanguageView()
}
