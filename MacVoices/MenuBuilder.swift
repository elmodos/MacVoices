//
//  MenuBuilder.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import AppKit
import Combine

public struct MenuBuilder: MenuBuilding {
    
    public func buildMenu(voices: [VoiceData], publishers: MenuBuildingPublishers) -> NSMenu {
        let menu = NSMenu()        
        [
            itemsVoicesEnhanced(from: voices, publishers: publishers),
            itemsVoicesOther(from: voices, publishers: publishers),
            [NSMenuItem.separator()],
            itemMenuBarOptions(publishers: publishers),
            itemRefresh(publishers: publishers),
            itemQuit(publishers: publishers),
        ]
        .joined()
        .forEach { menu.addItem($0) }
        
        return menu
    }
    
    private func itemsVoicesEnhanced(from voices: [VoiceData], publishers: MenuBuildingPublishers) -> [NSMenuItem] {
        voices
            .filter(\.isEnhanced)
            .map { MenuItem(voice: $0, publishers: publishers) }
    }
    
    private func itemsVoicesOther(from voices: [VoiceData], publishers: MenuBuildingPublishers) -> [NSMenuItem] {
        let voicesOther = voices.filter { !$0.isEnhanced }
        guard !voicesOther.isEmpty else { return [] }
        let submenu = NSMenu()
        voicesOther
            .map { MenuItem(voice: $0, publishers: publishers) }
            .forEach { submenu.addItem($0) }
        
        let menuItemOtherVoices = NSMenuItem(title: "More", action: nil, keyEquivalent: "")
        menuItemOtherVoices.submenu = submenu
        return [menuItemOtherVoices]
    }
    
    private func itemMenuBarOptions(publishers: MenuBuildingPublishers) -> [NSMenuItem] {
        let submenu = NSMenu()
        
        [
            MenuItem(title: "Icon", keyPath: \.showIcon, publishers: publishers),
            MenuItem(title: "Flag", keyPath: \.showFlag, publishers: publishers),
            MenuItem(title: "Language", keyPath: \.showLanguage, publishers: publishers),
            MenuItem(title: "Name", keyPath: \.showName, publishers: publishers)
        ]
        .forEach { submenu.addItem($0)}

        let menuItemOptions = NSMenuItem(title: "Options", action: nil, keyEquivalent: "")
        menuItemOptions.submenu = submenu
        return [menuItemOptions]
    }
    
    private func itemRefresh(publishers: MenuBuildingPublishers) -> [NSMenuItem] {
        let menuItemRefreshVoices = MenuItem(title: "Refresh", action: nil, keyEquivalent: "")
        menuItemRefreshVoices.setTarget { publishers.menuActions.send(.refreshVoices) }
        return [menuItemRefreshVoices]
    }
    
    private func itemQuit(publishers: MenuBuildingPublishers) -> [NSMenuItem] {
        let menuItemQuit = MenuItem(title: "Quit", action: nil, keyEquivalent: "")
        menuItemQuit.setTarget { publishers.menuActions.send(.quitApp) }
        return [menuItemQuit]
    }
}

extension MenuItem {
    fileprivate convenience init(voice: VoiceData, publishers: MenuBuildingPublishers) {
        self.init(title: "", action: nil, keyEquivalent: "")
        setVoice(voice)
        setTarget { publishers.menuActions.send(.setVoice(voice)) }
        subscribeCheckedState(publishers.menuConfig.map { $0.currentVoice?.identifier == voice.identifier }.eraseToAnyPublisher())
    }

    fileprivate convenience init(title: String, keyPath: WritableKeyPath<StatusItemConfig, Bool>, publishers: MenuBuildingPublishers) {
        self.init(title: title, action: nil, keyEquivalent: "")
        subscribeCheckedState(publishers.menuConfig.map(\.statusItemConfig).map(keyPath).eraseToAnyPublisher())
 
        setTarget { [weak self] in
            let isChecked = self?.state == .on
            publishers.menuActions.send(.setStatusItemValue(keyPath, value: !isChecked))
        }
    }
}
