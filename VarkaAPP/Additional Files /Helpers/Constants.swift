//
//  Constants.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 06.03.2021.
//

import UIKit

struct Constants {
    static let leftDistanceToView: CGFloat = 40
    static let rightDistanceToView: CGFloat = 40
    static let productsCollectionMinimumLineSpacing: CGFloat = 10
    static let productsCollectionItemWidth = (UIScreen.main.bounds.width - Constants.leftDistanceToView - Constants.rightDistanceToView - (Constants.productsCollectionMinimumLineSpacing / 2)) / 2
}

enum popOverTableSize: Int {
    case width = 150
    case height = 160
}





