//
//  Locale.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import Foundation

extension Locale {
    var flagEmoji: String? {
        if regionCode == "001" && languageCode == "ar" {
            return "🇸🇦"
        }
        return regionCode?.unicodeScalars
            .map { 127397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    var languageName: String? {
        let currentLocale = Locale.current
        return languageCode.flatMap { currentLocale.localizedString(forLanguageCode: $0) }
    }
}
