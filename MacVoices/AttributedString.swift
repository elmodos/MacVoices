//
//  AttributedString.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import Foundation

extension Sequence where Element: NSAttributedString {
    func joined(with separator: NSAttributedString) -> NSAttributedString {
        let result = NSMutableAttributedString()
        enumerated().forEach { element in
            let (offset, string) = element
            guard string.length > 0 else { return }
            if offset > 0 {
                result.append(separator)
            }
            result.append(string)
        }
        return result
    }
}
