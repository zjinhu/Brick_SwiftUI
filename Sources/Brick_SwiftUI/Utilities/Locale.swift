//
//  Locale.swift
//  SwiftBrick
//
//  Created by 狄烨 on 2023/6/22.
//

import SwiftUI
import Foundation
extension Brick{
    public struct Locale {
        /// The current language of the system.
        public static var currentLanguage: String? {

            if #available(iOS 16, *) {
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

public class AppLocale: ObservableObject {
   @AppStorage("language") var language = "en"
}
