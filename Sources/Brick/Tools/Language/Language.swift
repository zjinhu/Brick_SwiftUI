//
//  Language.swift
//  Plants
//
//  Created by 狄烨 on 2023/9/19.
//

import Foundation

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

/// 支持的语言列表/Supported languages list
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
    /// 设备语言/Device language
    case deviceLanguage
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
    
    /// 获取语言列表/Get language list
    /// - Returns: 语言对象数组/Array of Language objects
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
            case "en","en-GB","en-AU","en-CA","en-IN":
                array.append(Language(country: "English", localize: .en))
            case "nb":
                array.append(Language(country: "Norsk bokmål", localize: .nb))
            case "zh-Hant", "zh-HK":
                array.append(Language(country: "繁体中文", localize: .zhHant))
            case "es", "es-419", "es-MX", "es-US":
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
            case "pt-PT", "pt", "pt-BR":
                array.append(Language(country: "Português", localize: .ptPT))
            case "fr", "fr-CA":
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
