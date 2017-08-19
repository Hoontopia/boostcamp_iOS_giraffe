//
//  Item.swift
//  Homepwner
//
//  Created by 임성훈 on 2017. 7. 15..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit



class Item: NSObject, NSCoding {
    private struct Key {
        static let name: String = "name"
        static let dateCreated: String = "dateCreated"
        static let itemKey: String = "itemKey"
        static let serialNumber: String = "serialNumber"
        static let valueInDollars: String = "valueInDollars"
    }
    
    private var _name: String
    private var _valueInDollars: Int
    private var _serialNumber: String?
    private var _dateCreated: Date
    private var _itemKey: String
    
    open var name: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }
    
    open var valueInDollars: Int {
        get {
            return _valueInDollars
        }
        set {
            _valueInDollars = newValue
        }
    }
    
    open var serialNumber: String? {
        get {
            return _serialNumber
        }
        set {
            _serialNumber = newValue
        }
    }
    
    open var dateCreated: Date {
        get {
            return _dateCreated
        }
        set {
            _dateCreated = newValue
        }
    }
    
    open var itemKey: String {
        return _itemKey
    }
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self._name = name
        self._valueInDollars = valueInDollars
        self._serialNumber = serialNumber
        self._dateCreated = Date()
        self._itemKey = UUID().uuidString
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let storedName = aDecoder.decodeObject(forKey: Key.name) as? String,
            let storedDate = aDecoder.decodeObject(forKey: Key.dateCreated) as? Date,
            let storedSerial = aDecoder.decodeObject(forKey: Key.serialNumber) as? String?,
            let itemKey = aDecoder.decodeObject(forKey: Key.itemKey) as? String else {
                return nil
        }
        
        let storedValue = aDecoder.decodeInteger(forKey: Key.valueInDollars)
        
        _name = storedName
        _dateCreated = storedDate
        _serialNumber = storedSerial
        _itemKey = itemKey
        _valueInDollars = storedValue
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_name, forKey: Key.name)
        aCoder.encode(_dateCreated, forKey: Key.dateCreated)
        aCoder.encode(_serialNumber, forKey: Key.serialNumber)
        aCoder.encode(_itemKey, forKey: Key.itemKey)
        aCoder.encode(_valueInDollars, forKey: Key.valueInDollars)
    }
    
    convenience init(random: Bool = false) {
        guard random else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
            return
        }
        
        let adjectives = ["Fluffy", "Rusty", "Shiny"]
        let nouns = ["Bear", "Spork", "Mac"]
        
        // arc4random_uniform : 0을 포함하여 0부터 인자로 전달한 값 사이의 임의의 값 반환
        var idx = arc4random_uniform(UInt32(adjectives.count))
        let randomAdjective = adjectives[Int(idx)]
        
        idx = arc4random_uniform(UInt32(nouns.count))
        let randomNoun = nouns[Int(idx)]
        
        let randomName = "\(randomAdjective) \(randomNoun)"
        let randomValue = Int(arc4random_uniform(100))
        let randomSerialNumber = NSUUID().uuidString.components(separatedBy: "-").first
        
        self.init(name: randomName, serialNumber: randomSerialNumber, valueInDollars: randomValue)
    }
}
