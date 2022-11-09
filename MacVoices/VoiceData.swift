//
//  VoiceData.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import AppKit

public struct VoiceData: Equatable {
    let name: String
    let locale: Locale
    let identifier: String
    let numericID: Int32
    let synthesizerNumericID: Int32?
    let isEnhanced: Bool
}

extension VoiceData {
    init?(attributes: [NSSpeechSynthesizer.VoiceAttributeKey : Any]) {
        guard
            let name = attributes.name,
            let identifier = attributes.identifier,
            let numericID = attributes.numericID,
            let localeString = attributes.localeIdentifier
        else {
            return nil
        }
        
        let locale = Locale(identifier: localeString)
        guard
            let languageCode = locale.languageCode,
                !languageCode.isEmpty
        else {
            return nil
        }
        
        self.init(
            name: name,
            locale: locale,
            identifier: identifier,
            numericID: numericID,
            synthesizerNumericID: attributes.synthesizerNumericID,
            isEnhanced: attributes.isEnhanced
        )
        print(self)
    }
}
