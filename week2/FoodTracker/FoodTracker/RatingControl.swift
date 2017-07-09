//
//  RatingControl.swift
//  FoodTracker
//
//  Created by 임성훈 on 2017. 7. 9..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    // 하위 클래스에서 이니셜라이저를 구현하면 더 이상 수퍼 클래스 이니셜라이저를 상속 하지 않음.
    // 그러나 required 키워드는 수퍼 클래스의 이니셜라이저를 구현하게 만들음.
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    //MARK: Private Methods
    private func setupButtons(){
        
        for button in ratingButtons {
            // 서브 뷰에서 버튼 삭제
            removeArrangedSubview(button)
            // 버튼도 서브 뷰에서 삭제
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // 버튼 이미지 로드
        // @IBDesignable이기 때문에 설정 코드도 Interface Builder에서 실행해야(명시적으	로 카탈로그의 번들을 지정해야함)
        let bundle = Bundle(for: type(of: self))
        let fieldStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            let button = UIButton()
            //버튼 이미지 설정
            button.setImage(emptyStar, for: .normal)
            button.setImage(fieldStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // 제약 조건 추가
            // 자동 생성 제약조건 비활성화
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // 버튼 액션 추가(Target-Action 패턴)
            // 타겟(self)는 현재 클래스의 인스턴스를 참조, #selector는 제공된 메소드의 값을 리턴
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)

            // 스택에 버튼 추가
            addArrangedSubview(button)
            
            // 버튼 배열에 추가
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
            
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
