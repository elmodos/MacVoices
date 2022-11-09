//
//  MenuState.swift
//  MacVoices
//
//  Created by Dima Dehtiaruk on 08/11/2022.
//

import Foundation

public struct MenuState: Equatable {
    public var currentVoice: VoiceData? = nil
    public var statusItemStyle: StatusItemStyle = .icon
}

public enum StatusItemStyle: Int, CaseIterable {
    case icon = 0
    case flag = 1
    case language = 2
    case iconAndFlag = 3
    case iconAndLanguage = 4
    case flagAndLanguage = 5
    case iconAndFlagAndLanguage = 6
}

extension StatusItemStyle {
    // TODO: move to menu builder
    var asTitle: String {
        switch self {
        case .icon:
            return "Icon"
        case .flag:
            return "Flag"
        case .language:
            return "Language"
        case .iconAndFlag:
            return "Icon and flag"
        case .iconAndLanguage:
            return "Icon and language"
        case .flagAndLanguage:
            return "Flag and language"
        case .iconAndFlagAndLanguage:
            return "Icon, flag and language"
        }
    }
}
