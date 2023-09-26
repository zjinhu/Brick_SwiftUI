//
//  SelectLanguageView.swift
//  Plants
//
//  Created by 狄烨 on 2023/9/19.
//

import SwiftUI

public struct SelectLanguageView: View {

    @EnvironmentObject var languageSettings: LanguageSettings
    
    public init() { }
    
    public var body: some View {
        List(Localize.getList()) { lg in
            Button {
                withAnimation {
                    languageSettings.selectedLanguage = lg.localize
                    languageSettings.currentDisplayLanguage = lg.country
                }
            } label: {
                HStack {
                    Text(lg.country)
                    Spacer()
                    if languageSettings.selectedLanguage == lg.localize {
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
        .environmentObject(LanguageSettings(defaultLanguage: .deviceLanguage))
}
