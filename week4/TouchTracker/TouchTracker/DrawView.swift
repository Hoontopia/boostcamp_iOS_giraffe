//
//  DrawView.swift
//  TouchTracker
//
//  Created by 임성훈 on 2017. 7. 12..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class DrawView: UIView {
    // var currentLine: Line?
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // 선 그리기
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = CGLineCap.round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        // 완성된 선 검은색
        for line in finishedLines {
            let radian = atan2(-(line.end.y - line.begin.y), line.end.x - line.begin.x)
            let degree = radian * 180 / CGFloat.pi
            
            if degree > 90 {
                UIColor.blue.setStroke()
            } else {
                UIColor.black.setStroke()
            }
            
            strokeLine(line: line)
        }
        // 그리는 선 빨간색
        /*
        if let line = currentLine {
            UIColor.red.setStroke()
            strokeLine(line: line)
        } */
        
        UIColor.red.setStroke()
        for (_, line) in currentLines {
            strokeLine(line: line)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // let touch = touches.first!
        // 터치의 위치를 받는다.
        // let location = touch.location(in: self)
        // currentLine = Line(begin: location, end: location)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        // 뷰를 다시 그리도록 호출
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        let touch = touches.first!
        let location = touch.location(in: self)
        currentLine?.end = location
        */
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 현재 선택된 라인 가져오기
        /*
        if var line = currentLine {
            let touch = touches.first!
            let location = touch.location(in: self)
            line.end = location
            
            finishedLines.append(line)
        }
        currentLine = nil
        */
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
}
