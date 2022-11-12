//
//  Locale.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import Foundation

fileprivate let fixtures: [LocaleFixture] = [
    .init(targetFlag: "🇸🇦", regionCode: "001", languageCode: "ar"),
    .init(targetFlag: "🏴󠁧󠁢󠁳󠁣󠁴󠁿", variantCode:"SCOTLAND")
]

extension Locale {
    var flagEmoji: String? {
        let fixture = fixtures.first { $0.masks(locale: self) }
        if let fixture {
            return fixture.targetFlag
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

fileprivate struct LocaleFixture {
    let targetFlag: String
    let regionCode: String?
    let languageCode: String?
    let variantCode: String?
    
    init(targetFlag: String, regionCode: String? = nil, languageCode: String? = nil, variantCode: String? = nil) {
        self.targetFlag = targetFlag
        self.regionCode = regionCode
        self.languageCode = languageCode
        self.variantCode = variantCode
    }
}

extension LocaleFixture {
    fileprivate func masks(locale: Locale) -> Bool {
        regionCode.flatMap { $0 == locale.regionCode } ?? true
        && languageCode.flatMap { $0 == locale.languageCode } ?? true
        && variantCode.flatMap { $0 == locale.variantCode } ?? true
    }
}
