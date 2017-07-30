//
//  ViewController.swift
//  Photorama
//
//  Created by 임성훈 on 2017. 7. 29..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let photoDataSource = PhotoDataSource()
    
    var photoStore: PhotoStore = PhotoStore() {
        didSet {
            print("photoStore is changed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.dataSource = photoDataSource
        flowLayout.itemSize = CGSize(width: collectionView.bounds.width,
                                     height: collectionView.bounds.height)
        
        photoStore.fetchRecentPhotos() { [unowned self] (photoResult) in
            DispatchQueue.global().async {
                switch photoResult {
                case let .success(photos):
                    print("Successfully found \(photos.count) recent photos.")
                    self.photoDataSource.photos = photos
                case let .failure(error):
                    print("Error fetching recent photos: \(error)")
                    self.photoDataSource.photos.removeAll()
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowPhoto" else { return }
        
        guard let photoInfoViewController = segue.destination
            as? PhotoInfoViewController else { return }
        
        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        
        let photo = photoDataSource.photos[selectedIndexPath.row]
        
        photoInfoViewController.photo = photo
        photoInfoViewController.photoStore = photoStore
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        photoStore.fetchImage(for: photo) { [unowned self] (result) in
            guard let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result else { return }
            
            let photoIndexPath = IndexPath(row: photoIndex, section: 0)
            
            guard let cell = collectionView.cellForItem(at: photoIndexPath)
                as? PhotoCollectionViewCell else { return }
            
            cell.update(with: image)
        }
    }
}

