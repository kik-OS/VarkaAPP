//
//  ProductInfoCollectionViewCell.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 08.05.2021.
//

import UIKit

final class ProductInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var numberOfCardLabel: UILabel!
    @IBOutlet private weak var instructionLabel: UILabel!
    @IBOutlet private weak var instructionImage: UIImageView!
    @IBOutlet private weak var nextLabel: UILabel!
    
    var viewModel: ProductInfoCollectionViewCellViewModelProtocol! {
        didSet {
            numberOfCardLabel.text = viewModel?.numberOfCard
            instructionImage.image = UIImage(named: viewModel.instrImage)
            instructionLabel.text = viewModel.getInstrLabel()
            nextLabel.isHidden = viewModel.isShowNextLabel
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.2
        layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.cornerRadius = 10
        clipsToBounds = false
    }
}
