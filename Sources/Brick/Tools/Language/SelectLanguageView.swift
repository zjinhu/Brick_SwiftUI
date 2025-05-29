//
//  SelectLanguageView.swift
//  Plants
//
//  Created by 狄烨 on 2023/9/19.
//

import SwiftUI

public struct SelectLanguageView: View {

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
