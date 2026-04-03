//
//  LanguageSettings.swift
//  Plants
//
//  Created by 狄烨 on 2023/9/19.
//

import SwiftUI
import Combine

/// 语言设置/Language settings
/// 全局语言设置管理类，管理应用语言选择和布局方向。/Global language settings manager for app language selection and layout direction.
@MainActor
public class LanguageSettings: ObservableObject {
    
    /// 共享单例实例/Shared singleton instance.
    public static let shared = LanguageSettings(defaultLanguage: .deviceLanguage)
    
    /// 当前语言区域设置/Current locale setting
    public var local: Locale {
        Locale(identifier: selectedLanguage.rawValue)
    }
    
    /// 设备语言/Device language
    /// - Returns: 设备当前语言或nil/Device current language or nil
    public var deviceLanguage: Languages? {
        guard let deviceLanguage = Bundle.main.preferredLocalizations.first else {
            return nil
        }
        return Languages(rawValue: deviceLanguage)
    }
    
    /// 布局方向/Layout direction
    /// 根据当前语言返回从左到右或从右到左布局/Returns left-to-right or right-to-left layout based on current language
    public var layout: LayoutDirection {
        isRightToLeft ? .rightToLeft : .leftToRight
    }
    
    /// 是否为从右到左语言/Whether is right-to-left language
    public var isRightToLeft: Bool {
        isLanguageRightToLeft(language: selectedLanguage)
    }
    
    var uuid: String {
        UUID().uuidString
    }
    
    /// 当前选中的语言/Currently selected language
    @Published public var selectedLanguage: Languages = .deviceLanguage
    /// 当前显示语言/Current display language
    @AppStorage("currentDisplayLanguage") public var currentDisplayLanguage: String = ""
    
    private var bag = Set<AnyCancellable>()
    
    @AppStorage("LanguageManagerSelectedLanguage") private var language: String?
    
    
    /// 初始化语言设置/Initialize language settings
    /// - Parameter defaultLanguage: 默认语言/Default language
    public init(defaultLanguage: Languages) {
        if language == nil {
            language = (defaultLanguage == .deviceLanguage ? deviceLanguage : defaultLanguage).map { $0.rawValue }
        }
        
        selectedLanguage = Languages(rawValue: language!)!
        
        observeForSelectedLanguage()
    }
    
    private func observeForSelectedLanguage() {
        $selectedLanguage
            .map({ $0.rawValue })
            .sink { [weak self] value in
                self?.language = value
            }
            .store(in: &bag)
    }
    
    private func isLanguageRightToLeft(language: Languages) -> Bool {
        return Locale.characterDirection(forLanguage: language.rawValue) == .rightToLeft
    }
}

/// 字符串本地化扩展/String localization extension
public extension String {
    
    /// 转换为LocalizedStringKey/Convert to LocalizedStringKey
    var localizedString: LocalizedStringKey {
        return LocalizedStringKey(self)
    }

    /// 本地化字符串/Localized string
    /// 根据当前选中的语言返回本地化字符串/Returns localized string based on currently selected language
    var localized: String {
        guard let selectedLanguage = UserDefaults.standard.string(forKey: "LanguageManagerSelectedLanguage") else {
            return NSLocalizedString(self, comment: "")
                .replacingOccurrences(of: "\\n", with: "\n")
        }

        if let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(self, bundle: bundle, value: "", comment: "")
                .replacingOccurrences(of: "\\n", with: "\n")
        }

        return Bundle.main.localizedString(forKey: self, value: nil, table: nil)
            .replacingOccurrences(of: "\\n", with: "\n")
    }
    
    /// 带参数本地化/Localized with arguments
    /// - Parameter arguments: 可变参数用于格式化/Variadic arguments for formatting
    /// - Returns: 格式化后的本地化字符串/Formatted localized string
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

