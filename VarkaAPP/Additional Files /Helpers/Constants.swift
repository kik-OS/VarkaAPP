//
//  Constants.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 06.03.2021.
//

import UIKit

struct ConstantsCollectionView {
    static let leftDistanceToView: CGFloat = 40
    static let rightDistanceToView: CGFloat = 40
    static let productsCollectionMinimumLineSpacing: CGFloat = 10
    static let productsCollectionItemWidth = (UIScreen.main.bounds.width - ConstantsCollectionView.leftDistanceToView - ConstantsCollectionView.rightDistanceToView - (ConstantsCollectionView.productsCollectionMinimumLineSpacing / 2)) / 2
}
enum Constants {
    static let categoryNames = ["Макароны", "Гречка", "Рис", "Пельмени", "Вареники", "Овсянка",
                                "Чечевица красная", "Чечевица зелёная", "Другое"]
}

enum popOverTableSize: Int {
    case width = 150
    case height = 160
}


