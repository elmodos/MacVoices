//
//  StatusItemConfigurator.swift
//  MacVoices
//
//  Created by Dima Dehtiaruk on 09.11.2022.
//

import AppKit

public protocol StatusItemConfiguring {
    func apply(config: StatusItemConfig, statusItem: NSStatusItem, voice: VoiceData?)
}

public struct StatusItemConfigurator: StatusItemConfiguring {
    
    private let systemSymbolName = "quote.bubble.fill"
    
    private var statusItemImage: NSImage? {
        NSImage(systemSymbolName: systemSymbolName, accessibilityDescription: nil)
    }
    
    public func apply(config: StatusItemConfig, statusItem: NSStatusItem, voice: VoiceData?) {
        precondition(Thread.isMainThread)
        statusItem.length = NSStatusItem.variableLength
        
        guard let button = statusItem.button else { return }
        button.imagePosition = .imageLeading
        button.image = config.showIcon ? statusItemImage : nil
        
        let components: [String?] = [
            config.showFlag ? (voice?.locale.flagEmoji ?? String.undefinedFlagEmoji) : nil,
            config.showLanguage ? voice?.locale.languageName : nil,
            config.showName ? voice?.name : nil
        ]
        button.title = components.compactMap { $0 }.joined(separator: " ")
    }
}
