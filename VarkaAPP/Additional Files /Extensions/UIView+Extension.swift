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
}
