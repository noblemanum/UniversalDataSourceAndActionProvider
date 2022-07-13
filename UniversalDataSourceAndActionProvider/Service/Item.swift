//
//  Item.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 13.07.2022.
//

import Foundation

protocol Item: Hashable {
    var uuid: UUID { get }
    var color: String { get }
    var title: String { get }
}

enum ItemType: CaseIterable {
    case white, yellow, brown, gray
}

struct WhiteItem: Item {
    var uuid = UUID()
    var color: String = "white"
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

struct YellowItem: Item {
    var uuid = UUID()
    var color: String = "yellow"
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

struct BrownItem: Item {
    var uuid = UUID()
    var color: String = "brown"
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

struct GrayItem: Item {
    var uuid = UUID()
    var color: String = "gray"
    var title: String
    
    init(title: String) {
        self.title = title
    }
}
