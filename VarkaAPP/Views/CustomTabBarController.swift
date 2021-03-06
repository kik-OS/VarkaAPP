//
//  CustomTabBarController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit

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
        
        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-30,
                                               y: -30, width: 60, height: 60))
        middleBtn.setImage(UIImage(systemName: "barcode.viewfinder"), for: .normal)
        middleBtn.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 35,
                                                                              weight: .thin), forImageIn: .normal)
        
        middleBtn.backgroundColor = .white
        middleBtn.layer.borderColor = UIColor.red.cgColor
        middleBtn.layer.borderWidth = 1
        middleBtn.layer.cornerRadius = 0.5 * middleBtn.bounds.size.width
        middleBtn.clipsToBounds = true
        middleBtn.tintColor = .red
        
        
        middleBtn.animationForCentralButton()
        
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.centerButtonAction), for: .touchUpInside)
        self.view.layoutIfNeeded()
    }
    
    
    @objc func centerButtonAction(sender: UIButton) {
        sender.animationForCentralButton()
        BarCodeScanerManager.shared.openBarCodeScaner { vc in
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}


extension UIButton {
    func animationForCentralButton() {
        let rotation = CASpringAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 4)
        rotation.duration = 6
        rotation.mass = 1
        layer.add(rotation, forKey: nil)
    }
}






