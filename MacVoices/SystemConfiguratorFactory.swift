//
//  SystemConfigurator.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import Combine

public protocol SystemConfiguring {
    func setSystemVoice(_ voice: VoiceData) async throws
}

public class SystemConfiguratorFactory {
    public func makeSystemConfigurator() -> SystemConfiguring {
        if #available(macOS 13, *) {
            return SystemConfiguratorMacOs13()
        }
        return SystemConfiguratorMacOs10()
    }
}
