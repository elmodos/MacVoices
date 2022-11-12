//
//  VoiceMenuItem.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 08.11.2022.
//

import AppKit

extension MenuItem {
    func setVoice(_ voice: VoiceData) {
        let titles: [NSAttributedString] = [
            NSAttributedString(string: "\(voice.locale.flagEmoji ?? String.undefinedFlagEmoji) \(voice.locale.languageName ?? "<?>")"),
            NSAttributedString(
                string: voice.name,
                attributes: [
                    .font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize),
                    .foregroundColor: NSColor.secondaryLabelColor
                ]
            )
        ]
        attributedTitle = titles.joined(with: "\n")
    }
}
