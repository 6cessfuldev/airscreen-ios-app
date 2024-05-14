//
//  CountingLabel.swift
//  airscreen
//
//  Created by 육성민 on 4/23/24.
//

import UIKit

class CountingLabel: UILabel {
    
    let counterVelocity:Float = 3.0
    
    enum CounterAnimationType {
        case Linear
        case EaseIn
        case EaseOut
    }
    
    var startNumber: Float = 0
    var endNumber: Float = 0
    
    var progress: TimeInterval!
    var duration: TimeInterval!
    var lastUpdate: TimeInterval!
    
    var timer:Timer?
    
    var counterAnimationType: CounterAnimationType
    
    var currentCounterValue:Float {
        if progress >= duration {
            return endNumber
        }
        
        let percentage = Float(progress / duration)
        let update = updateCounter(counterValue: percentage)
        
        return startNumber + (update * (endNumber - startNumber))
    }
    
    override init(frame: CGRect) {
        self.counterAnimationType = .Linear
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.counterAnimationType = .Linear
        super.init(coder: aDecoder)
    }
    
    func count (fromValue:Float, to toValue:Float, withDuration duration:TimeInterval, andAnimationType animationType:CounterAnimationType) {
        
        self.startNumber = fromValue
        self.endNumber = toValue
        self.duration = duration
        self.counterAnimationType = animationType
        self.progress = 0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        
        invalidateTimer()
        
        if(duration == 0) {
            updateText(value: toValue)
            return
        }
        
        timer  = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(CountingLabel.updateValue), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateValue () {
        let now  = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        
        if progress >= duration {
            invalidateTimer()
            progress = duration
        }
        
        updateText(value: currentCounterValue)
    }
    
    func updateText (value:Float) {
        
        self.text = "\(Int(value))"
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateCounter (counterValue:Float) -> Float {
        switch counterAnimationType {
        case .Linear:
             return counterValue
        case .EaseIn:
            return powf(counterValue, 3)
        case .EaseOut:
            return 1.0 - powf(1.0 - counterValue, counterVelocity)
        }
    }
}


