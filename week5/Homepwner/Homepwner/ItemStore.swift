//
//  ItemStore.swift
//  Homepwner
//
//  Created by 임성훈 on 2017. 7. 15..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class ItemStore: NSObject {
    var allItems = [Item]()
    
    private let itemArchiveURL: URL? = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask)
        guard let documentDirectory = documentsDirectories.first else { return nil }
        
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    override init() {
        guard let path = itemArchiveURL?.path else { return }
        guard let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: path)
            as? [Item] else { return }
        
        allItems = archivedItems
    }
    
    @discardableResult func createItem() -> Item {
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
    
    func saveChanges() -> Bool {
        guard let path = itemArchiveURL?.path else { return false }
        
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: path)
    }
}
