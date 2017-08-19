//
//  ViewController.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 7. 30..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private struct AlertControllerTitle{
        static let warning: String = "알림"
        static let okay: String = "확인"
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private let loginManager: LoginManager = LoginManager()
    
    private lazy var failAlertController: UIAlertController = {
        let failAlertController = UIAlertController(title: AlertControllerTitle.warning,
                                                    message: "", preferredStyle: .alert)
        
        failAlertController.addAction(UIAlertAction(title: AlertControllerTitle.okay,
                                                    style: .cancel, handler: nil))
        
        return failAlertController
    }()

    @IBAction func signIn(_ sender: UIButton) {
        guard let email = emailField.text,
            let password = passwordField.text else {
            return
        }
        
        guard !email.isEmpty && !password.isEmpty else { return }

        loginManager.signIn(with: email, password: password) { [unowned self] loginResult in
            switch loginResult {
            case .success:
                self.performSegue(withIdentifier: "ShowTabBarController", sender: self)
            case .failure(let error):
                self.failAlertController.message = "Code: \(error)"
                self.present(self.failAlertController, animated: true, completion: nil)
            }
        }
    }
}

