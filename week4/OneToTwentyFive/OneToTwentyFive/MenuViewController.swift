//
//  ViewController.swift
//  OneToTwentyFive
//
//  Created by 임성훈 on 2017. 7. 24..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    var recordStore = RecordStore() {
        didSet {
            print("MV recordStore is Changed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        labelAnimation()
    }
    
    func labelAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear, .autoreverse , .repeat],
            animations: {
                self.gameTitleLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { _ in
                self.gameTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showPlaySegue", sender: self)
    }
    
    @IBAction func showHistory(_ sender: UIButton) {
        performSegue(withIdentifier: "showHistorySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playViewController = segue.destination as? PlayViewController {
            playViewController.recordStore = recordStore
        } else if let recordViewController = segue.destination as? RecordViewController {
            recordViewController.recordStore = recordStore
        }
    }
}

