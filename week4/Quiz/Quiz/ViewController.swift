//
//  ViewController.swift
//  Quiz
//
//  Created by 임성훈 on 2017. 7. 1..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var currentQuestionLabel: UILabel!
    @IBOutlet var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
    
    var currentQuestionIndex: Int = 0
    
    let questions: [String] = ["From what is cognac made?",
                               "What is 7+7?",
                               "What is the capital of Vermont?"]
    let answers: [String] = ["Grapes",
                            "14",
                            "Montpelier"]

    override func viewDidLoad() {
        super.viewDidLoad()

        let question = questions[currentQuestionIndex]
        currentQuestionLabel.text = question
        
        updateOffScreenLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nextQuestionLabel.alpha = 0
    }
    
    func updateOffScreenLabel() {
        let screenWidth = view.frame.width
        nextQuestionLabelCenterXConstraint.constant = -screenWidth
    }
    
    func animateLabelTransitions() {
        view.layoutIfNeeded() // 안넣으면 모든 라벨의 너비가 애니메이션
        
        let screenWidth = view.frame.width
        self.nextQuestionLabelCenterXConstraint.constant = 0
        self.currentQuestionLabelCenterXConstraint.constant += screenWidth
        
//        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear], animations: {
//            self.currentQuestionLabel.alpha = 0
//            self.nextQuestionLabel.alpha = 1
//            
//            self.view.layoutIfNeeded()
//        }, completion: { _ in
//            swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
//            swap(&self.currentQuestionLabelCenterXConstraint,
//                 &self.nextQuestionLabelCenterXConstraint)
//            
//            self.updateOffScreenLabel()
//        })
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3,
           initialSpringVelocity: 1.0, options: [],
           animations: {
            self.currentQuestionLabel.alpha = 0
            self.nextQuestionLabel.alpha = 1

            self.view.layoutIfNeeded()
            }, completion: { _ in
                swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
                swap(&self.currentQuestionLabelCenterXConstraint,
                     &self.nextQuestionLabelCenterXConstraint)
                
                self.updateOffScreenLabel()
            }
        )
    }
    
    @IBAction func showNextQuestion(sender: AnyObject) {
        currentQuestionIndex = (currentQuestionIndex + 1) % questions.count
        
        let question: String = questions[currentQuestionIndex]
        
        nextQuestionLabel.text = question
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    @IBAction func showAnswer(sender: AnyObject) {
        let answer: String = answers[currentQuestionIndex]
        
        answerLabel.text = answer
    }
}

