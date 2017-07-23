//
//  TableViewController.swift
//  Homepwner
//
//  Created by 임성훈 on 2017. 7. 15..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 상단 상태 바와 겹치지 않도록 컨텐트 인셋 추가
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        // tableView.rowHeight = 65
        tableView.rowHeight = UITableViewAutomaticDimension
        // 각 셀에 높이를 물어보는 대신 스크롤을 시작할 때까지 미룸
        tableView.estimatedRowHeight = 65
    }
    
    @IBAction func addNewItem(sender: UIButton) {
//        let lastRow = tableView.numberOfRows(inSection: 0)
//        let indexPath = IndexPath(row: lastRow, section: 0)
//        
//        tableView.insertRows(at: [indexPath], with: .automatic)
//        데이터 소스에서 반환한 행과 테이블 뷰의 행 수 불일치
        
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.index(where: { $0 === newItem }) {
            let indexPath = IndexPath(row: index, section: 0)
            
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(sender: UIButton) {
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView,
                            titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let item = itemStore.allItems[indexPath.row]
        
        let title = "Delete \(item.name)?"
        let message = "Are you sure you want to delete this item?"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.itemStore.removeItem(item)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    
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
    
    /* 목적지로의 행 이동을 막는 메소드 */
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard proposedDestinationIndexPath.row != tableView.numberOfRows(inSection: 0) - 1
            else { return sourceIndexPath }
        
        return proposedDestinationIndexPath
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemStore.allItems.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // 가용 셀 풀에서 재사용 가능한 셀을 가져옴
        // let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        // let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        // 옵셔널 강제 추출 제거
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            as? ItemCell ?? ItemCell(style: .default, reuseIdentifier: "ItemCell")
        
        let lastRow = tableView.numberOfRows(inSection: 0) - 1
        
        cell.updateLabels()
        
        // 마지막 섹션의 마지막 행일 경우 고정 텍스트 출력
        if indexPath.row == lastRow {
            // cell.textLabel?.text = "No more items!"
            // cell.detailTextLabel?.text = ""
            cell.nameLabel.text = "No more items!"
            cell.serialNumberLabel.text = ""
            cell.valueLabel.text = ""
        } else {
            let item = itemStore.allItems[indexPath.row]
            
            // cell.textLabel?.text = item.name
            // cell.detailTextLabel?.text = "$\(item.valueInDollars)"
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            cell.setCellColor(with: item.valueInDollars)
        }
        
        return cell
    }
}
