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
        middleButton.backgroundColor = .white
        middleButton.layer.borderColor = UIColor.white.cgColor
        middleButton.layer.borderWidth = 1
        middleButton.layer.cornerRadius = middleButton.frame.width / 2
        
        //shadow
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        middleButton.layer.shadowRadius = 5
        middleButton.layer.shadowColor = UIColor.gray.cgColor
        middleButton.layer.shadowOpacity = 0.5
        
//        middleButton.clipsToBounds = true
        middleButton.tintColor = VarkaColors.mainColor
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        middleButton.setImage(UIImage(systemName: ImageTitles.tabBarMiddleButton), for: .normal)
        middleButton.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 35, weight: .thin), forImageIn: .normal
        )
        
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
