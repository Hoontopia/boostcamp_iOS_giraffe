//
//  ViewController.swift
//  Login
//
//  Created by 임성훈 on 2017. 6. 30..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// A Text field containing id
    @IBOutlet weak var idField: UITextField!
    /// A Text field containing password
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Run when touching the Sign In button
    @IBAction func touchSignIn(sender: UIButton){
        print("touch up inside - sign in")
        
        /// Return if none of the ID and password are entered
        guard let id: String = idField.text, let password: String = passwordField.text, idField.hasText, passwordField.hasText else {
            
            return
        }
        
        print("ID : " + id + ", " + "PW : " + password)
    }
    
    /// Run when touching the Sign Up button
    @IBAction func touchSignUp(sender: UIButton){
        print("touch up inside - sign up")
    }
}

