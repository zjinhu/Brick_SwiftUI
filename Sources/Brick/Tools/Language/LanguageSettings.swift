//
//  LanguageSettings.swift
//  Plants
//
//  Created by 狄烨 on 2023/9/19.
//

import SwiftUI
import Combine
@MainActor
public class LanguageSettings: ObservableObject {
    public static let shared = LanguageSettings(defaultLanguage: .deviceLanguage)
    
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
    @AppStorage("currentDisplayLanguage") public var currentDisplayLanguage: String = ""
    
    private var bag = Set<AnyCancellable>()
    
    @AppStorage("LanguageManagerSelectedLanguage") private var language: String?
    
    
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

public extension String {
    
    var localizedString: LocalizedStringKey {
        return LocalizedStringKey(self)
    }

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
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

