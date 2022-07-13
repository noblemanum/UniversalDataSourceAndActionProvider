//
//  ItemsService.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 12.07.2022.
//

import Foundation

final class ItemsService {
    
    init(itemsCount: Int = 300) {
        generateData(count: itemsCount)
        
    }
    
    var data = [Item]()
    
    func fetchPage(anchor: UUID?, pageSize: Int = 15, completion: (([Item]) -> Void)?) {
        guard let anchor = anchor else {
            completion?(Array(data.prefix(pageSize)))
            return
        }

        guard let index = data.firstIndex(where: { $0.anchor == anchor }) else {
            completion?([])
            return
        }
        
        let start = index + 1
        let end = index + pageSize
        
        if data.indices.contains(start) {
            if data.indices.contains(end) {
                completion?(Array(data[start...end]))
            } else {
                completion?(Array(data[start..<data.endIndex]))
            }
        }
    }
    
    private func generateData(count: Int) {
        
        var randomImage: String {
            ["sun.max.fill",
             "brain.head.profile",
             "cross.circle.fill",
             "hand.thumbsup",
             "figure.wave.circle"].randomElement()!
        }
        
        for num in (0..<count) {
            switch ItemType.allCases.randomElement()! {
            case .tile:
                let tileItem = TileItem(title: "Tile Cell - \(num + 1)",
                                        textDescription: "This is cell with image, title and description",
                                        imageName: randomImage)
                data.append(Item(tileItem: tileItem))
            case .simple:
                let simpleItem = SimpleItem(title: "Simple Cell - \(num + 1)",
                                            subtitle: "This is simple cell with title and subtitle")
                data.append(Item(simpleItem: simpleItem))
            case .alert:
                let alertItem = AlertItem(title: "Alert Cell - \(num + 1)",
                                          icon: "exclamationmark.triangle")
                data.append(Item(alertItem: alertItem))
            }
        }
    }
}
