//
//  LanguageOB.swift
//  BrickBrickDemo
//
//  Created by 狄烨 on 2023/7/26.
//

import SwiftUI
import Combine

public class LanguageSettings: ObservableObject {
    
    public var local: Locale {
        Locale(identifier: selectedLanguage.rawValue)
    }
    
    public var deviceLanguage: Languages? {
        guard let deviceLanguage = Bundle.main.preferredLocalizations.first else {
            return nil
        }
        return Languages(rawValue: deviceLanguage)
    }
    
    public var layout: LayoutDirection {
        isRightToLeft ? .rightToLeft : .leftToRight
    }
    
    public var isRightToLeft: Bool {
        isLanguageRightToLeft(language: selectedLanguage)
    }
    
    var uuid: String {
        UUID().uuidString
    }
    
    @Published public var selectedLanguage: Languages = .deviceLanguage
    @Published public var currentDisplayLanguage: String = ""
    
    private var bag = Set<AnyCancellable>()
    
    @AppStorage("LanguageManagerSelectedLanguage") private var _language: String?
    
    public init(defaultLanguage: Languages) {
        if _language == nil {
            _language = (defaultLanguage == .deviceLanguage ? deviceLanguage : defaultLanguage).map { $0.rawValue }
        }
        
        selectedLanguage = Languages(rawValue: _language!)!
        
        observeForSelectedLanguage()
    }
    
    private func observeForSelectedLanguage() {
        $selectedLanguage
            .map({ $0.rawValue })
            .sink { [weak self] value in
                self?._language = value
            }
            .store(in: &bag)
    }
    
    private func isLanguageRightToLeft(language: Languages) -> Bool {
        return Locale.characterDirection(forLanguage: language.rawValue) == .rightToLeft
    }
}

public enum Languages: String {
    case ar, en, nl, ja, ko, vi, ru, sv, fr, es, pt, it, de, da, fi, nb, tr, el, id,
         ms, th, hi, hu, pl, cs, sk, uk, hr, ca, ro, he, ur, fa, ku, arc, sl, ml, am
    case enGB = "en-GB"
    case enAU = "en-AU"
    case enCA = "en-CA"
    case enIN = "en-IN"
    case frCA = "fr-CA"
    case esMX = "es-MX"
    case ptBR = "pt-BR"
    case zhHans = "zh-Hans"
    case zhHant = "zh-Hant"
    case zhHK = "zh-HK"
    case es419 = "es-419"
    case ptPT = "pt-PT"
    case deviceLanguage
}
