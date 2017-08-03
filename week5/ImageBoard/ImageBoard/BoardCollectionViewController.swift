//
//  BoardCollectionViewController.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 8. 1..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class BoardCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    fileprivate let boardDataSource: BoardDataSource = BoardDataSource()
    fileprivate let boardManager: BoardManager = BoardManager()
    private let refreshControl = UIRefreshControl()
    
    private var viewMode: ViewMode = .viewAllBoard
    
    override func viewDidLoad() {
        collectionView.dataSource = boardDataSource
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector (pullToRefresh), for: .valueChanged)
        
        setItemSize()
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
    
    func setItemSize() {
        guard let navigationBar = self.navigationController?.navigationBar else {
            return
        }
        
        let horizontalInset = flowLayout.minimumLineSpacing * 2
        let verticalInset = navigationBar.bounds.height
        
        flowLayout.itemSize.width = (collectionView.bounds.width / 2) - horizontalInset
        flowLayout.itemSize.height = (collectionView.bounds.height / 2) - verticalInset
    }
    
    func pullToRefresh() {
        fetchAllBoard() {
            if self.viewMode == .viewMyBoard {
                self.boardDataSource.setMyBoard()
            }
            
            self.refreshControl.endRefreshing()
        }
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
            
            self.collectionView.reloadSections(IndexSet(integer: 0))
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
    
    func addBoard() {
        performSegue(withIdentifier: "ModalBoardAdd", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowBoardDetail" else { return }
        
        guard let boardDetailViewController = segue.destination
            as? BoardDetailViewController else { return }
        
        guard let selectedIndexPath = self.collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        
        let board = boardDataSource.boards[selectedIndexPath.item]
        
        boardDetailViewController.board = board
    }
}

extension BoardCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let board = boardDataSource.boards[indexPath.item]
        
        boardManager.fetchImage(fromURLString: board.thumbImageURL, for: board) {
            [unowned self] imageResult in
            guard let boardIndex = self.boardDataSource.boards.index(of: board),
                case let .success(thumbImage) = imageResult else { return }
            
            let imageIndexPath = IndexPath(row: boardIndex, section: 0)
            
            guard let cell = collectionView.cellForItem(at: imageIndexPath)
                as? BoardCollectionViewCell else { return }
            
            cell.update(thumbImage: thumbImage)
        }
    }
}
