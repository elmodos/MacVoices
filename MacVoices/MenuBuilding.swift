//
//  MenuBuilding.swift
//  MacVoices
//
//  Created by Dima Dehtiaruk on 08/11/2022.
//

import AppKit
import Combine

public struct MenuBuildingPublishers {
    let menuActions: PassthroughSubject<MenuAction, Never>
    let menuState: AnyPublisher<MenuState, Never>
}

public protocol MenuBuilding {
    func buildMenu(voices: [VoiceData], publishers: MenuBuildingPublishers) -> NSMenu
}
