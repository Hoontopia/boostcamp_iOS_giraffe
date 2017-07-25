//
//  Record.swift
//  OneToTwentyFive
//
//  Created by 임성훈 on 2017. 7. 24..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import Foundation

class Record: NSObject, NSCoding {
    private let name: String
    private let time: String
    private let date: String
    
    init(name: String, time: String, date: String) {
        self.name = name
        self.time = time
        self.date = date
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let storedName = aDecoder.decodeObject(forKey: "name") as? String else { return nil }
        guard let storedTime = aDecoder.decodeObject(forKey: "time") as? String else { return nil }
        guard let storedDate = aDecoder.decodeObject(forKey: "date") as? String else { return nil }
        
        name = storedName
        time = storedTime
        date = storedDate
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(date, forKey: "date")
    }
    
    func getName() -> String {
        return name
    }
    
    func getClearTime() -> String {
        return time
    }
    
    func getClearDate() -> String {
        return date
    }
}
