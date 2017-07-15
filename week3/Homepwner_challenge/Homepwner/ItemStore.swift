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
    
    init() {
        for _ in 0..<5 {
            createItem()
        }
    }
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func splitBy(dollars: Int) -> [[Item]] {
        var splitedItems: [[Item]] = []
        
        let more = allItems.filter { (item: Item) -> Bool in
            return item.valueInDollars >= 50
        }

        let other = allItems.filter { (Item: Item) -> Bool in
            return Item.valueInDollars < 50
        }
        
        splitedItems.append(more)
        splitedItems.append(other)
        
        return splitedItems
    }
}
