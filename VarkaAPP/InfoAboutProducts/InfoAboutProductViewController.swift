//
//  InfoAboutProductViewController.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit
import BarcodeScanner


class InfoAboutProductViewController: UIViewController {
    
    @IBOutlet weak var barCodeLabel: UILabel!
    
    private var viewModel: InfoAboutProductViewMOdelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.isTranslucent = true
        
        
    }
    
    
//    func showBarCodeScaner() {
//        let barCodeScanerVC = BarcodeScannerViewController()
//        barCodeScanerVC.codeDelegate = self
//        barCodeScanerVC.errorDelegate = self
//        barCodeScanerVC.dismissalDelegate = self
////        barCodeScanerVC.modalPresentationStyle = .fullScreen
//        present(barCodeScanerVC, animated: true, completion: nil)
//    }
}



// MARK: BarCodeScanerDelegate
//extension InfoAboutProductViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
//
//    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
//        barCodeLabel.text = code
//        controller.dismiss(animated: true, completion: nil)
//        controller.reset()
//    }
//
//    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
//        print(error.localizedDescription)
//    }
//
//    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//}


