//
//  Language.swift
//  Plants
//
//  Created by 狄烨 on 2023/9/19.
//

import Foundation

public struct Language : Identifiable{
    public let id = UUID()
    let country: String
    let localize: Languages
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

public struct Localize {
    public static func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    public static func getList() -> [Language]{
        var array: [Language] = []
        for local in Bundle.main.localizations{
            switch local {
            case "de":
                array.append(Language(country: "Deutsch", localize: .de))
            case "ar":
                array.append(Language(country: "عربي", localize: .ar))
            case "ja":
                array.append(Language(country: "日本", localize: .ja))
            case "en":
                array.append(Language(country: "English", localize: .en))
            case "nb":
                array.append(Language(country: "Norsk bokmål", localize: .nb))
            case "zh-Hant":
                array.append(Language(country: "繁体中文", localize: .zhHant))
            case "es":
                array.append(Language(country: "España", localize: .es))
            case "zh-Hans":
                array.append(Language(country: "简体中文", localize: .zhHans))
            case "it":
                array.append(Language(country: "Italia", localize: .it))
            case "sk":
                array.append(Language(country: "Slovensko", localize: .sk))
            case "ms":
                array.append(Language(country: "Malaysia", localize: .ms))
            case "sv":
                array.append(Language(country: "Sverige", localize: .sv))
            case "ko":
                array.append(Language(country: "남한", localize: .ko))
            case "hu":
                array.append(Language(country: "Magyarország", localize: .hu))
            case "tr":
                array.append(Language(country: "Türkiye", localize: .tr))
            case "pl":
                array.append(Language(country: "Polska", localize: .pl))
            case "vi":
                array.append(Language(country: "Việt Nam", localize: .vi))
            case "ru":
                array.append(Language(country: "Россия", localize: .ru))
            case "pt-PT":
                array.append(Language(country: "Português", localize: .ptPT))
            case "fr":
                array.append(Language(country: "France", localize: .fr))
            case "id":
                array.append(Language(country: "Indonesia", localize: .id))
            case "nl":
                array.append(Language(country: "Nederlands", localize: .nl))
            case "th":
                array.append(Language(country: "ประเทศไทย", localize: .th))
            case "ro":
                array.append(Language(country: "România", localize: .ro))
            case "hr":
                array.append(Language(country: "Hrvatska", localize: .hr))
            default:
                break
            }
        }
        return array
    }
}
