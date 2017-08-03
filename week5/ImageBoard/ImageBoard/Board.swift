//
//  Board.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 7. 31..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class Board {
    let boardID: String
    let imageTitle: String
    let imageURL: String
    let thumbImageURL: String
    let writerID: String
    let writerNickName: String
    let imageDescription: String
    let dateCreated: Int
    var image: UIImage?
    var thumbImage: UIImage?
    
    init(boardID: String, imageTitle: String, imageURL: String, thumbImageURL: String,
         writerID: String, writerNickName: String, imageDescription: String, dateCreated: Int) {
        self.boardID = boardID
        self.imageTitle = imageTitle
        self.imageURL = imageURL
        self.thumbImageURL = thumbImageURL
        self.writerID = writerID
        self.writerNickName = writerNickName
        self.imageDescription = imageDescription
        self.dateCreated = dateCreated
    }
}

extension Board: Equatable {
    static func == (lhs: Board, rhs: Board) -> Bool {
        return lhs.boardID == rhs.boardID
    }
}
