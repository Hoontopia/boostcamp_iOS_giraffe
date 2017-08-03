//
//  BoardDataSource.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 7. 31..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit



class BoardDataSource: NSObject {
    var boards = [Board]()
    fileprivate let identifier = "BoardCell"
    
    func setMyBoard() {
        let myBoards = boards.filter { (board) -> Bool in
            return board.writerID == UserInfo.userInfo?.identifier
        }
        
        boards = myBoards
    }
}

extension BoardDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            as? BoardTableViewCell ?? BoardTableViewCell()
        
        let board = boards[indexPath.row]
        let dateString = board.dateCreated.transformToDate().transformToString()
        
        cell.update(title: board.imageTitle, writer: board.writerNickName,
                    dateCreated: dateString)
        
        return cell
    }
}

extension BoardDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return boards.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: identifier,
                                                       for: indexPath)
            as? BoardCollectionViewCell ?? BoardCollectionViewCell()
        
        let board = boards[indexPath.item]
        let dateString = board.dateCreated.transformToDate().transformToString()
        
        cell.update(title: board.imageTitle, writer: board.writerNickName,
                    dateCreated: dateString)
        
        return cell
    }
}
