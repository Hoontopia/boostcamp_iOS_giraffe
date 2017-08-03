//
//  BoardCollectionViewCell.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 8. 1..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class BoardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func update(title: String, writer: String, dateCreated: String) {
        titleLabel.text = title
        writerLabel.text = writer
        dateLabel.text = dateCreated
    }
    
    func update(thumbImage: UIImage) {
        thumbImageView.image = thumbImage
    }
}
