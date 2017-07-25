//
//  PlayViewController.swift
//  OneToTwentyFive
//
//  Created by 임성훈 on 2017. 7. 24..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

struct GameStatus {
    static let maxNumber: Int = 25
    static let penaltyTime: Int = 150
}

class PlayViewController: UIViewController {

    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    private var timer: Timer?
    private var time: Int = 0
    
    var recordStore = RecordStore() {
        didSet {
            print("PV recordStore is Changed")
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-dd-MM HH:mm:ss"
        
        return formatter
    }()
    
    private var nextCheckNumber: Int = 1 {
        didSet {
            if oldValue == GameStatus.maxNumber {
                clearGame()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        distributeRandomNumbers(to: numberButtons)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBestRecord()
    }
    
    private func distributeRandomNumbers(to buttons: [UIButton]) {
        var numbers: [Int] = [Int](0 ..< GameStatus.maxNumber)
        
        for button in buttons {
            let randomNumber = Int(arc4random_uniform(UInt32(numbers.count)))
            button.setTitle(String(numbers[randomNumber] + 1), for: .normal)
            numbers.remove(at: randomNumber)
        }
    }
    
    @objc private func increaseTime() {
        time += 1
        
        let milliseconds = String(format: "%02d", time % 100)
        let seconds = String(format: "%02d", (time / 100) % 60)
        let minutes = String(format: "%02d", (time / 6000) % 100)
        
        timeLabel.text = "\(minutes):\(seconds):\(milliseconds)"
    }
    
    private func clearGame() {
        timer?.invalidate()
        historyButton.alpha = 1.0
        historyButton.isUserInteractionEnabled = true
        addGameRecord()
    }
    
    private func addGameRecord() {
        let aleartController = UIAlertController(title: "Clear!", message: "Enter your name", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let name = aleartController.textFields?.first?.text else { return }
            guard name != "" && !name.isEmpty else { return }
            guard let time = self.timeLabel.text else { return }
            
            let date = self.dateFormatter.string(from: Date())
            let newRecord: Record = Record(name: name, time: time, date: date)
            
            self.recordStore.addRecord(newRecord)
            self.setBestRecord()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        aleartController.addAction(cancelButton)
        aleartController.addAction(okButton)
        aleartController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter your name"
        })
        
        self.present(aleartController, animated: true, completion: nil)
    }
    
    func setBestRecord() {
        if let bestRecord = recordStore.getBestRecord() {
            recordLabel.text = "\(bestRecord.getName()) " + bestRecord.getClearTime()
        } else {
            recordLabel.text = "- --:--:--"
        }
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        sender.isHidden = true
        buttonStackView.isHidden = false
        historyButton.alpha = 0.3
        historyButton.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(increaseTime), userInfo: nil, repeats: true)
    }
    
    @IBAction func selectNumber(_ sender: UIButton) {
        guard let selectedButtonTitle: String = sender.title(for: .normal),
            let selectedNumber: Int = Int(selectedButtonTitle) else { return }
        
        guard selectedNumber == nextCheckNumber else {
            time += GameStatus.penaltyTime
            return
        }
        
        sender.backgroundColor = UIColor.white
        nextCheckNumber += 1
    }
    
    @IBAction func returnHome(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showHistory(_ sender: UIButton) {
        performSegue(withIdentifier: "modalHistorySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let recordViewController = segue.destination as? RecordViewController else {
            return
        }
        
        recordViewController.recordStore = recordStore
    }
}
