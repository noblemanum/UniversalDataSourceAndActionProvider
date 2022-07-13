//
//  Item.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 13.07.2022.
//

import UIKit

enum ItemType: CaseIterable {
    case tile, simple, alert
}

struct Item: Hashable {
    let anchor = UUID()
    let tileItem: TileItem?
    let simpleItem: SimpleItem?
    let alertItem: AlertItem?
    
    init(tileItem: TileItem? = nil, simpleItem: SimpleItem? = nil, alertItem: AlertItem? = nil) {
        self.tileItem = tileItem
        self.simpleItem = simpleItem
        self.alertItem = alertItem
    }
}

struct TileItem: Hashable {
    private let uuid = UUID()
    let title: String
    let textDescription: String?
    let imageName: String?
}

struct SimpleItem: Hashable {
    private let uuid = UUID()
    let title: String
    let subtitle: String?
}

struct AlertItem: Hashable {
    private let uuid = UUID()
    let title: String
    let icon: String
}
