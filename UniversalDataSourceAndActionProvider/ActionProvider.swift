//
//  ActionProvider.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 13.07.2022.
//

import UIKit


final class ActionRegistration {
    private let action: (Any) -> Void
    
    init<Item>(action: @escaping (Item) -> Void) {
        self.action = { action($0 as! Item) }
    }
    
    func performAction(item: Any) {
        action(item)
    }
}

final class ActionProvider<Item: Hashable> {
    
    private final class MutableRef<Value> {
        var value: Value
        
        init(_ value: Value) {
            self.value = value
        }
    }
    
    private var registrations = MutableRef<[ObjectIdentifier: ActionRegistration]>([:])
    
    func registerAction<Item>(itemType: Item.Type, action: @escaping (Item) -> Void) {
        let key = ObjectIdentifier(itemType)
        let registration = ActionRegistration(action: action)
        registrations.value[key] = registration
    }
    
    func performAction(for item: Item) {
        let itemType = type(of: (item as AnyHashable).base)
        let key = ObjectIdentifier(itemType)
        guard let registration = registrations.value[key] else {
            assertionFailure("No register action for item of type: \(itemType)")
            return
        }

        registration.performAction(item: item)
    }
}
