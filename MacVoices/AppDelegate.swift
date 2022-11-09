//
//  AppDelegate.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import AppKit
import Combine

class AppDelegate: NSObject {
    private lazy var statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let statusItemConfigurator: StatusItemConfiguring = StatusItemConfigurator()
    private let menuBuilder: MenuBuilding = MenuBuilder()
    private let voiceDataProvider: VoiceDataProviding = VoiceDataProvider()
    private let systemConfigurator: SystemConfiguring = SystemConfiguratorFactory().makeSystemConfigurator()
    private let menuActionSubject = PassthroughSubject<MenuAction, Never>()
    private let menuStateSubject = CurrentValueSubject<MenuState, Never>(.init())
    private let settings: Settings = UserDefaultsSettings()
    private var subscriptions = Set<AnyCancellable>()
}

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menuStateSubject.value = .init(
            currentVoice: voiceDataProvider.currentVoice,
            statusItemStyle: settings.statusItemStyle
        )
        refreshVoices()
        setupBindings()
    }
}

extension AppDelegate {
    private func setupBindings() {
        // Actions triggered by menu items
        menuActionSubject
            .sink { [weak self] menuAction in
                switch menuAction {
                case .setVoice(let voiceData):
                    self?.setVoice(voiceData)
                case .refreshVoices:
                    self?.refreshVoices()
                case .quitApp:
                    self?.quitApp()
                case .setStatusItemStyle(let style):
                    self?.setStatusItemStyle(style)
                }
            }
            .store(in: &subscriptions)
        
        // Icon style to status item
        menuStateSubject
            .removeDuplicates()
            .map { [weak self] in
                (style: $0.statusItemStyle, locale: self?.voiceDataProvider.currentVoice?.locale)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.statusItemConfigurator.applyStatusItemStyle(self.statusItem, style: $0.style, locale:  $0.locale)
            }
            .store(in: &subscriptions)
    }
    
    private func setVoice(_ voiceData: VoiceData) {
        Task {
            do {
                try await systemConfigurator.setSystemVoice(voiceData)
                menuStateSubject.value.currentVoice = voiceDataProvider.currentVoice
            } catch {
                print(error)
            }
        }
    }

    private func refreshVoices() {
        statusItem.menu = menuBuilder.buildMenu(
            voices: voiceDataProvider.voices(),
            publishers: MenuBuildingPublishers(
                menuActions: menuActionSubject,
                menuState: menuStateSubject.eraseToAnyPublisher()
            )
        )
    }
        
    private func quitApp() {
        NSApplication.shared.terminate(self)
    }
    
    private func setStatusItemStyle(_ style: StatusItemStyle) {
        settings.statusItemStyle = style
        menuStateSubject.value.statusItemStyle = style
    }
}
