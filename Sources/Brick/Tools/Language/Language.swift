//
//  Language.swift
//  Plants
//
//  Created by 狄烨 on 2023/9/19.
//

import Foundation

/// 支持的语言列表/Supported languages list
public enum Languages: String {
    case ar, en, nl, ja, ko, vi, ru, sv, fr, es, pt, it, de, da, fi, nb, tr, el, id,
         ms, th, hi, hu, pl, cs, sk, uk, hr, ca, ro, he, ur, fa, ku, arc, sl, ml, am, zh, cn
}

/// 语言/Language
/// 语言结构体，包含国家名称和语言类型。/Language struct containing country name and language type.
public struct Language : Identifiable, Hashable{
    public var id: String { localize.rawValue }
    /// 国家/地区名称/Country/Region name
    public let country: String
    /// 语言类型/Language type
    public let localize: Languages
    
    public init(country: String, localize: Languages) {
        self.country = country
        self.localize = localize
    }
}

/// 本地化工具/Localization utility
public struct Localize {
    /// 获取应用可用语言列表/Get list of available languages for the app
    /// - Parameter excludeBase: 是否排除Base语言/Whether to exclude Base language
    /// - Returns: 可用语言代码数组/Array of available language codes
    public static func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // 如果excludeBase为true，不包含Base/If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    public static func getList() -> [Language] {
        let codes = Bundle.main.localizations.filter { $0 != "Base" }
        var seen = Set<String>()
        var array: [Language] = []

        for local in codes {
            let normalized: String
            switch local {
            case "en-GB", "en-AU", "en-CA", "en-IN":  normalized = "en"
            case "zh-HK", "zh-Hant":                  normalized = "zh"
            case "zh-Hans":                           normalized = "cn"
            case "es-419", "es-MX", "es-US":          normalized = "es"
            case "pt-BR", "pt-PT":                    normalized = "pt"
            case "fr-CA":                             normalized = "fr"
            default:                                  normalized = local
            }

            guard seen.insert(normalized).inserted else { continue }

            switch normalized {
            case "de":      array.append(Language(country: "Deutsch",        localize: .de))
            case "ar":      array.append(Language(country: "عربي",           localize: .ar))
            case "ja":      array.append(Language(country: "日本語",          localize: .ja))
            case "en":      array.append(Language(country: "English",        localize: .en))
            case "nb":      array.append(Language(country: "Norsk bokmål",   localize: .nb))
            case "zh":      array.append(Language(country: "繁體中文",         localize: .zh))
            case "es":      array.append(Language(country: "Español",        localize: .es))
            case "cn":      array.append(Language(country: "简体中文",         localize: .cn))
            case "it":      array.append(Language(country: "Italiano",       localize: .it))
            case "sk":      array.append(Language(country: "Slovenčina",     localize: .sk))
            case "ms":      array.append(Language(country: "Melayu",         localize: .ms))
            case "sv":      array.append(Language(country: "Svenska",        localize: .sv))
            case "ko":      array.append(Language(country: "한국어",           localize: .ko))
            case "hu":      array.append(Language(country: "Magyar",         localize: .hu))
            case "tr":      array.append(Language(country: "Türkçe",         localize: .tr))
            case "pl":      array.append(Language(country: "Polski",         localize: .pl))
            case "vi":      array.append(Language(country: "Tiếng Việt",     localize: .vi))
            case "ru":      array.append(Language(country: "Русский",        localize: .ru))
            case "pt":      array.append(Language(country: "Português",      localize: .pt))
            case "fr":      array.append(Language(country: "Français",       localize: .fr))
            case "id":      array.append(Language(country: "Indonesia",      localize: .id))
            case "nl":      array.append(Language(country: "Nederlands",     localize: .nl))
            case "th":      array.append(Language(country: "ภาษาไทย",         localize: .th))
            case "ro":      array.append(Language(country: "Română",         localize: .ro))
            case "hr":      array.append(Language(country: "Hrvatski",       localize: .hr))
            default:        break
            }
        }
        return array
    }
}
