//
//  middleButtonTabBar.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 18.03.2021.
//

import UIKit

extension UIButton {
    
    static func setupMiddleButtonTabBar() -> UIButton {
        let middleButton = UIButton()
        middleButton.backgroundColor = VarkaColors.mainColor
        middleButton.layer.cornerRadius = middleButton.frame.width / 2
        middleButton.layer.shadowRadius = 4
        middleButton.layer.shadowOpacity = 0.2
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        middleButton.tintColor = .white
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        middleButton.setImage(UIImage(systemName: ImageTitles.tabBarMiddleButton), for: .normal)
        middleButton.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 39, weight: .thin), forImageIn: .normal)
        middleButton.animationForMiddleButton()
        return middleButton
    }
    
    func animationForMiddleButton() {
        let rotation = CASpringAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 4)
        rotation.duration = 6
        rotation.mass = 1
        layer.add(rotation, forKey: nil)
    }
}
