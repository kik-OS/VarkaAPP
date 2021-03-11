//
//  CustomTabBarController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit
import BarcodeScanner

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupMiddleButton()
        setupTabs()
    }
    
    
    // MARK: - Private methods
    
    private func setupTabs() {
        let productInfoViewModel = ProductInfoViewModel(product: nil)
        let productInfoVC = ProductInfoViewController(nibName: nil,
                                                      bundle: nil,
                                                      viewModel: productInfoViewModel)
        
        let recentProductsVC = RecentProductsViewController()
        productInfoVC.tabBarItem.title = "Как варить"
        productInfoVC.tabBarItem.image = UIImage(named: "pot.png")
        tabBar.tintColor = .systemIndigo
        
        recentProductsVC.tabBarItem.title = "Недавние продукты"
        recentProductsVC.tabBarItem.image = UIImage(named: "box.png")
        viewControllers = [productInfoVC, recentProductsVC]
    }
    
    
    private func setupMiddleButton() {
         
         let middleButton = UIButton(frame: CGRect(x: (view.bounds.width / 2) - 30,
                                                y: -30,
                                                width: 60,
                                                height: 60))
         
         middleButton.setImage(UIImage(systemName: "barcode.viewfinder"), for: .normal)
         middleButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 35,
                                                                               weight: .thin),
                                                                               forImageIn: .normal)
         middleButton.backgroundColor = .white
         middleButton.layer.borderColor = UIColor.white.cgColor
         middleButton.layer.borderWidth = 1
         middleButton.layer.cornerRadius = 0.5 * middleButton.bounds.size.width
         middleButton.clipsToBounds = true
         middleButton.tintColor = .systemIndigo
         middleButton.animationForCentralButton()
         middleButton.addTarget(self, action: #selector(centerButtonAction), for: .touchUpInside)
         
         tabBar.addSubview(middleButton)
         view.layoutIfNeeded()
     }
     
    @objc func centerButtonAction(sender: UIButton) {
        sender.animationForCentralButton()
        let barCodeScannerVC = BarcodeScannerViewController()
        barCodeScannerVC.codeDelegate = self
        barCodeScannerVC.errorDelegate = self
        barCodeScannerVC.dismissalDelegate = self
        barCodeScannerVC.modalPresentationStyle = .fullScreen
        present(barCodeScannerVC, animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension CustomTabBarController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        dismiss(animated: true)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error.localizedDescription)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        dismiss(animated: true)
    }
}




