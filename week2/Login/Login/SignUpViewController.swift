//
//  SignUpViewController.swift
//  Login
//
//  Created by 임성훈 on 2017. 7. 8..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
      //  profileImageView.image = #imageLiteral(resourceName: "giraff")
    }
    @IBAction func dissmissSignUpViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func touchSignIn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
