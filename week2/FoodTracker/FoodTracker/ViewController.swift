//
//  ViewController.swift
//  FoodTracker
//
//  Created by 임성훈 on 2017. 7. 1..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var mealNameLable: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ViewController클래스 인스턴스를 텍스트 필드의 대리자로 할당
        nameTextField.delegate = self
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // FirstResponder 해제 이후 호출
    func textFieldDidEndEditing(_ textField: UITextField) {
        mealNameLable.text = textField.text
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 선택된 이미지 이미지 뷰에 삽입
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as?
            UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }

}

