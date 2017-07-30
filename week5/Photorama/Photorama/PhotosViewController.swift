//
//  ViewController.swift
//  Photorama
//
//  Created by 임성훈 on 2017. 7. 29..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var photoStore: PhotoStore = PhotoStore() {
        didSet {
            print("photoStore is changed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        photoStore.fetchRecentPhotos() { (photoResult) -> Void in
            switch photoResult {
            case let .success(photos):
                print("Successfully found \(photos.count) recent photos.")
                guard let firstPhoto = photos.first else { return }
                
                self.photoStore.fetchImageFor(photo: firstPhoto) {
                    [unowned self] (imageResult) -> () in
                    
                    switch imageResult {
                    case let .success(image):
                        OperationQueue.main.addOperation {
                             self.imageView.image = image
                        }
                    case let .failure(error):
                        print("Error downloading image: \(error)")
                    }
                }
            case let .failure(error):
                print("Error fetching recent photos: \(error)")
            }
        }
    }
}

