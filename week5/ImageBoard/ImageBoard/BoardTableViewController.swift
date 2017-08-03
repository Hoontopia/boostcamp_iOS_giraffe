//
//  BoardTableViewController.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 7. 31..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

enum ViewMode {
    case viewMyBoard
    case viewAllBoard
}

struct ActionSheetTitle{
    static let sort: String = "정렬"
    static let viewMyBoard: String = "내 게시물만 보기"
    static let viewAllBoard: String = "전체 게시물 보기"
    static let cancel: String = "취소"
}

class BoardTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let boardDataSource: BoardDataSource = BoardDataSource()
    fileprivate let boardManager: BoardManager = BoardManager()
    private let refreshControl = UIRefreshControl()
    
    private var viewMode: ViewMode = .viewAllBoard
    
    override func viewDidLoad() {
        tableView.dataSource = boardDataSource
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector (pullToRefresh), for: .valueChanged)
        
        setBarButton()
        fetchAllBoard(completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.refreshControl.endRefreshing()
    }
    
    func setBarButton() {
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addBoard))
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector (setViewMode))
    }
    
    func fetchAllBoard(completion: (() -> Void)?) {
        boardManager.fetchAllBoard { [unowned self] boardResult in
            switch boardResult {
            case .success(let boards):
                print("Successfully found \(boards.count) boards.")
                self.boardDataSource.boards = boards
            case .failure(let error):
                print("Error fetching boards: \(error)")
                self.boardDataSource.boards.removeAll()
            }
            
            if let completion = completion {
                completion()
            }
            
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    func setViewMode() {
        let actionSheet = UIAlertController(title: ActionSheetTitle.sort, message: nil,
                                            preferredStyle: .actionSheet)
        let viewMyBoard = UIAlertAction(title: ActionSheetTitle.viewMyBoard, style: .default) {
            [unowned self] _ in
            self.fetchAllBoard {
                self.boardDataSource.setMyBoard()
            }
            
            self.viewMode = .viewMyBoard
        }
        
        let viewAllBoard = UIAlertAction(title: ActionSheetTitle.viewAllBoard, style: .default) {
            [unowned self] _ in
            self.fetchAllBoard(completion: nil)
            
            self.viewMode = .viewAllBoard
        }
        
        let cancel = UIAlertAction(title: ActionSheetTitle.cancel,
                                   style: .cancel, handler: nil)
        
        actionSheet.addAction(viewMyBoard)
        actionSheet.addAction(viewAllBoard)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func pullToRefresh() {
        fetchAllBoard() {
            if self.viewMode == .viewMyBoard {
                self.boardDataSource.setMyBoard()
            }
            
            self.refreshControl.endRefreshing()
        }
    }
    
    func addBoard() {
        performSegue(withIdentifier: "ModalBoardAdd", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowBoardDetail" else { return }
        
        guard let boardDetailViewController = segue.destination
            as? BoardDetailViewController else { return }
        
        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        
        let board = boardDataSource.boards[selectedIndexPath.row]
        
        boardDetailViewController.board = board
    }
}

extension BoardTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let board = boardDataSource.boards[indexPath.row]
        
        boardManager.fetchImage(fromURLString: board.thumbImageURL, for: board) {
            [unowned self] imageResult in
            guard let boardIndex = self.boardDataSource.boards.index(of: board),
                case let .success(thumbImage) = imageResult else { return }
            
            let imageIndexPath = IndexPath(row: boardIndex, section: 0)
            
            guard let cell = tableView.cellForRow(at: imageIndexPath)
                as? BoardTableViewCell else { return }
            
            cell.update(thumbImage: thumbImage)
        }
    }
}
