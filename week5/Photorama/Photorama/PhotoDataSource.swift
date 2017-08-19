//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by 임성훈 on 2017. 7. 30..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    var photos = [Photo]()
    private let identifier = "PhotoCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            as? PhotoCollectionViewCell ?? PhotoCollectionViewCell()
        
        let photo = photos[indexPath.row]
        cell.update(with: photo.image)
        
        return cell
    }
}
