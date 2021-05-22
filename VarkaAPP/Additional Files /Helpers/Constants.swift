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
    static let productsCollectionMinimumLineSpacing: CGFloat = 20
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
    static let defaultCornerRadius: CGFloat = 20
    static let startTimerButtonEnabledColor = VarkaColors.mainColor
    static let startTimerButtonDisabledColor = UIColor.systemGray2
}

enum VarkaColors {
    static let mainColor: UIColor = #colorLiteral(red: 0.01163592655, green: 0.6774030924, blue: 0.0349067077, alpha: 1)
    
}
