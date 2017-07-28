//
//  DatePickerViewController.swift
//  Homepwner
//
//  Created by 임성훈 on 2017. 7. 24..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func applyDate(_ sender: UIBarButtonItem) {
        guard let count = self.navigationController?.viewControllers.count else { return }
        guard let detailViewController = self.navigationController?.viewControllers[count - 2]
            as? DetailViewController else { return }
        
        detailViewController.item.dateCreated = datePicker.date
        
        self.navigationController?.popViewController(animated: true)
    }
}
