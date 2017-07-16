//
//  ItemStore.swift
//  Homepwner
//
//  Created by 임성훈 on 2017. 7. 15..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
//    init() {
//        for _ in 0..<5 {
//            createItem()
//        }
//    }
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func moveItem(fromIndex: Int, toIndex: Int) {
        guard fromIndex != toIndex else { return }
        
        let movedItem = allItems[fromIndex]
        
        allItems.remove(at: fromIndex)
        allItems.insert(movedItem, at: toIndex)
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.index(where: { $0 === item }) {
            allItems.remove(at: index)
        }
    }
}
