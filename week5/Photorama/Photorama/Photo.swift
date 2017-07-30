//
//  Photo.swift
//  Photorama
//
//  Created by 임성훈 on 2017. 7. 29..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class Photo {
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    var image: UIImage?
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}
