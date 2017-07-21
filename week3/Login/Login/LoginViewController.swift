//
//  ViewController.swift
//  Login
//
//  Created by 임성훈 on 2017. 6. 30..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    /// A Text field containing id
    @IBOutlet weak var idField: UITextField!
    /// A Text field containing password
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var myButton: MyButton!
    @IBOutlet weak var controlButtonForMyButton: UIButton!
    
    override func viewDidLoad() {
        /*
        // 인터페이스 빌더로
        idField.delegate = self
        passwordField.delegate = self
        */
        myButton.addTarget(self, action: #selector(touchMyButton), for: .touchUpInside)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func controlMyButton(_ sender: UIButton) {
        if myButton.isEnabled {
            myButton.disable()
            sender.setTitle("Enable the button", for: .normal)
        } else {
            myButton.enable()
            sender.setTitle("Disable the button", for: .normal)
        }
    }
    
    /// Run when touching the Sign In button
    @IBAction func touchSignIn(sender: UIButton){
        print("touch up inside - sign in")
    
        // Return if none of the ID and password are entered
        // guard 구문을 다른 사람이 보기 좋도록..?

        guard let id = idField.text, let password = passwordField.text
        else { return }
        
        guard !id.isEmpty, !password.isEmpty
        else { return }
        
        // print("ID : " + id + ", " + "PW : " + password)
        // 문자열을 합치는 다른 방법?
        print("ID : \(id), PW : \(password)")
    }
    
    /// Run when touching the Sign Up button
    @IBAction func touchSignUp(sender: UIButton){
        print("touch up inside - sign up")
    }
    
    func touchMyButton() {
        print("touch up inside")
        myButton.isSelected = !myButton.isSelected
    }
}

