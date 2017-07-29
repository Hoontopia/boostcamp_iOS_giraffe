//
//  ImageStore.swift
//  Homepwner
//
//  Created by 임성훈 on 2017. 7. 29..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
    private let cache = NSCache<NSString, UIImage>()

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
        
        guard let imageURL = imageURLFor(key: key) else { return }
        guard let data = UIImagePNGRepresentation(image) else { return }
        
        do {
            try data.write(to: imageURL, options: .atomic)
        } catch let writeError{
            print(writeError)
        }
    }
    
    func imageFor(key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: NSString(string: key)) {
            return existingImage
        }

        guard let imageURL = imageURLFor(key: key),
            let imageFromDisk = UIImage(contentsOfFile: imageURL.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: NSString(string: key))
        return imageFromDisk
    }
    
    func deleteImageFor(key: String) {
        cache.removeObject(forKey: NSString(string: key))
        
        guard let imageURL = imageURLFor(key: key) else { return }
        
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch let deleteError {
            print(deleteError)
        }
    }
    
    func imageURLFor(key: String) -> URL? {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let documentDirectory = documentDirectories.first else { return nil }
        
        return documentDirectory.appendingPathComponent(key)
    }
}
