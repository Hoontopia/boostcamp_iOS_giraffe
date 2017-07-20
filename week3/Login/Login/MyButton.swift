//
//  MyButton.swift
//  Login
//
//  Created by 임성훈 on 2017. 7. 14..
//  Copyright © 2017년 임성훈. All rights reserved.
//


import UIKit

struct AlphaValue {
    static let normalState: CGFloat = 1.0
    static let otherState: CGFloat = 0.3
}

struct StateText {
    static let normal: String = "normal"
    static let selected: String = "selected"
    static let highlighted: String = "highlighted"
    static let selectedHighlighted: String = "selectedHighlighted"
}

class MyButton: UIView, UIGestureRecognizerDelegate {
    var backgroundImageView: UIImageView = UIImageView()
    var titleLable: UILabel = UILabel()
    var isSelected: Bool = false
    var isEnabled: Bool = true
    var backgroundImageColor: UIColor = UIColor.black
    var controlState: UIControlState = .normal {
        didSet {
            setTextStatusWith(controlState)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageView()
        setLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setImageView()
        setLabel()
        
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector (sigleTap(gestureRecognizer:)))
//        addGestureRecognizer(tapRecognizer)
    }
    
    func setImageView() {
        backgroundImageView.backgroundColor = backgroundImageColor
        self.addSubview(backgroundImageView) // 제약 조건 추가 시 공통 조상 문제 때문에 먼저 추가
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func setLabel() {
        self.addSubview(titleLable)
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLable.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLable.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLable.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLable.textAlignment = .center
        setTextStatusWith(controlState)
    }
    
    func enable() {
        self.alpha = AlphaValue.normalState
        self.isEnabled = true
        self.isUserInteractionEnabled = true
    }
    
    func disable() {
        self.alpha = AlphaValue.otherState
        self.isEnabled = false
        self.isUserInteractionEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = AlphaValue.otherState
        
        if isSelected {
            controlState = [.selected, .highlighted]
        } else {
            controlState = .highlighted
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        let touchLocation = touch.location(in: self)
        
        if self.bounds.contains(touchLocation) {
            sendActions(for: .touchUpInside)
        }
        
        self.alpha = AlphaValue.normalState
        
        if isSelected {
            controlState = .selected
        } else {
            controlState = .normal
        }
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        guard let target = target else { return }
        
        switch controlEvents {
        case UIControlEvents.touchUpInside:
            NotificationCenter.default.addObserver(target, selector: action, name: NSNotification.Name(rawValue: "touchUpInside"), object: self)
        default:
            print("매칭되는 이벤트 없음")
            return
        }
    }
    
    func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControlEvents) {
        guard let target = target else { return }
        
        switch controlEvents {
        case UIControlEvents.touchUpInside:
            NotificationCenter.default.removeObserver(target, name: NSNotification.Name(rawValue: "touchUpInside"), object: self)
        default:
            print("매칭되는 이벤트 없음")
            return
        }
    }
    
    func sendActions(for controlEvents: UIControlEvents) {
        switch controlEvents {
        case UIControlEvents.touchUpInside:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "touchUpInside"), object: self)
        default:
            print("매칭되는 이벤트 없음")
            return
        }
    }
    
    func setTextStatusWith(_ controlState: UIControlState) {
        switch controlState {
        case UIControlState.normal:
            titleLable.text = StateText.normal
            titleLable.textColor = UIColor.yellow
        case UIControlState.selected:
            titleLable.text = StateText.selected
            titleLable.textColor = UIColor.green
        case UIControlState.highlighted:
            titleLable.text = StateText.highlighted
            titleLable.textColor = UIColor.white
        case UIControlState([.selected, .highlighted]):
            titleLable.text = StateText.selectedHighlighted
            titleLable.textColor = UIColor.red
        default:
            break
        }
    }
    
//    func sigleTap(gestureRecognizer: UIGestureRecognizer) {
//        print("button tapped")
//    }
}
