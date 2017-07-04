//
//  ViewController.swift
//  FoodTracker
//
//  Created by 임성훈 on 2017. 7. 1..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    @IBOutlet weak var mealNameLable: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
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
    
    // MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        mealNameLable.text = "Default Text"
    }

}

