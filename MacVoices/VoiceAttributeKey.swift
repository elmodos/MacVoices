//
//  VoiceAttributeKey.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import AppKit

extension NSSpeechSynthesizer.VoiceAttributeKey {
    static let numericID: NSSpeechSynthesizer.VoiceAttributeKey = .init(rawValue: "VoiceNumericID")
    static let synthesizerNumericID: NSSpeechSynthesizer.VoiceAttributeKey = .init(rawValue: "VoiceSynthesizerNumericID")
}

extension Dictionary where Key == NSSpeechSynthesizer.VoiceAttributeKey, Value == Any {
    public var name: String? {
        self[.name] as? String
    }

    public var numericID: Int32? {
        self[.numericID] as? Int32
    }
    
    public var identifier: String? {
        self[.identifier] as? String
    }
    
    public var localeIdentifier: String? {
        self[.localeIdentifier] as? String
    }
    
    public var synthesizerNumericID: Int32? {
        self[.synthesizerNumericID] as? Int32
    }
}

extension Dictionary where Key == NSSpeechSynthesizer.VoiceAttributeKey, Value == Any {
    public var isEnhanced: Bool {
        name.orEmpty.contains("Enhanced")
        || identifier.orEmpty.contains("enhanced")
        || identifier.orEmpty.contains("premium")
    }
}

extension Optional where Wrapped == String {
    fileprivate var orEmpty: String {
        self ?? ""
    }
}
