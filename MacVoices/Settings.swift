//
//  Settings.swift
//  MacVoices
//
//  Created by Dima Dehtiaruk on 09/11/2022.
//

import Foundation

public protocol Settings: AnyObject {
    var statusItemStyle: StatusItemStyle { get set }
}

public class UserDefaultsSettings: Settings {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    public var statusItemStyle: StatusItemStyle {
        get { userDefaults.getRaw("statusItemStyle") ?? .icon }
        set { userDefaults.setRaw("statusItemStyle", value: newValue) }
    }
    
    private func save() {
        if !userDefaults.synchronize() {
            print("Failed to synchronize: \(userDefaults.dictionaryRepresentation())")
        }
    }
}

extension UserDefaults {
    
    fileprivate func getRaw<R>(_ key: String) -> R? where R: RawRepresentable, R.RawValue == Int {
        if let rawValue = value(forKey: key) as? R.RawValue,
           let value = R(rawValue: rawValue) {
             return value
        }
        return nil
    }
    
    fileprivate func setRaw<R>(_ key: String, value: R, synchronize: Bool = true) where R: RawRepresentable, R.RawValue == Int {
        set(value.rawValue, forKey: key)
        save()
    }

    private func save() {
        if !synchronize() {
            print("Failed to synchronize: \(dictionaryRepresentation())")
        }
    }

}
