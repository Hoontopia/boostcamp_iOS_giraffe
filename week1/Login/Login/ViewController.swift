//
//  ViewController.swift
//  Login
//
//  Created by 임성훈 on 2017. 6. 30..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    /// A Text field containing id
    @IBOutlet weak var idField: UITextField!
    /// A Text field containing password
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        idField.delegate = self
        passwordField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    /// Run when touching the Sign In button
    @IBAction func touchSignIn(sender: UIButton){
        print("touch up inside - sign in")
    
        // Return if none of the ID and password are entered
        // guard 구문을 다른 사람이 보기 좋도록..?

        guard let id = idField.text,
            let password = passwordField.text,
            !id.isEmpty,
            !password.isEmpty
            else { return }
        
        // print("ID : " + id + ", " + "PW : " + password)
        // 문자열을 합치는 다른 방법?
        
        print("ID : \(id), PW : \(password)")
    }
    
    /// Run when touching the Sign Up button
    @IBAction func touchSignUp(sender: UIButton){
        print("touch up inside - sign up")
    }
}

