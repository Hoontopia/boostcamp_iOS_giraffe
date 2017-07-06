//
//  ViewController.swift
//  Quiz
//
//  Created by 임성훈 on 2017. 7. 1..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// Xcode에게 이 아웃렛이 인터페이스 빌더를 사용하여 라벨 객체와 연결한다는 것을 알린다.
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    let questions: [String] = ["From what is cognac made?",
                               "What is 7+7?",
                               "What is the capital of Vermont?"]
    let answers: [String] = ["Grapes",
                            "14",
                            "Montpelier"]
    var currentQuestionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
    }
    
    @IBAction func showNextQuestion(sender: AnyObject) {
        /*
        // ++currentQuestionIndex에서 문법 중 증감연산자 삭제로 인한 변경
        // 좀 더 간략하게 구현 해보려면?
         
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        
        // 삼항 연산자 사용
        let nextQuestionIndex = currentQuestionIndex + 1
        currentQuestionIndex = nextQuestionIndex != questions.count ? nextQuestionIndex : 0
        // 더 간략하게..?
        */
        
        // 나머지 연산자 사용
        currentQuestionIndex = (currentQuestionIndex + 1) % questions.count
        let question: String = questions[currentQuestionIndex]
        questionLabel.text = question
        answerLabel.text = "???"
    }
    
    @IBAction func showAnswer(sender: AnyObject) {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
}

