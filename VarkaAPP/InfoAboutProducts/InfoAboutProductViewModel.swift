//
//  InfoAboutProductViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//


import Foundation
import BarcodeScanner

protocol InfoAboutProductViewMOdelProtocol: class {
    
}


class InfoAboutProductViewMOdel: InfoAboutProductViewMOdelProtocol {
    
}




//Настройка функций сканера
extension InfoAboutProductViewMOdel: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
//        label.text = code
        //        controller.dismiss(animated: true, completion: nil)
        //        controller.reset()
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
//        label.text = error.localizedDescription
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    //        let viewController = BarcodeScannerViewController()
    //        viewController.codeDelegate = self
    //        viewController.errorDelegate = self
    //        viewController.dismissalDelegate = self
    //
    //        present(viewController, animated: true, completion: nil)
    
}
