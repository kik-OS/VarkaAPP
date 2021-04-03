//
//  CGPath+Extension.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 12.03.2021.
//

import UIKit

//extension CGPath {
//
//    static func createTabBarPath(frame: CGRect ) -> CGPath {
//        let height: CGFloat = 37.0
//        let path = UIBezierPath()
//        let centerWidth = frame.width / 2
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
//
//        path.addCurve(to: CGPoint(x: centerWidth, y: height),
//                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0),
//                      controlPoint2: CGPoint(x: centerWidth - 35, y: height))
//
//        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
//                      controlPoint1: CGPoint(x: centerWidth + 35, y: height),
//                      controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
//
//        path.addLine(to: CGPoint(x: frame.width, y: 0))
//        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
//        path.addLine(to: CGPoint(x: 0, y: frame.height))
//        path.close()
//
//        return path.cgPath
//    }
//}


extension CGPath {
    
    static func createTabBarPath(frame: CGRect, screenIsSquare: Bool ) -> CGPath {


        let path = UIBezierPath()
        
        if screenIsSquare {
        
            let height: CGFloat = 37.0
            
            let centerWidth = frame.width / 2
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
    
            path.addCurve(to: CGPoint(x: centerWidth, y: height),
                          controlPoint1: CGPoint(x: (centerWidth - 30), y: 0),
                          controlPoint2: CGPoint(x: centerWidth - 35, y: height))
    
            path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                          controlPoint1: CGPoint(x: centerWidth + 35, y: height),
                          controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
    
            path.addLine(to: CGPoint(x: frame.width, y: 0))
            path.addLine(to: CGPoint(x: frame.width, y: frame.height))
            path.addLine(to: CGPoint(x: 0, y: frame.height))
            path.close()
        
        } else {
        
            let sideIndent: CGFloat = 15
            
            print(frame.width, frame.height)
            path.move(to: CGPoint(x: frame.width / 2, y: frame.height - sideIndent))
            
            path.addLine(to: CGPoint(x: 50, y: frame.height - sideIndent))
            
            path.addQuadCurve(to: CGPoint(x: sideIndent, y: frame.height - 50), controlPoint: CGPoint(x: sideIndent, y: frame.height - sideIndent))
            
            path.addLine(to: CGPoint(x: sideIndent, y: 10))
            
            path.addQuadCurve(to: CGPoint(x: sideIndent + 10, y: 0), controlPoint: CGPoint(x: sideIndent, y: 0))
            
            path.addLine(to: CGPoint(x: (frame.width / 2) - 55, y: 0))
            
            path.addQuadCurve(to: CGPoint(x: (frame.width / 2) - 44, y: 10), controlPoint: CGPoint(x: (frame.width / 2) - 44, y: 0))
            
       
            path.addArc(withCenter: CGPoint(x: frame.width / 2, y: 10),
                    radius: 44,
                    startAngle: CGFloat(Double.pi),
                    endAngle: CGFloat(0),
                    clockwise: false)
            

            path.addQuadCurve(to: CGPoint(x: (frame.width / 2) + 54, y: 0), controlPoint: CGPoint(x: (frame.width / 2) + 44, y: 0))
            
            
            path.addLine(to: CGPoint(x: frame.width - sideIndent - 10, y: 0))
            
            path.addQuadCurve(to: CGPoint(x: frame.width - sideIndent, y: 10), controlPoint: CGPoint(x: frame.width -  sideIndent, y: 0))
            
            path.addLine(to: CGPoint(x: frame.width -  sideIndent, y: frame.height - 50))
            
            path.addQuadCurve(to: CGPoint(x: frame.width - 50, y: frame.height - sideIndent), controlPoint: CGPoint(x: frame.width -  sideIndent, y: frame.height - sideIndent))
            
            path.close()
         
               
        }
        
        return path.cgPath
    }
}
