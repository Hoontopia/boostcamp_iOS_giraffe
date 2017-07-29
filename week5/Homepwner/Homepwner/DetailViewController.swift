//
//  DetailViewController.swift
//  Homepwner
//
//  Created by 임성훈 on 2017. 7. 24..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var serialTextField: CustomTextField!
    @IBOutlet weak var valueTextField: CustomTextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var item: Item = Item() {
        didSet {
            print("Item is changed")
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore = ImageStore() {
        didSet {
            print("Item Store is changed")
        }
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        item.name = nameTextField.text ?? ""
        item.serialNumber = serialTextField.text
        
        if let valueText = valueTextField.text,
            let value = numberFormatter.number(from: valueText) as? Int {
            item.valueInDollars = value
        } else {
            item.valueInDollars = 0
        }
        
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        nameTextField.text = item.name
        serialTextField.text = item.serialNumber
        valueTextField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        let key = item.itemKey
        let imageToDisplay = imageStore.imageFor(key: key)
        
        imageView.image = imageToDisplay
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let datePickerVC = segue.destination as? DatePickerViewController else {
            return
        }
        
        datePickerVC.delegate = self
    }
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DetailViewController: DatePickable {
    func pickedDate(_ date: Date) {
        item.dateCreated = date
    }
}

extension DetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        imageStore.setImage(image, forKey: item.itemKey)
        imageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
}
