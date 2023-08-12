//
//  Locale.swift
//  SwiftBrick
//
//  Created by 狄烨 on 2023/6/22.
//

import SwiftUI
import Foundation
extension Brick{
    public struct Language {
        /// The current language of the system.
        ///
        public static var currentLanguage: String? {
            
            if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
                if let languageCode = Foundation.Locale.current.language.languageCode?.identifier {
                    return languageCode
                }
            }else{
                if let languageCode = Foundation.Locale.current.languageCode {
                    return languageCode
                }
            }
            return nil
        }
        
    }
}
 
public extension String {
    var localized: LocalizedStringKey {
        return LocalizedStringKey(self)
    }
}
