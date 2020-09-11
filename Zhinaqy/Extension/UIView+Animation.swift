//
//  UIView+Animation.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/11/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


extension UIView {
    
    func keyboardAnimation(completion: (() -> Void)?) {
        UIViewPropertyAnimator(duration: TimeInterval(0.5), curve: UIView.AnimationCurve(rawValue: UIView.AnimationCurve.RawValue(7.0))!, animations: completion).startAnimation()
    }
    
    func performTransition(_ type: CATransitionSubtype) {
        
        let transition = CATransition()
        transition.startProgress = 0.0
        transition.endProgress = 1.0
        transition.type = .push
        transition.subtype = type
        transition.duration = 0.5

        self.layer.add(transition, forKey: nil)
    }
}
