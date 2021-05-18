//
//  UIView+Extension.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 28.03.2021.
//

import UIKit

extension UIView {
    
    func appear(fromValue: CGFloat = 0, toValue: CGFloat = 1,
                duration: Double = 0.5, completion: @escaping (() -> Void) = {}) {
        isHidden = false
        alpha = fromValue
        UIView.animate(withDuration: duration) {
            self.alpha = toValue
        } completion: { isEnded in
            if isEnded {
                self.alpha = toValue
                completion()
            }
        }
    }
    
    func disappear(fromValue: CGFloat = 1, toValue: CGFloat = 0,
                   duration: Double = 0.5, completion: @escaping (() -> Void) = {}) {
        alpha = fromValue
        UIView.animate(withDuration: duration) {
            self.alpha = toValue
        } completion: { isEnded in
            if isEnded {
                self.alpha = toValue
                self.isHidden = true
                completion()
            }
        }
    }
    
    func shakeView(vw: UIView) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.duration = 0.5
        animation.isAdditive = true

        vw.layer.add(animation, forKey: "shake")
    }
}
