//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by 임성훈 on 2017. 7. 30..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
    
    func update(with image: UIImage?) {
        guard let imageToDisplay = image else {
            spinner.startAnimating()
            imageView.image = nil
            return
        }
        
        spinner.stopAnimating()
        imageView.image = imageToDisplay
    }
}
