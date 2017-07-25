//
//  Record.swift
//  OneToTwentyFive
//
//  Created by 임성훈 on 2017. 7. 24..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import Foundation

class RecordStore: NSObject {
    var records: [Record] = [Record]()
    
    private let recordArchiveURL: URL? = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = documentsDirectories.first else { return nil }
        
        return documentDirectory.appendingPathComponent("records.archive")
    }()
    
    override init() {
        guard let path = recordArchiveURL?.path else { return }
        guard let archivedRecords = NSKeyedUnarchiver.unarchiveObject(withFile: path)
            as? [Record] else {
            return
        }
        
        records = archivedRecords
    }
    
    func addRecord(_ record: Record) {
        records.append(record)
        records.sort(by: { $0.getClearTime() < $1.getClearTime() })
    }
    
    func getBestRecord() -> Record? {
        guard let bestRecord = records.first else { return nil }
        return bestRecord
    }
    
    func saveChanges() -> Bool {
        guard let path = recordArchiveURL?.path else { return false }
        
        return NSKeyedArchiver.archiveRootObject(records, toFile: path)
    }
}
