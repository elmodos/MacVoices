//
//  SystemConfiguratorMacOs13.swift
//  MacVoices
//
//  Created by Dima Dehtiaruk on 08.11.2022.
//

import Foundation
import Combine

@available(macOS 13, *)
public struct SystemConfiguratorMacOs13: SystemConfiguring {
    
    private enum Failure: Error {
        case todo(String)
    }
    
    private let shellRunner: ShellRunning
    
    init(shellRunner: ShellRunning = ShellRunner()) {
        self.shellRunner = shellRunner
    }
    
    public func setSystemVoice(_ voice: VoiceData) async throws {
        throw Failure.todo("MacOS 13 support is in progress")
    }
}
