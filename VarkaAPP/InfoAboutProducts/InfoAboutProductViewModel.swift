//
//  InfoAboutProductViewModel.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//


import Foundation
import BarcodeScanner

protocol InfoAboutProductViewMOdelProtocol: class {
    var codeFromScaner: String? { get set }
    
}


class InfoAboutProductViewMOdel: InfoAboutProductViewMOdelProtocol {
    var codeFromScaner: String?
    
}




