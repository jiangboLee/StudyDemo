//
//  Touch3dButton.swift
//  Touch3dButton
//
//  Created by ljb48229 on 2018/2/27.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

enum ConfirmActionButtonState {
    case idle
    case updating
    case selected
    case confirmed
}

class Touch3dButton: UIButton {
    
    private let updateingColoe = UIColor.lightGray.cgColor
    private let selectedColoe = UIColor.white.cgColor
    private let confirmedColoe = UIColor.green.cgColor
    
    private let circle = CAShapeLayer()
    private let msgLabel = CATextLayer()
    private let container = CALayer()
    
    private var waitingInterval: TimeInterval = 1.0
    private var timer: Timer? = nil
    private var lastTouchPosition = UITouch()
    private var intention: CGFloat = 0.0
    
    private var selectionState: ConfirmActionButtonState = .idle {
        didSet{
            switch self.selectionState {
            case .idle, .updating:
                if oldValue != .updating || oldValue != .idle {
                    circle.strokeColor = updateingColoe
                    circle.shadowColor = updateingColoe
                    circle.transform = CATransform3DIdentity
                    msgLabel.string = ""
                }
                
            case .selected:
                if oldValue != .selected{
                    circle.strokeColor = selectedColoe
                    circle.shadowColor = selectedColoe
                    circle.transform = CATransform3DMakeScale(1.1, 1.1, 1)
                    msgLabel.string = "sure?"
                }
                
            case .confirmed:
                if oldValue != .confirmed{
                    circle.strokeColor = confirmedColoe
                    circle.shadowColor = confirmedColoe
                    circle.transform = CATransform3DMakeScale(1.2, 1.2, 1)
                    msgLabel.string = "ok"
                }
            }
            circle.setNeedsLayout()
        }
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        drawControl()
    }
    
    private func drawControl() {
        
        var transform = CGAffineTransform.identity
        circle.frame = CGRect(x: 0, y: 0, width: bounds.size.height, height: bounds.size.height)
        circle.path = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: bounds.size.height, height: bounds.size.height), transform: &transform)
        circle.strokeColor = updateingColoe
        circle.fillColor = UIColor.clear.cgColor
        circle.lineWidth = 2
        circle.lineCap = kCALineCapRound
        circle.strokeEnd = 0
        circle.shadowColor = updateingColoe
        circle.shadowRadius = 2.0
        circle.shadowOpacity = 1.0
        circle.shadowOffset = CGSize.zero
        circle.contentsScale = UIScreen.main.scale
        // Label
        msgLabel.font = UIFont.systemFont(ofSize: 3.0)
        msgLabel.fontSize = 12
        msgLabel.foregroundColor = UIColor.red.cgColor
        msgLabel.string = ""
        msgLabel.alignmentMode = "center"
        msgLabel.frame = CGRect(x: 0, y: (bounds.size.height / 2) - 8.0, width: bounds.size.height, height: 12)
        msgLabel.contentsScale = UIScreen.main.scale
        // Put it all together
        container.frame = CGRect(x: 0, y: 0, width: bounds.size.height, height: bounds.size.height)
        container.addSublayer(msgLabel)
        container.addSublayer(circle)
        layer.addSublayer(container)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        if traitCollection.forceTouchCapability != .available {
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(Touch3dButton.updateTimedIntention),
                                         userInfo: nil,
                                         repeats: true)
            timer?.fire()
        }
        
        let initialLocation = touch.location(in: self)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        container.position = initialLocation ++ CGPoint(x: 0, y: -bounds.size.height)
        CATransaction.commit()
        
        return true
    }
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        lastTouchPosition = touch
        updateSelection(with:touch)
        return true
    }
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        timer?.invalidate()
        intention = 0
        
        if selectionState == .confirmed {
            self.sendActions(for: UIControlEvents.valueChanged)
        }
        
        selectionState = .idle
        circle.strokeEnd = 0
    }
    private func updateSelection(with touch: UITouch) {
        
        if traitCollection.forceTouchCapability == .available{
            intention = 1.0 * (min(touch.force, 3.0) / min(touch.maximumPossibleForce, 3.0))
            print(intention)
        }

        if intention > 0.97 {
            if container.frame.contains(touch.location(in:self)){
                selectionState = .confirmed
            }else{
                selectionState = .selected
            }
            updateUI(with: 1.0)
        } else {
            if !container.frame.contains(touch.location(in:self)){
                selectionState = .updating
                updateUI(with: intention)
            }
        }
    }
    
    
    //更新圈圈
    private func updateUI(with value:CGFloat){
        circle.strokeEnd = value
    }
    
    @objc func updateTimedIntention(){
        intention += CGFloat(0.1 / waitingInterval)
        updateSelection(with: lastTouchPosition)
    }
}

///自定义操作符
infix operator ++ : AdditionPrecedence
func ++ (left: CGPoint, right: CGPoint) -> CGPoint {
    let res = CGPoint(x: left.x + right.x, y: left.y + right.y)
    return res
}







