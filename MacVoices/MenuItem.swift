//
//  MenuItem.swift
//  MacVoices
//
//  Created by Modo Ltunzher on 07.11.2022.
//

import AppKit
import Combine

public class MenuItem: NSMenuItem {
    
    private var closure: (() -> Void)?
    private var checkedStateSubscription: AnyCancellable?

    public func setTarget(with closure: @escaping () -> Void) {
        self.closure = closure
        target = self
        action = #selector(onTriggered(_:))
    }
    
    @objc private func onTriggered(_ sender: MenuItem) {
        closure?()
    }
    
    func subscribeCheckedState(_ publisher: AnyPublisher<Bool, Never>) {
        checkedStateSubscription = publisher.sink(receiveValue: { [weak self] checked in
            self?.state = checked ? .on : .off
        })
    }
}
