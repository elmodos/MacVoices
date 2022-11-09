//
//  MenuAction.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import Foundation

public enum MenuAction {
    case setVoice(VoiceData)
    case refreshVoices
    case quitApp
    case setStatusItemStyle(StatusItemStyle)
}
