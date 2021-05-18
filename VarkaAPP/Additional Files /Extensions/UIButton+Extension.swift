//
//  UIButton+Extension.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 18.05.2021.
//


import UIKit

extension UIButton {
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.fromValue = 0.98
        pulse.toValue = 1
        pulse.duration = 0.9
        pulse.autoreverses = true
        pulse.repeatCount = 999999
        pulse.initialVelocity = 0.5
        pulse.damping = 0.5
        layer.add(pulse, forKey: nil)
    }
    
   
}
