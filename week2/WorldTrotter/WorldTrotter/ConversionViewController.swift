//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by 임성훈 on 2017. 7. 1..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
    }
    
    /// 사용자가 숫자를 입력하지 않을 수도 있으므로 옵셔널로 선언
    var fahrenheitValue: Double? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5/9)
        }
        else {
            return nil
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }()
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    @IBAction func fahrenheitFieldEditingChanged(textField: UITextField) {
        /// celsiusLabel.text = textField.text
        /*
        if let text = textField.text, !text.isEmpty {
            celsiusLabel.text = text
        }
        else {
            celsiusLabel.text = "???"
        } */
        
        /// 텍스트에 내용이 있는지, 값이 Double로 변환 가능한지
        if let fahrenheitFromText = textField.text,
            let fahrenheitValue = Double(fahrenheitFromText) {
            self.fahrenheitValue = fahrenheitValue
        }
        else {
            self.fahrenheitValue = nil
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /*
        print("Current text: \(textField.text)")
        print("Replacement text: \(string)") */
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        let letters = NSCharacterSet.letters
        let replacementTextHasAlphabet = string.rangeOfCharacter(from: letters)
        
        /// 현재 텍스트에 '.'이 있고 새로운 문자열에 '.'이 있을 경우 또는 새로운 문자열이 알파벳인 경우 입력 하지 않음!
        if (existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil)
            || replacementTextHasAlphabet != nil {
            return false
        }
        else {
            return true
        }
    }
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
           /// celsiusLabel.text = "\(value)"
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue))
        }
        else {
            celsiusLabel.text = "???"
        }
    }
}
