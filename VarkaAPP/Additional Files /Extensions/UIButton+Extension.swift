//
//  UIButton+Extension.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 06.03.2021.
//

import UIKit

extension UIButton {
    
    func animationForCentralButton() {
        let rotation = CASpringAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 4)
        rotation.duration = 6
        rotation.mass = 1
        layer.add(rotation, forKey: nil)
    }
}
