//
//  BoardDetailViewController.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 8. 1..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class CreateBoardViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleField: UITextField!
    
    let boardManager: BoardManager = BoardManager()

    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func createBoard(_ sender: UIBarButtonItem) {
        guard let title = titleField.text,
            let image = imageView.image else { return }
        
        boardManager.createBoard(withTitle: title,
            description: descriptionTextView.text, image: image) {
            boardEditResult in
                switch boardEditResult {
                case .success(_):
                    print("Success")
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    @IBAction func cancelBoardCreation(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateBoardViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = editedImage
        } else if let orginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = orginalImage
        } else {
            print ("error")
        }
        
        dismiss(animated: true, completion: nil)
    }
}
