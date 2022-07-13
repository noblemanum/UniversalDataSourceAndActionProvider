//
//  Mapper.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 13.07.2022.
//

import Foundation

enum Mapper {
    static func map(_ items: [Item]) -> [AnyHashable] {
        return items.compactMap { item in
            if let tileItem = item.tileItem {
                return TileCellViewModel(title: tileItem.title,
                                         textDescription: tileItem.textDescription,
                                         imageName: tileItem.imageName)
            } else if let simpleItem = item.simpleItem {
                return SimpleCellViewModel(title: simpleItem.title, subtitle: simpleItem.subtitle)
            } else if let alertItem = item.alertItem {
                return AlertCellViewModel(title: alertItem.title, icon: alertItem.icon)
            } else {
                return nil
            }
        }
    }
}
