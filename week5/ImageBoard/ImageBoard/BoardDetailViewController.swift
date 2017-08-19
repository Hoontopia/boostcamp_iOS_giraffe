//
//  BoardDetailViewController.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 8. 1..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class BoardDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var writerField: UITextField!
    @IBOutlet weak var dateField: UITextField!

    lazy var titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.placeholder = "Image Title"
        titleTextField.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return titleTextField
    }()
    
    lazy var editButton: UIBarButtonItem = {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self,
                                         action: #selector (editBoard))
        return editButton
    }()
    
    lazy var removeButton: UIBarButtonItem = {
        let removeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self,
                                           action: #selector (removeBoard))
        return removeButton
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self, action: #selector (editCancel))
        return cancelButton
    }()
    
    lazy var doneButton: UIBarButtonItem = {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                         action: #selector (editDone))
        return doneButton
    }()
    
    var board: Board? {
        didSet {
            self.navigationItem.title = board?.imageTitle
        }
    }
    
    let boardManager: BoardManager = BoardManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultButtonItems()
        setLabel()
        fetchImage()
    }
    
    func setDefaultButtonItems() {
        guard let user = UserInfo.userInfo, let board = board else { return }
        guard board.writerID == user.identifier else { return }
        
        self.navigationItem.rightBarButtonItems = [removeButton, editButton]
    }
    
    func setEditButtonItems() {
        self.navigationItem.titleView = titleTextField
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func clearButtonItems() {
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.titleView = nil
    }
    
    func setLabel() {
        guard let board = self.board else { return }
        
        self.writerField.text = board.writerNickName
        self.descriptionTextView.text = board.imageDescription
        self.dateField.text = board.dateCreated.transformToDate().transformToString()
    }
    
    func fetchImage() {
        guard let board = self.board else { return }
        
        boardManager.fetchImage(fromURLString: board.imageURL, for: board) {
            [unowned self] imageResult in
            guard case let .success(image) = imageResult else { return }
            
            self.imageView.image = image
        }
    }
    
    func editBoard() {
        clearButtonItems()
        setEditButtonItems()
        descriptionTextView.isEditable = true
    }
    
    func editCancel() {
        clearButtonItems()
        setDefaultButtonItems()
        descriptionTextView.isEditable = false
    }
    
    func editDone() {
        clearButtonItems()
        setDefaultButtonItems()
        descriptionTextView.isEditable = false
    }
    
    func removeBoard() {
        guard let boardID = board?.boardID else { return }
        boardManager.deleteBoard(withBoardID: boardID) {
            [unowned self] boardEditResult in
            switch boardEditResult {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
}
