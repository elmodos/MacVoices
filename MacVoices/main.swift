//
//  main.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import AppKit

let appDelegate = AppDelegate()
let application = NSApplication.shared
application.setActivationPolicy(.accessory)
application.delegate = appDelegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
