//
//  DatePickerViewController.swift
//  Homepwner
//
//  Created by 임성훈 on 2017. 7. 24..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

protocol DatePickable {
    func pickedDate(_ date: Date)
}

class DatePickerViewController: UIViewController, DatePickable {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: DatePickable?
    
    @IBAction func applyDate(_ sender: UIBarButtonItem) {
        pickedDate(datePicker.date)
        self.navigationController?.popViewController(animated: true)
    }
    
    func pickedDate(_ date: Date) {
        delegate?.pickedDate(date)
    }
}
