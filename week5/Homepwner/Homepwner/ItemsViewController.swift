//
//  TableViewController.swift
//  Homepwner
//
//  Created by 임성훈 on 2017. 7. 15..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore = ItemStore() {
        didSet {
            print("ItemStore is Changed")
        }
    }
    
    var imageStore: ImageStore = ImageStore() {
        didSet {
            print("ImageStore is changed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        // 각 셀에 높이를 물어보는 대신 스크롤을 시작할 때까지 미룸
        tableView.estimatedRowHeight = 65
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func addNewItem(sender: UIBarButtonItem) {
        
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.index(where: { $0 === newItem }) {
            let indexPath = IndexPath(row: index, section: 0)
            
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowItem" else { return }
        guard let detailViewController = segue.destination as? DetailViewController else { return }
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        
        let selectedItem = itemStore.allItems[row]
        detailViewController.item = selectedItem
        detailViewController.imageStore = imageStore
    }
}

// MARK: - Table view data source
extension ItemsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count + 1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.row != tableView.numberOfRows(inSection: 0) - 1 else { return false }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.row != tableView.numberOfRows(inSection: 0) - 1 else { return false }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            as? ItemCell ?? ItemCell(style: .default, reuseIdentifier: "ItemCell")
        
        let lastRow = tableView.numberOfRows(inSection: 0) - 1
        
        cell.updateLabels()
        
        if indexPath.row == lastRow {
            cell.nameLabel.text = "No more items!"
            cell.serialNumberLabel.text = ""
            cell.valueLabel.text = ""
        } else {
            let item = itemStore.allItems[indexPath.row]
            
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            cell.setCellColor(with: item.valueInDollars)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let item = itemStore.allItems[indexPath.row]
        
        let title = "Delete \(item.name)?"
        let message = "Are you sure you want to delete this item?"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            [unowned self] _ in
            self.itemStore.removeItem(item)
            self.imageStore.deleteImageFor(key: item.itemKey)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Table view delegate
extension ItemsViewController {
    override func tableView(_ tableView: UITableView,
                            titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard proposedDestinationIndexPath.row != tableView.numberOfRows(inSection: 0) - 1
            else { return sourceIndexPath }
        
        return proposedDestinationIndexPath
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard indexPath.row == (tableView.numberOfRows(inSection: 0) - 1) else {
            return indexPath
        }
        
        return nil
    }
}
