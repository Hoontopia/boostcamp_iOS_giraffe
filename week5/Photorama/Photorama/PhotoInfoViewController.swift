//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by 임성훈 on 2017. 7. 30..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo? {
        didSet {
            print("Photo is changed")
            navigationItem.title = photo?.title
        }
    }
    
    var photoStore: PhotoStore = PhotoStore() {
        didSet {
            print("PhotoStore is changed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let photo = self.photo else { return }
        
        photoStore.fetchImage(for: photo) { (result) in
            switch result {
            case let .success(image):
                    self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
}
