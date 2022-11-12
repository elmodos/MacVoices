//
//  SystemConfiguratorMacOsLegacy.swift
//  MacVoices
//
//  Created by Dima Dehtiaruk on 08.11.2022.
//

import Combine

public final class SystemConfiguratorMacOs10: SystemConfiguring {

    public enum Failure: Error {
        case nilSynthID(voiceName: String)
        case shellScriptExecution(args: [String], returnCode: Int32)
    }
    
    private let shellRunner: ShellRunning
    private let defaultsIdentifier = "com.apple.speech.voice.prefs"
    private let processToKill = "SpeechSynthesisServer"
    private let appToOpen =
        "/System/Library/Frameworks/"
        + "ApplicationServices.framework/Versions/A/Frameworks/"
        + "SpeechSynthesis.framework/Versions/A/SpeechSynthesisServer.app"
    
    init(shellRunner: ShellRunning = ShellRunner()) {
        self.shellRunner = shellRunner
    }
    
    public func setSystemVoice(_ voice: VoiceData) async throws {
        guard let synthesizerNumericID = voice.synthesizerNumericID else {
            throw Failure.nilSynthID(voiceName: voice.name)
        }
        
        // Change the settings
        try await run(args: ["defaults", "write", defaultsIdentifier, "SelectedVoiceCreator", "-int", "\(synthesizerNumericID)"])
        try await run(args: ["defaults", "write", defaultsIdentifier, "SelectedVoiceID", "-int", "\(voice.numericID)"])
        try await run(args: ["defaults", "write", defaultsIdentifier, "SelectedVoiceName", "-string", "\(voice.name)"])

        // Restart the SpeechSynthesisServer
        try? await run(args: ["killall", processToKill])
        try await run(args: ["open", appToOpen])
    }
    
    private func run(args: [String]) async throws {
        let returnCode = try await shellRunner.run(args: args)
        if returnCode != 0 {
            throw Failure.shellScriptExecution(args: args, returnCode: returnCode)
        }
    }
}
