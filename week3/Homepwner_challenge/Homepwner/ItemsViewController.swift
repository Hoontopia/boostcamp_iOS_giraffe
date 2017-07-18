//
//  TableViewController.swift
//  Homepwner
//
//  Created by 임성훈 on 2017. 7. 15..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

//enum FontSize: CGFloat {
//    case last = 17
//    case others = 20
//}
//
//enum CellHeight: CGFloat {
//    case last = 44
//    case others = 60
//}
// rawValue 쓰지 말기

struct FontSize {
    static let last: CGFloat = 17
    static let others: CGFloat = 20
}

struct CellHeight {
    static let last: CGFloat = 44
    static let others: CGFloat = 60
}

class ItemsViewController: UITableViewController {
    let indexTitle: [String] = ["More than $50", "Others"]
    
    // 50달러 이상과 이하로 나누어진 2차원 Item 배열
    var splitedItemStore: [[Item]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 상단 상태 바와 겹치지 않도록 컨텐트 인셋 추가
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        let backgroundImageView: UIImageView = UIImageView(frame: tableView.bounds)
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
        backgroundImageView.image = #imageLiteral(resourceName: "giraff")
        tableView.backgroundView = backgroundImageView
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return indexTitle.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard section == tableView.numberOfSections - 1 else {
            return splitedItemStore[section].count
        }
        
        return splitedItemStore[section].count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lastSection = tableView.numberOfSections - 1
        // tableView.numberOfRows(inSection:) 사용불가 (호출 전)
        let lastRow = splitedItemStore[lastSection].count - 1
        
        guard indexPath.section == lastSection && indexPath.row == (lastRow + 1) else {
            return CellHeight.others
        }
        
        return CellHeight.last
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        // 가용 셀 풀에서 재사용 가능한 셀을 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let lastSection = tableView.numberOfSections - 1
        let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
        
        // 마지막 섹션의 마지막 행일 경우 고정 텍스트 출력
        if indexPath.section == lastSection && indexPath.row == lastRow {
            cell.textLabel?.text = "No more items!"
            cell.detailTextLabel?.text = ""
        } else {
            let item = splitedItemStore[indexPath.section][indexPath.row]
//            let font = UIFont(name: (cell.textLabel?.font.fontName)!, size: FontSize.others)
            let font = UIFont.systemFont(ofSize: FontSize.others)
            
            cell.textLabel?.text = item.name
            cell.textLabel?.font = font
            cell.detailTextLabel?.text = "$\(item.valueInDollars)"
            cell.detailTextLabel?.font = font
        }
    
        cell.backgroundColor = UIColor.clear    // 배경 투명하게
        
        return cell
    }
    
}
