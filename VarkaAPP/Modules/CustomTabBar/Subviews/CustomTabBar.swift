//
//  CustomTabBar.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit

final class CustomTabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    
    private func addShape(screenIsSquare: Bool) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = CGPath.createTabBarPath(frame: frame, screenIsSquare: screenIsSquare)
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.shadowRadius = 5
        shapeLayer.shadowOpacity = 0.2
        shapeLayer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
        
        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        addShape(screenIsSquare: DeviceManager.checkSquareScreen())
    }
}
