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
    private lazy var menuConfigSubject = CurrentValueSubject<MenuConfig, Never>(makeInitialMenuConfig())
    private let settings: Settings = UserDefaultsSettings()
    private var subscriptions = Set<AnyCancellable>()
}

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        refreshVoices()
        setupBindings()
    }
}

extension AppDelegate {
    
    private func makeInitialMenuConfig() -> MenuConfig {
        .init(currentVoice: voiceDataProvider.currentVoice, statusItemConfig: settings.statusItemConfig)
    }
    
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
                case let .setStatusItemValue(keyPath, value):
                    self?.setStatusItemValue(keyPath: keyPath, value: value)
                }
            }
            .store(in: &subscriptions)
        
        // Icon style to status item
        menuConfigSubject
            .removeDuplicates()
            .map(\.statusItemConfig)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.statusItemConfigurator.apply(
                    config: $0,
                    statusItem: self.statusItem,
                    voice: self.voiceDataProvider.currentVoice
                )
            }
            .store(in: &subscriptions)
    }
    
    private func setVoice(_ voiceData: VoiceData) {
        Task {
            do {
                try await systemConfigurator.setSystemVoice(voiceData)
                menuConfigSubject.value.currentVoice = voiceDataProvider.currentVoice
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
                menuConfig: menuConfigSubject.eraseToAnyPublisher()
            )
        )
    }
        
    private func quitApp() {
        NSApplication.shared.terminate(self)
    }
    
    private func setStatusItemValue<Value>(keyPath: WritableKeyPath<StatusItemConfig, Value>, value: Value) {
        let statusItemConfig = menuConfigSubject.value.statusItemConfig.byMutating(value, keyPath: keyPath).adjusted()
        menuConfigSubject.value.statusItemConfig = statusItemConfig
        settings.statusItemConfig = statusItemConfig
    }
}
