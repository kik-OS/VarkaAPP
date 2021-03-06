//
//  BarCodeScanerManager.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//


import BarcodeScanner



class BarCodeScanerManager: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    static let shared = BarCodeScanerManager()
    private init() {}
    
    
    internal func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
                
                controller.dismiss(animated: true, completion: nil)
                controller.reset()
    }
    
    internal func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
                print(error.localizedDescription)
    }
    
    internal func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func openBarCodeScaner(with complition: @escaping (BarcodeScannerViewController) -> Void) {
        let barCodeScaner = BarcodeScannerViewController()
        barCodeScaner.codeDelegate = self
        barCodeScaner.errorDelegate = self
        barCodeScaner.dismissalDelegate = self
        barCodeScaner.headerViewController.closeButton.tintColor = .red
        barCodeScaner.messageViewController.regularTintColor = .black
        barCodeScaner.messageViewController.textLabel.textColor = .black
        
        complition(barCodeScaner)
    }
    
}




