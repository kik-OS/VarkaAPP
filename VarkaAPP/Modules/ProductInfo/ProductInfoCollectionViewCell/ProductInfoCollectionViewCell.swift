//
//  ProductInfoCollectionViewCell.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 08.05.2021.
//

import UIKit

class ProductInfoCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
        layer.borderWidth = 0.3
        layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        clipsToBounds = false
    }
    
}
