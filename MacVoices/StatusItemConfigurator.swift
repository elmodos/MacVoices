//
//  StatusItemConfigurator.swift
//  MacVoices
//
//  Created by Dima Dehtiaruk on 09/11/2022.
//

import AppKit

public protocol StatusItemConfiguring {
    func applyStatusItemStyle(_ statusItem: NSStatusItem, style: StatusItemStyle, locale: Locale?)
}

public struct StatusItemConfigurator: StatusItemConfiguring {
    
    private let systemSymbolName = "quote.bubble.fill"
    
    private var statusItemImage: NSImage? {
        NSImage(systemSymbolName: systemSymbolName, accessibilityDescription: nil)
    }
    
    public func applyStatusItemStyle(_ statusItem: NSStatusItem, style: StatusItemStyle, locale: Locale?) {
        precondition(Thread.isMainThread)
        statusItem.length = NSStatusItem.variableLength
        statusItem.button?.imagePosition = .imageLeading
        switch style {
        case .icon:
            statusItem.button?.title = ""
            statusItem.button?.image = statusItemImage
        case .flag:
            statusItem.button?.title = locale?.flagEmoji ?? String.undefinedFlagEmoji
            statusItem.button?.image = nil
        case .language:
            statusItem.button?.title = locale?.languageName ?? "?"
            statusItem.button?.image = nil
        case .iconAndFlag:
            statusItem.button?.title = locale?.flagEmoji ?? String.undefinedFlagEmoji
            statusItem.button?.image = statusItemImage
        case .iconAndLanguage:
            statusItem.button?.title = locale?.languageName ?? "?"
            statusItem.button?.image = statusItemImage
        case .flagAndLanguage:
            statusItem.button?.title = [locale?.flagEmoji ?? String.undefinedFlagEmoji, locale?.languageName ?? "?"].joined(separator: " ")
            statusItem.button?.image = nil
        case .iconAndFlagAndLanguage:
            statusItem.button?.title = [locale?.flagEmoji ?? String.undefinedFlagEmoji, locale?.languageName ?? "?"].joined(separator: " ")
            statusItem.button?.image = statusItemImage
        }
    }
}
