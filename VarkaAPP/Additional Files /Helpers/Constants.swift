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

enum DataConstants {
    static let categoryNames = ["Макароны", "Гречка", "Рис", "Пельмени", "Вареники", "Овсянка",
                                "Чечевица красная", "Чечевица зелёная", "Другое"]
}

enum PopOverTableSize: Int {
    case width = 150
    case height = 160
}

enum PickerViewForKBType {
    case category
    case waterRatio
}

enum ToolBarButtonsForKBType {
    case up
    case down
}

enum UIConstants {
    static let defaultCornerRadius: CGFloat = 10
    static let buttonEnabledColor = VarkaColors.mainColor
    static let buttonDisabledColor = UIColor.systemGray2
}

enum VarkaColors {
    static let mainColor: UIColor = .systemOrange
}
