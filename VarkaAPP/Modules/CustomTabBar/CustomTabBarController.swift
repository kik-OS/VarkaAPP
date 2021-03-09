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
        self.delegate = self
        setupMiddleButton()
        setupTabs()
    }
    
    func setupMiddleButton() {
        
        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-30,
                                               y: -30,
                                               width: 60,
                                               height: 60))
        
        middleBtn.setImage(UIImage(systemName: "barcode.viewfinder"), for: .normal)
        middleBtn.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 35,
                                                                              weight: .thin),
                                                                              forImageIn: .normal)
        
        middleBtn.backgroundColor = .white
        middleBtn.layer.borderColor = UIColor.white.cgColor
        middleBtn.layer.borderWidth = 1
        middleBtn.layer.cornerRadius = 0.5 * middleBtn.bounds.size.width
        middleBtn.clipsToBounds = true
        middleBtn.tintColor = .orange
        
        middleBtn.animationForCentralButton()
        middleBtn.addTarget(self, action: #selector(self.centerButtonAction), for: .touchUpInside)
        
        self.tabBar.addSubview(middleBtn)
        self.view.layoutIfNeeded()
    }
    
    
    @objc func centerButtonAction(sender: UIButton) {
        sender.animationForCentralButton()
        let barCodeScanerVC = BarcodeScannerViewController()
        barCodeScanerVC.codeDelegate = self
        barCodeScanerVC.errorDelegate = self
        barCodeScanerVC.dismissalDelegate = self
        present(barCodeScanerVC, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    
    private func setupTabs() {
        let productInfoViewModel = ProductInfoViewModel(product: nil)
        let productInfoVC = ProductInfoViewController(nibName: nil,
                                                      bundle: nil,
                                                      viewModel: productInfoViewModel)
        viewControllers?.append(productInfoVC)
    }
}


extension CustomTabBarController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
    }
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error.localizedDescription)
    }
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        dismiss(animated: true, completion: nil)
    }
}




