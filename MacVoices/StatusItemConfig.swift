//
//  StatusItemConfig.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 12.11.2022.
//

import Foundation

public struct StatusItemConfig: Equatable, Codable {
    public var showIcon: Bool = false
    public var showFlag: Bool = false
    public var showLanguage: Bool = false
    public var showName: Bool = false
}

extension StatusItemConfig {
    func byMutating<Value>(_ value: Value, keyPath: WritableKeyPath<Self, Value>) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
    
    func adjusted() -> Self {
        // Allow disabling all and fallback to "showIcon = true"
        let mirror = Mirror(reflecting: self)
        let allFalse = false == mirror.children.compactMap { $0.value as? Bool }.reduce(false, { $0 || $1 })
        guard allFalse else { return self }
        return Self.init(showIcon: true)
    }
}
