//
//  SignUpViewController.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 7. 31..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    private struct AlertControllerTitle{
        static let warning: String = "확인"
    }
    
    private struct AlertControllerMessage{
        static let doFillAllSection: String = "모든 항목을 입력해주세요"
        static let doMatchPassword: String = "암호와 암호 확인이\n일치하지 않습니다"
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCheckField: UITextField!
    
    let loginManager: LoginManager = LoginManager()

    @IBAction func signUp(_ sender: UIButton) {
        guard let email = emailField.text,
            let nickName = nickNameField.text,
            let password = passwordField.text,
            let checkPassword = passwordCheckField.text else { return }
        
        let alertController: UIAlertController = UIAlertController(
            title: nil, message: nil, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: AlertControllerTitle.warning,
                                                style: .default, handler: nil))
        
        guard !email.isEmpty && !nickName.isEmpty
            && !password.isEmpty && !checkPassword.isEmpty else {
                alertController.message = AlertControllerMessage.doFillAllSection
                
                present(alertController, animated: true, completion: nil)
                return
        }
        
        guard password == checkPassword else {
            alertController.message = AlertControllerMessage.doMatchPassword
            
            present(alertController, animated: true, completion: nil)
            return
        }
        
        loginManager.signUp(with: email, password: password, nickName: nickName) { [unowned self] loginResult in
            switch loginResult {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                alertController.title = AlertControllerTitle.warning
                alertController.message = "Code: \(error)"
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
