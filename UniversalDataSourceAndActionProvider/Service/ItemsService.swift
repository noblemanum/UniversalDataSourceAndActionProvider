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
    
    var data = [AnyHashable]()
    
    func fetchPage(anchor: UUID?, pageSize: Int = 15, completion: (([AnyHashable]) -> Void)?) {
        guard let anchor = anchor else {
            completion?(Array(data.prefix(15)))
            return
        }

        guard let index = data.firstIndex(where: { ($0 as! Item).uuid == anchor }) else {
            completion?([])
            return
        }
        
        let start = index + 1
        let end = index + 15
        
        if data.indices.contains(start) {
            if data.indices.contains(end) {
                completion?(Array(data[start...end]))
            } else {
                completion?(Array(data[start..<data.endIndex]))
            }
        }
    }
    
    private func generateData(count: Int) {
        for num in (0..<count) {
            switch ItemType.allCases.randomElement()! {
            case .white:
                data.append(WhiteItem(title: "Ячейка \(num + 1)"))
            case .yellow:
                data.append(YellowItem(title: "Ячейка \(num + 1)"))
            case .brown:
                data.append(BrownItem(title: "Ячейка \(num + 1)"))
            case .gray:
                data.append(GrayItem(title: "Ячейка \(num + 1)"))
            }
        }
    }
}
