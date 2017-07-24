//
//  CustomTextField.swift
//  Homepwner
//
//  Created by 임성훈 on 2017. 7. 24..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        
        self.borderStyle = .bezel
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        
        self.borderStyle = .roundedRect
        return true
    }
}
