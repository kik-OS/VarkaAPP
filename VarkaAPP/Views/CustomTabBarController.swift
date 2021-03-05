//
//  CustomTabBarController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit
import BarcodeScanner
class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    //    required init(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)!
    //    }
    
    
    var viewModel: CustomTabBarViewModelProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupMiddleButton()
        
    }
    
    func setupMiddleButton() {
        
        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-30, y: -30, width: 60, height: 60))
        
        
        middleBtn.setImage(UIImage(systemName: "barcode.viewfinder"), for: .normal)
        middleBtn.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .light), forImageIn: .normal)
        
        
        middleBtn.backgroundColor = .white
        middleBtn.layer.borderColor = UIColor.systemBlue.cgColor
        middleBtn.layer.borderWidth = 1
        middleBtn.layer.cornerRadius = 0.5 * middleBtn.bounds.size.width
        middleBtn.clipsToBounds = true
        
        
        
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.centerButtonAction), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    
    @objc func centerButtonAction(sender: UIButton) {
        BarCodeScanerManager.shared.openBarCodeScaner { vc in
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
    
    
    
    
    //    private func createRedButton() {
    //
    //        let imgRedButtonIcon = UIImageView(image: UIImage(systemName: "barcode.viewfinder", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)))
    //        let bumpHeight: CGFloat = 60
    //        let redButtonRadius: CGFloat = 30
    //        let redButton = UIButton()
    //
    //
    //        let tabBarHeight = UIScreen.main.bounds.size.height - self.tabBar.frame.minY
    //        imgRedButtonIcon.center = CGPoint(x: self.tabBar.frame.midX, y: (tabBarHeight - bumpHeight) / 2.0)
    //
    //
    //        let circle = CAShapeLayer()
    //        circle.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2 * redButtonRadius, height: 2 * redButtonRadius), cornerRadius: redButtonRadius).cgPath
    //        circle.fillColor = UIColor.systemRed.cgColor
    //        circle.position = CGPoint(x: imgRedButtonIcon.center.x - redButtonRadius, y: imgRedButtonIcon.center.y - redButtonRadius)
    //        circle.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
    //        circle.shadowRadius = 5
    //        circle.shadowOffset = .zero
    //        circle.shadowOpacity = 1
    //
    //
    //        redButton.tintColor = .white
    //        redButton.layer.addSublayer(circle)
    //        redButton.addSubview(imgRedButtonIcon)
    //
    //        self.tabBar.addSubview(redButton)
    //        redButton.addTarget(self, action: #selector(self.centerButtonAction), for: .touchUpInside)
    //    }
    
    
    

