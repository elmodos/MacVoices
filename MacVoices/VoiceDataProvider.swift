//
//  VoiceProvider.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import AppKit

public protocol VoiceDataProviding {
    func voices() -> [VoiceData]
    var currentVoice: VoiceData? { get }
}

public class VoiceDataProvider: VoiceDataProviding {
    public func voices() -> [VoiceData] {
        NSSpeechSynthesizer.availableVoices
            .map(NSSpeechSynthesizer.attributes(forVoice:))
            .compactMap(VoiceData.init(attributes:))
            .sorted(by: { $0.locale.identifier < $1.locale.identifier })
    }
    
    public var currentVoice: VoiceData? {
        let currentVoice = NSSpeechSynthesizer.defaultVoice
        let currentVoiceAttributes = NSSpeechSynthesizer.attributes(forVoice: currentVoice)
        return VoiceData(attributes: currentVoiceAttributes)
    }
}
