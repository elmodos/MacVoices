//
//  ShellRunner.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import Foundation

public protocol ShellRunning {
    func run(args: [String]) async throws -> Int32
}

public final class ShellRunner: ShellRunning {
    public func run(args: [String]) async throws -> Int32 {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let process = Process()
                process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
                process.arguments = args
                try process.run()
                process.waitUntilExit()
                continuation.resume(returning: process.terminationStatus)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
