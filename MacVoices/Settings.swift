//
//  Settings.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 09.11.2022.
//

import Foundation

public protocol Settings: AnyObject {
    var statusItemConfig: StatusItemConfig { get set }
}

public class UserDefaultsSettings: Settings {
    
    private let userDefaults: UserDefaults
    private enum Keys {
        static let statusItemConfig = "statusItemConfig"
    }
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public var statusItemConfig: StatusItemConfig {
        get { userDefaults.getDecodable(Keys.statusItemConfig) ?? .init() }
        set { userDefaults.setEncodable(Keys.statusItemConfig, value: newValue) }
    }
}

extension UserDefaults {
    
    fileprivate func setEncodable<Value>(_ key: String, value: Value, synchronize: Bool = true) where Value: Encodable {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(value)
            set(data, forKey: String(key))
        } catch {
           print("Failed to encode: \(error)")
        }
    }
    
    fileprivate func getDecodable<Value>(_ key: String) -> Value? where Value: Decodable {
        guard let data = value(forKey: String(key)) as? Data else { return nil }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(Value.self, from: data)
        } catch {
            print("Failed to decode: \(error)")
            return nil
        }
    }
    
    private func save() {
        if !synchronize() {
            print("Failed to synchronize: \(dictionaryRepresentation())")
        }
    }

}
