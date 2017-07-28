//
//  RecordViewController.swift
//  OneToTwentyFive
//
//  Created by 임성훈 on 2017. 7. 24..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
  
    var recordStore = RecordStore() {
        didSet {
            print("RV recordStore is Changed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        let aleartController = UIAlertController(title: "REALLY?", message: nil, preferredStyle: .alert)
        let noButton = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "YES", style: .destructive, handler: { _ in
            self.recordStore.records.removeAll()
            self.tableView.reloadData()
        })
        
        aleartController.addAction(noButton)
        aleartController.addAction(yesButton)
        
        present(aleartController, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        guard presentingViewController != nil else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension RecordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recordCell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)
        let record = recordStore.records[indexPath.row]
        
        recordCell.textLabel?.text = record.getClearTime()
        recordCell.detailTextLabel?.text = "\(record.getName()) (\(record.getClearDate())) "
        
        return recordCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordStore.records.count
    }
}

extension RecordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        recordStore.records.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
